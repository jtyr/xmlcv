#!/bin/bash

#####
##
## Description: Saxon wrapper
##
## (c) 2008-2011 Jiri Tyr
##
#####


##### Without resolver ###
## Saxon 8.x ##
#JAVA_OPTIONS="-jar /usr/share/saxon/lib/saxon8.jar"
#JAVA_OPTIONS="-jar /usr/share/saxon/lib/saxon.jar"
#####
##### Sith resolver (local catalogs) ###
## Saxon 8.x ##
#JAVA_OPTIONS="-cp '/usr/share/saxon/lib/saxon8.jar:/usr/share/xml-commons-resolver/lib/xml-commons-resolver.jar:/etc/xml' net.sf.saxon.Transform -x org.apache.xml.resolver.tools.ResolvingXMLReader -y org.apache.xml.resolver.tools.ResolvingXMLReader -r org.apache.xml.resolver.tools.CatalogResolver"
## saxon 6.5.x
JAVA_OPTIONS="-Xmx400m -cp '/usr/share/saxon-6.5/lib/saxon.jar:/usr/share/xml-commons-resolver/lib/xml-commons-resolver.jar:/etc/xml' com.icl.saxon.StyleSheet -x org.apache.xml.resolver.tools.ResolvingXMLReader -y org.apache.xml.resolver.tools.ResolvingXMLReader -r org.apache.xml.resolver.tools.CatalogResolver"
#####


LEN=${#BASH_ARGV[*]}
STDIN=""


for (( N=0; N<${LEN}; N++ )) ; do
  STR=${BASH_ARGV[${LEN}-1-$N]}
  SPACE=`expr index "${STR}", " "`
  EQUAL=`expr index "${STR}", "="`

  if [[ ${SPACE} != 0 ]] ; then
    if (( ${SPACE} > ${EQUAL} )) ; then
      STR="${STR/=/=\"}\""
    else
      STR="\"${STR}\""
    fi
  fi

  STDIN="${STDIN} ${STR}"
done


echo "java ${JAVA_OPTIONS}${STDIN}" | awk '{system($0)}'
