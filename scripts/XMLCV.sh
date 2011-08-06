#!/bin/bash

#####
##
## Description: Shell script for XMLCV
##
## (c) 2011 Jiri Tyr
##
#####

# Include commons
source '../../xmlcv-0.4/scripts/commons.sh'

# Define input parameters for saxon
XSLT_INPUT_P="${XSLT_INPUT} ${ROLE_P}"

# Do not wrap lines for email output
if [[ ${OUT_FORMAT} == 'email' ]]; then XSLT_INPUT_P="${XSLT_INPUT_P} line_length='3000' noindent='yes'"; fi

echo '### Used command:'
echo -e "ROLE=\"${ROLE}\" $0 ${OUT_FORMAT}\n"

# Generate the output file
generate
