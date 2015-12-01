// Copyright (c) 2009-2011, Tor M. Aamodt, Inderpreet Singh
// The University of British Columbia
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, this
// list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
// Neither the name of The University of British Columbia nor the names of its
// contributors may be used to endorse or promote products derived from this
// software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include "scoreboard.h"
#include "shader.h"
#include "../cuda-sim/ptx_sim.h"
#include "shader_trace.h"


//Constructor
Scoreboard::Scoreboard( unsigned sid, unsigned n_warps )
: longopregs()
{
	m_sid = sid;
	//Initialize size of table
	reg_table.resize(n_warps);
	longopregs.resize(n_warps);

	// gunjae: initialization of deterministic / undeterministic register table
	det_regs.resize( n_warps );
	undet_regs.resize( n_warps );

	// gunjae
	m_max_reg_id = 0;
}

// Print scoreboard contents
void Scoreboard::printContents() const
{
	printf("scoreboard contents (sid=%d): \n", m_sid);
	for(unsigned i=0; i<reg_table.size(); i++) {
		if(reg_table[i].size() == 0 ) continue;
		printf("  wid = %2d: ", i);
		std::set<unsigned>::const_iterator it;
		for( it=reg_table[i].begin() ; it != reg_table[i].end(); it++ )
			printf("%u ", *it);
		printf("\n");
	}
}

// gunjae: print max. register id
void Scoreboard::print_max_reg_id( FILE *fp ) const
{
	fprintf(fp, "GK: Max register id for S(%02d) = %2d\n", m_sid, m_max_reg_id);
}

void Scoreboard::reserveRegister(unsigned wid, unsigned regnum) 
{
	if( !(reg_table[wid].find(regnum) == reg_table[wid].end()) ){
		printf("Error: trying to reserve an already reserved register (sid=%d, wid=%d, regnum=%d).", m_sid, wid, regnum);
        abort();
	}
    SHADER_DPRINTF( SCOREBOARD,
                    "Reserved Register - warp:%d, reg: %d\n", wid, regnum );
	reg_table[wid].insert(regnum);
	// gunjae
	if (regnum > m_max_reg_id)
		m_max_reg_id = regnum;
}

// Unmark register as write-pending
void Scoreboard::releaseRegister(unsigned wid, unsigned regnum) 
{
	if( !(reg_table[wid].find(regnum) != reg_table[wid].end()) ) 
        return;
    SHADER_DPRINTF( SCOREBOARD,
                    "Release register - warp:%d, reg: %d\n", wid, regnum );
	reg_table[wid].erase(regnum);
	// gunjae: BUGFIX
	longopregs[wid].erase(regnum);
}

const bool Scoreboard::islongop (unsigned warp_id,unsigned regnum) {
	return longopregs[warp_id].find(regnum) != longopregs[warp_id].end();
}

// gunjae
bool Scoreboard::is_undet ( unsigned warp_id, unsigned regnum ) const {
	return undet_regs[warp_id].find(regnum) != undet_regs[warp_id].end();
}

bool Scoreboard::is_det ( unsigned warp_id, unsigned regnum ) const {
	return det_regs[warp_id].find(regnum) != det_regs[warp_id].end();
}

void Scoreboard::reserveRegisters(const class warp_inst_t* inst) 
{
    for( unsigned r=0; r < 4; r++) {
        if(inst->out[r] > 0) {
            reserveRegister(inst->warp_id(), inst->out[r]);
            SHADER_DPRINTF( SCOREBOARD,
                            "Reserved register - warp:%d, reg: %d\n",
                            inst->warp_id(),
                            inst->out[r] );
        }
    }

    //Keep track of long operations
    if (inst->is_load() &&
    		(	inst->space.get_type() == global_space ||
    			inst->space.get_type() == local_space ||
                inst->space.get_type() == param_space_kernel ||
                inst->space.get_type() == param_space_local ||
                inst->space.get_type() == param_space_unclassified ||
    			inst->space.get_type() == tex_space)){
    	for ( unsigned r=0; r<4; r++) {
    		if(inst->out[r] > 0) {
                SHADER_DPRINTF( SCOREBOARD,
                                "New longopreg marked - warp:%d, reg: %d\n",
                                inst->warp_id(),
                                inst->out[r] );
                longopregs[inst->warp_id()].insert(inst->out[r]);
            }
    	}
    }

	// gunjae: collect input registers
	std::set<int> in_regs;
	
	if(inst->in[0] > 0) in_regs.insert(inst->in[0]);
	if(inst->in[1] > 0) in_regs.insert(inst->in[1]);
	if(inst->in[2] > 0) in_regs.insert(inst->in[2]);
	if(inst->in[3] > 0) in_regs.insert(inst->in[3]);
	//if(inst->pred > 0) in_regs.insert(inst->pred);
	if(inst->ar1 > 0) in_regs.insert(inst->ar1);
	if(inst->ar2 > 0) in_regs.insert(inst->ar2);

	std::set<int>::const_iterator it;
	
	// gunjae: check whether input register are undeterministic
	bool undet_value = false;
	for ( it=in_regs.begin(); it!=in_regs.end(); ++it ) {
		if ( *it > 0 ) {
			if ( is_undet( inst->warp_id(), *it ) )
				undet_value = true;
		}
	}

	// gunjae: mark undeterministic register value table (data from global memory, shared memory or texture data
	if ( ( undet_value ) || 
	     ( inst->is_load() && ( inst->space.get_type() == global_space ||
			 					inst->space.get_type() == local_space  ||
								inst->space.get_type() == shared_space ||
			 					inst->space.get_type() == tex_space ) ) ) {
		for ( unsigned r = 0; r < 4; r++ ) {
			if ( inst->out[r] > 0 )
				undet_regs[ inst->warp_id() ].insert( inst->out[r] );
		}
	}

//	if ( undet_value ) {
//		for ( unsigned r = 0; r < 4; r++ ) {
//			if ( inst->out[r] > 0 )
//				undet_regs[ inst->warp_id() ].insert( inst->out[r] );
//		}
//	}

	// gunjae: mark deterministic register value table (data from parameters, cta id or cta id)
	// check an instruction requires data from register files. if not, the output will be deterministic
	// because data will be come from cta id or thread id
	bool det_value = true;
	for ( it=in_regs.begin(); it!=in_regs.end(); ++it ) {
		if ( *it > 0 ) {
			if ( !is_det( inst->warp_id(), *it ) )
				det_value = false;
		}
	}
	     
	if ( inst->is_load() && ( inst->space.get_type() == global_space ||
			 			  	  inst->space.get_type() == local_space  ||
							  inst->space.get_type() == shared_space ||
			 				  inst->space.get_type() == tex_space ) ) {
		det_value = false;
	}

	bool empty_in_reg = in_regs.empty();
//	for ( unsigned r = 0; r < 4; r++ ) {
//		if ( inst->in[r] > 0 ) {
//			in_regs = true;
//			break;
//		}
//	}

	bool cond_det = false;
	if ( ( empty_in_reg ) || ( det_value ) ||
		 ( inst->is_load() && ( inst->space.get_type()==param_space_kernel ||
								inst->space.get_type()==param_space_local  ||
								inst->space.get_type()==param_space_unclassified) ) ) {
		cond_det = true;
		for ( unsigned r = 0; r < 4; r++ ) {
			if ( inst->out[r] > 0 )
				det_regs[ inst->warp_id() ].insert( inst->out[r] );
		}
	}
	
//	if ((m_sid==EN_RPT_SID) || (-1==EN_RPT_SID)) {
//		printf("empty_in_reg=%c, det_Value=%c, cond=%c, ", empty_in_reg?'Y':'N', det_value?'Y':'N', cond_det?'Y':'N');
//		printf("%d, %d, %d, %d, ", inst->in[0], inst->in[1], inst->in[2], inst->in[3]);
//		printf("%d, %d, %d, ", inst->pred, inst->ar1, inst->ar2);
//		inst->print_insn(stdout);
//		printf("\n");
//	}

//	if ( det_value ) {
//		for ( unsigned r = 0; r < 4; r++ ) {
//			if ( inst->out[r] > 0 )
//				det_regs[ inst->warp_id() ].insert( inst->out[r] );
//		}
//	}
}

// Release registers for an instruction
void Scoreboard::releaseRegisters(const class warp_inst_t *inst) 
{
    for( unsigned r=0; r < 4; r++) {
        if(inst->out[r] > 0) {
            SHADER_DPRINTF( SCOREBOARD,
                            "Register Released - warp:%d, reg: %d\n",
                            inst->warp_id(),
                            inst->out[r] );
            releaseRegister(inst->warp_id(), inst->out[r]);
            // gunjae: BUGFIX
			//longopregs[inst->warp_id()].erase(inst->out[r]);
        }
    }
}

/** 
 * Checks to see if registers used by an instruction are reserved in the scoreboard
 *  
 * @return 
 * true if WAW or RAW hazard (no WAR since in-order issue)
 **/ 
bool Scoreboard::checkCollision( unsigned wid, const class inst_t *inst ) const
{
	// Get list of all input and output registers
	std::set<int> inst_regs;

	if(inst->out[0] > 0) inst_regs.insert(inst->out[0]);
	if(inst->out[1] > 0) inst_regs.insert(inst->out[1]);
	if(inst->out[2] > 0) inst_regs.insert(inst->out[2]);
	if(inst->out[3] > 0) inst_regs.insert(inst->out[3]);
	if(inst->in[0] > 0) inst_regs.insert(inst->in[0]);
	if(inst->in[1] > 0) inst_regs.insert(inst->in[1]);
	if(inst->in[2] > 0) inst_regs.insert(inst->in[2]);
	if(inst->in[3] > 0) inst_regs.insert(inst->in[3]);
	if(inst->pred > 0) inst_regs.insert(inst->pred);
	if(inst->ar1 > 0) inst_regs.insert(inst->ar1);
	if(inst->ar2 > 0) inst_regs.insert(inst->ar2);

	// Check for collision, get the intersection of reserved registers and instruction registers
	std::set<int>::const_iterator it2;
	for ( it2=inst_regs.begin() ; it2 != inst_regs.end(); it2++ )
		if(reg_table[wid].find(*it2) != reg_table[wid].end()) {
			return true;
		}
	return false;
}

bool Scoreboard::pendingWrites(unsigned wid) const
{
	return !reg_table[wid].empty();
}


// gunjae: print undet_regs
void Scoreboard::print_undet_regs( FILE *fp ) const
{
	fprintf(fp, " GK: contents of undet_regs (sid=%02u): \n", m_sid);
	for ( unsigned i=0; i < undet_regs.size(); i++ ) {
		if ( undet_regs[i].empty() ) continue;
		fprintf(fp, "  w[%02u]: ", i);
		std::set<unsigned>::const_iterator it;
		for ( it=undet_regs[i].begin(); it!=undet_regs[i].end(); ++it ) {
			fprintf(fp, "%u, ", *it);
		}
		fprintf(fp, "\n");
	}
	fprintf(fp, " -----------------------------------------------\n");
}

// gunjae: print det_regs
void Scoreboard::print_det_regs( FILE *fp ) const
{
	fprintf(fp, " GK: contents of det_regs (sid=%02u): \n", m_sid);
	for ( unsigned i=0; i < det_regs.size(); i++ ) {
		if ( det_regs[i].empty() ) continue;
		fprintf(fp, "  w[%02u]: ", i);
		std::set<unsigned>::const_iterator it;
		for ( it=det_regs[i].begin(); it!=det_regs[i].end(); ++it ) {
			fprintf(fp, "%u, ", *it);
		}
		fprintf(fp, "\n");
	}
	fprintf(fp, " -----------------------------------------------\n");
}

// gunjae: check undeterministic register data for prefetching
bool Scoreboard::check_undet( unsigned wid, const inst_t *inst ) const
{
	// Get list of input registers
	std::set<int> inst_regs;

	if(inst->in[0] > 0) inst_regs.insert(inst->in[0]);
	if(inst->in[1] > 0) inst_regs.insert(inst->in[1]);
	if(inst->in[2] > 0) inst_regs.insert(inst->in[2]);
	if(inst->in[3] > 0) inst_regs.insert(inst->in[3]);
	if(inst->ar1 > 0) inst_regs.insert(inst->ar1);
	if(inst->ar2 > 0) inst_regs.insert(inst->ar2);

	// Check for undeterministic value, get the intersection of reserved registers and instruction registers
	std::set<int>::const_iterator it2;
	for ( it2=inst_regs.begin() ; it2 != inst_regs.end(); it2++ )
		if( undet_regs[wid].find(*it2) != undet_regs[wid].end()) {
			return true;
		}
	return false;
}

// gunjae: check undeterministic register data for prefetching
bool Scoreboard::check_det( unsigned wid, const inst_t *inst ) const
{
	// Get list of input registers
	std::set<int> inst_regs;

	if(inst->in[0] > 0) inst_regs.insert(inst->in[0]);
	if(inst->in[1] > 0) inst_regs.insert(inst->in[1]);
	if(inst->in[2] > 0) inst_regs.insert(inst->in[2]);
	if(inst->in[3] > 0) inst_regs.insert(inst->in[3]);
	if(inst->ar1 > 0) inst_regs.insert(inst->ar1);
	if(inst->ar2 > 0) inst_regs.insert(inst->ar2);

	// Check for deterministic value, get the intersection of reserved registers and instruction registers
	// if all inputs are deterministic value, it is ture
	std::set<int>::const_iterator it2;
	for ( it2=inst_regs.begin() ; it2 != inst_regs.end(); it2++ )
		if( undet_regs[wid].find(*it2) != undet_regs[wid].end()) {
			return false;
		}
	return true;
}
