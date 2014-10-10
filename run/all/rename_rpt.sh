#!/bin/bash

## base file name (ex: BFS)
BASE="$1"

echo " Renaming gpgpu-sim report files"
echo "  by Gunjae Koo (gunjae.koo@gmail.com)"

if [ "$BASE" = "" ]; then
	echo ""
	echo "Error: please define base file name!"
	echo " ---------------------------------- "
	echo " usage: $0 {base_filename}"
	echo " ---------------------------------- "
	echo ""
else
	echo " renaming report files with base ${BASE}"
	mv -f gpugj.rpt ${BASE}.rpt
	mv -f gpugj_LdIssGap.rpt ${BASE}_LdIssGap.rpt
	mv -f gpugj_LdStat.rpt ${BASE}_LdStat.rpt
	mv -f gpugj_LdLat.rpt ${BASE}_LdLat.rpt
	mv -f gpugj_LdIss.rpt ${BASE}_LdIss.rpt
	gzip ${BASE}*.rpt
fi
