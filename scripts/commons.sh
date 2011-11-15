#!/bin/bash

#####
##
## Description: Commons for XMLCV and XMLCL shell scripts
##
## (c) 2011 Jiri Tyr
##
#####

# Default path to the root of the XMLCV project
if [ -z ${MAIN_PATH} ]; then MAIN_PATH='../../xmlcv-0.4'; fi

# Default project name
if [ -z ${PROJECT} ]; then PROJECT='cv'; fi

# Default date (current date)
if [ -z ${DATE} ]; then DATE=$(date "+current_date=\"%d/%m/%Y\""); fi

# Default path to the FOP config file
if [ -z ${FOP_CONF} ]; then FOP_CONF="${MAIN_PATH}/etc/xml/fop/conf/myfop.xconf"; fi

# Default paths to the executables
if [ -z ${XMLLINT} ]; then XMLLINT='xmllint'; fi
if [ -z ${SAXON} ]; then SAXON='saxon'; fi
if [ -z ${FOP} ]; then FOP='fop'; fi

# Default path to the validation schema of the project
if [ -z ${RNG} ]; then RNG="${MAIN_PATH}/rng/xml${PROJECT}.rng"; fi

# Default path to the FO template
if [ -z ${XSL_FO} ]; then XSL_FO="${MAIN_PATH}/xsl/xml${PROJECT}-fo.xsl"; fi
# Default path to the TXT template
if [ -z ${XSL_TXT} ]; then XSL_TXT="${MAIN_PATH}/xsl/xml${PROJECT}-txt.xsl"; fi
# Default path to the XHTML template
if [ -z ${XSL_XHTML} ]; then XSL_XHTML="${MAIN_PATH}/xsl/xml${PROJECT}-xhtml.xsl"; fi

# Default path to the XML source file
if [ -z ${SRC_PATH} ]; then SRC_PATH=$(pwd); fi
# Default languagge of the XML source file
if [ -z ${SRC_LANG} ]; then SRC_LANG='en'; fi
# Default XML source file
if [ -z ${SRC} ]; then SRC="${SRC_PATH}/${PROJECT}-${SRC_LANG}.xml"; fi

# Default role
if [[ -n ${ROLE} && ${#ROLE} ]]; then ROLE_P="role=\"${ROLE}\""; fi

# Default output path
if [ -z ${OUT_PATH} ]; then OUT_PATH='.'; fi
# Default output label
if [[ -n ${OUT_LABEL} ]]; then OUT_LABEL="_${OUT_LABEL}"; fi
# Default output file
if [ -z ${OUT} ]; then OUT="${OUT_PATH}/${PROJECT}-${SRC_LANG}${OUT_LABEL}"; fi

# Output format
if [[ -n $1 && -z ${OUT_FORMAT} ]]; then OUT_FORMAT="$1"; fi
if [ -z ${OUT_FORMAT} ]; then OUT_FORMAT='pdf'; fi

# Function which generats the final output
function generate() {
	# Add src_path as a parameter for Saxon
	XSLT_INPUT_P="${XSLT_INPUT_P} src_path=${SRC_PATH}"

	if [ ${OUT_FORMAT,,} == 'validate' ]; then
		echo '### Validating the source file:'
		${XMLLINT} --noout --relaxng ${RNG} ${SRC}
	elif [ ${OUT_FORMAT,,} == 'pdf' ]; then
		echo '### Generating PDF file:'
		${SAXON} -o ${OUT}.fo ${SRC} ${XSL_FO} ${DATE} ${XSLT_INPUT_P} && ${FOP} -c ${FOP_CONF} -fo ${OUT}.fo -pdf ${OUT}.pdf
		rm -f ${OUT}.fo
	elif [[ ${OUT_FORMAT,,} == 'txt' || ${OUT_FORMAT,,} == 'email' ]]; then
		echo '### Generating TXT file:'
		${SAXON} -o ${OUT}.txt ${SRC} ${XSL_TXT} ${DATE} ${XSLT_INPUT_P}
	elif [[ ${OUT_FORMAT,,} == 'html' || ${OUT_FORMAT,,} == 'xhtml' ]]; then
		echo '### Generating HTML file:'
		${SAXON} -o ${OUT}.html ${SRC} ${XSL_XHTML} ${DATE} ${XSLT_INPUT_P}
		# Tide up the code and replace the CSS and IMG references by Base64 string
		if [ -e '/usr/bin/tidy' ]; then
			/usr/bin/tidy -utf8 -iqm -w 0 ${OUT}.html 2>/dev/null
			sed -i -r "s/<link media=\"screen\" href=\".[^\"]+\"/<link media=\"screen\" href=\"data:text\/css;base64,`grep '<link' ${OUT}.html | sed -r 's/.* href=\"(.[^\"]+)\" .*/\1/' | xargs base64 -w 0 | sed 's,/,\\\/,g'`\"/" ${OUT}.html
			sed -i -r "s/<img src=\".[^.]+\.(.[^\"]+)\"/<img src=\"data:image\/\1;base64,`grep '<img' ${OUT}.html | sed -r 's/.* src=\"(.[^\"]+)\" .*/\1/' | xargs base64 -w 0 | sed 's,/,\\\/,g'`\"/" ${OUT}.html
		fi
	else
		echo 'Unknown output format!'
	fi
}
