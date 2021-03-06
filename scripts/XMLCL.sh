#!/bin/bash

#####
##
## Description: Shell script for XMLCL
##
## (c) 2011 Jiri Tyr
##
#####

# Show the usage if there is no input parameter
if [[ -z ${RECIPIENT} || -z ${POST} ]]; then
	echo 'Usage:'
	echo -e "RECIPIENT=\"\" POST=\"\" JOB_LISTING=\"\" SALUTATION=\"\" ROLE=\"\" $0 <format>"
	exit 1
fi

# Redefine the project name
PROJECT='cl'

# Language
if [ -z $2 ]; then
	SRC_LANG='en'
else
	SRC_LANG="$2"
fi

# Redefine the output file name
if [ -z ${OUT} ]; then
	F_POST=`echo "${POST}" | LC_ALL="en_US.UTF-8" iconv -f UTF-8 -t 'ascii//TRANSLIT'`
	F_POST=${F_POST//\'/_}
	F_POST=${F_POST// /_}
	F_POST=${F_POST//\//_}
	OUT="${PROJECT}-${SRC_LANG}_${RECIPIENT}-${F_POST}"
fi

# Include commons
source '../../xmlcv/scripts/commons.sh'

# Generate input parameters for XSL template
if [[ -n ${RECIPIENT} && ${#RECIPIENT} ]]; then RECIPIENT_P="recipient=\"${RECIPIENT}\""; fi
if [[ -n ${POST} && ${#POST} ]]; then POST_P="post=\"${POST}\""; fi
if [[ -n ${JOB_LISTING} && ${#JOB_LISTING} ]]; then JOB_LISTING_P="job-listing=\"${JOB_LISTING}\""; fi
if [[ -n ${SALUTATION} && ${#SALUTATION} ]]; then SALUTATION_P="salutation=\"${SALUTATION}\""; fi

# Define input parameters for saxon
XSLT_INPUT_P="${XSLT_INPUT} ${RECIPIENT_P} ${POST_P} ${JOB_LISTING_P} ${SALUTATION_P} ${ROLE_P}"

# Add OUT_PATH to the OUT
OUT="${OUT_PATH}/${OUT}"

# Show which command was executed
echo '### Used command:'
echo -e "RECIPIENT=\"${RECIPIENT}\" POST=\"${POST}\" JOB_LISTING=\"${JOB_LISTING}\" SALUTATION=\"${SALUTATION}\" $0 ${OUT_FORMAT}\n"

# Do not wrap lines for email output
if [[ ${OUT_FORMAT} == 'email' ]]; then XSLT_INPUT_P="${XSLT_INPUT_P} line_length='3000' noindent='yes'"; fi

# Generate the output file
generate
