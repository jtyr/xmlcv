<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: Utilities - shared template
  **
  ** (c) Jiri Tyr 2008-2011
  **********************************************************
  -->


<!DOCTYPE xsl:stylesheet [
  <!-- entities used in this document - necessary for Firefox -->
  <!-- if you are missing some entity, just add it from external entities files -->
  <!ENTITY nbsp		"&#x00A0;">
  <!ENTITY rdquor	"&#x201C;">
  <!ENTITY ldquor	"&#x201E;">

  <!-- external entities - doesn't work in Firefox -->
  <!ENTITY % ISOlat1 SYSTEM '../ent/iso-lat1.ent'>
  %ISOlat1;
  <!ENTITY % ISOnum  SYSTEM '../ent/iso-num.ent'>
  %ISOnum;
  <!ENTITY % ISOpub  SYSTEM '../ent/iso-pub.ent'>
  %ISOpub;
]>


<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<!--
 #######################
 ## U T I L I T I E S ##
 #######################
-->

<!-- return upper-case text -->
<xsl:template name="upper-case">
  <xsl:param name="string"/>

  <xsl:call-template name="replace-by-template">
    <xsl:with-param name="string" select="$string"/>
    <xsl:with-param name="from" select="$lc_char"/>
    <xsl:with-param name="to" select="$uc_char"/>
  </xsl:call-template>
</xsl:template>


<!-- return lower-case text -->
<xsl:template name="lower-case">
  <xsl:param name="string"/>

  <xsl:call-template name="replace-by-template">
    <xsl:with-param name="string" select="$string"/>
    <xsl:with-param name="from" select="$uc_char"/>
    <xsl:with-param name="to" select="$lc_char"/>
  </xsl:call-template>
</xsl:template>


<!-- replace text by template -->
<xsl:template name="replace-by-template">
  <xsl:param name="string"/>
  <xsl:param name="from"/>
  <xsl:param name="to"/>

  <xsl:choose>
    <xsl:when test="string-length($from) and string-length($to)">
      <xsl:variable name="text">
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="$string"/>
          <xsl:with-param name="replace" select="substring($from, 1, 1)"/>
          <xsl:with-param name="with" select="substring($to, 1, 1)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="replace-by-template">
        <xsl:with-param name="string" select="$text"/>
        <xsl:with-param name="from" select="substring($from, 2, string-length($from)-1)"/>
        <xsl:with-param name="to" select="substring($to, 2, string-length($to)-1)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- replace string -->
<xsl:template name="replace-string">
  <xsl:param name="text"/>
  <xsl:param name="replace"/>
  <xsl:param name="with"/>

  <xsl:choose>
    <xsl:when test="contains($text, $replace)">
      <xsl:value-of select="substring-before($text, $replace)"/>
      <xsl:value-of select="$with"/>
      <xsl:call-template name="replace-string">
        <xsl:with-param name="text" select="substring-after($text, $replace)"/>
        <xsl:with-param name="replace" select="$replace"/>
        <xsl:with-param name="with" select="$with"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- return date -->
<xsl:template name="getDate">
  <xsl:param name="date"/>

  <xsl:variable name="month" select="substring($date, 1, 2)"/>
  <xsl:variable name="year" select="substring($date, 4, 4)"/>

  <xsl:choose>
    <xsl:when test="$month = 1">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_jan'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="$month = 2">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_feb'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="$month = 3">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_mar'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="$month = 4">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_apr'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="$month = 5">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_may'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="$month = 6">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_jun'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="$month = 7">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_jul'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="$month = 8">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_aug'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="$month = 9">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_sep'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="$month = 10">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_oct'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="$month = 11">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_nov'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="$month = 12">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_dec'"/></xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_other'"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:value-of select="$year"/>
</xsl:template>


<!-- return full date in language specific format -->
<xsl:template name="getDateFormat">
  <xsl:param name="format"/>
  <xsl:param name="date"/>

  <xsl:choose>
    <!-- dd/mm/yyyy -->
    <xsl:when test="string-length($date) = 10">
      <xsl:call-template name="getDateFormatReplace">
        <xsl:with-param name="format" select="$format"/>
        <xsl:with-param name="day" select="substring($date, 1, 2)"/>
        <xsl:with-param name="month" select="substring($date, 4, 2)"/>
        <xsl:with-param name="year" select="substring($date, 7, 4)"/>
      </xsl:call-template>
    </xsl:when>
    <!-- mm/yyyy -->
    <xsl:when test="string-length($date) = 7">
      <xsl:call-template name="getDateFormatReplace">
        <xsl:with-param name="format" select="$format"/>
        <xsl:with-param name="month" select="substring($date, 1, 2)"/>
        <xsl:with-param name="year" select="substring($date, 4, 4)"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- return full date in language specific format -->
<xsl:template name="getDateFormatReplace">
  <xsl:param name="format"/>
  <xsl:param name="day"/>
  <xsl:param name="month"/>
  <xsl:param name="year"/>

  <!-- replace day -->
  <xsl:variable name="tmp_day">
    <xsl:choose>
      <xsl:when test="string-length($day)">
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="$format"/>
          <xsl:with-param name="replace" select="'%d'"/>
          <xsl:with-param name="with" select="$day"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$format"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- replace month -->
  <xsl:variable name="tmp_month1">
    <xsl:call-template name="replace-string">
      <xsl:with-param name="text" select="$tmp_day"/>
      <xsl:with-param name="replace" select="'%m'"/>
      <xsl:with-param name="with" select="$month"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="tmp_month2">
    <xsl:call-template name="getDateFormatReplaceMonth">
      <xsl:with-param name="format" select="$tmp_month1"/>
      <xsl:with-param name="type" select="'%b'"/>
      <xsl:with-param name="month" select="$month"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="tmp_month3">
    <xsl:call-template name="getDateFormatReplaceMonth">
      <xsl:with-param name="format" select="$tmp_month2"/>
      <xsl:with-param name="type" select="'%B'"/>
      <xsl:with-param name="month" select="$month"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- replace year -->
  <xsl:variable name="tmp_year1">
    <xsl:call-template name="replace-string">
      <xsl:with-param name="text" select="$tmp_month3"/>
      <xsl:with-param name="replace" select="'%y'"/>
      <xsl:with-param name="with" select="substring($year, 3)"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="tmp_year2">
    <xsl:call-template name="replace-string">
      <xsl:with-param name="text" select="$tmp_year1"/>
      <xsl:with-param name="replace" select="'%Y'"/>
      <xsl:with-param name="with" select="$year"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:value-of select="$tmp_year2"/>
</xsl:template>


<!-- replace month with particular month name -->
<xsl:template name="getDateFormatReplaceMonth">
  <xsl:param name="format"/>
  <xsl:param name="type"/>
  <xsl:param name="month"/>

  <xsl:variable name="kind">
    <xsl:if test="$type = '%B'">
      <xsl:text>_full</xsl:text>
    </xsl:if>
  </xsl:variable>

  <xsl:call-template name="replace-string">
    <xsl:with-param name="text" select="$format"/>
    <xsl:with-param name="replace" select="$type"/>
    <xsl:with-param name="with">
      <xsl:choose>
        <xsl:when test="$month = 1">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_jan')"/></xsl:call-template>
        </xsl:when>
        <xsl:when test="$month = 2">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_feb')"/></xsl:call-template>
        </xsl:when>
        <xsl:when test="$month = 3">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_mar')"/></xsl:call-template>
        </xsl:when>
        <xsl:when test="$month = 4">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_apr')"/></xsl:call-template>
        </xsl:when>
        <xsl:when test="$month = 5">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_may')"/></xsl:call-template>
        </xsl:when>
        <xsl:when test="$month = 6">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_jun')"/></xsl:call-template>
        </xsl:when>
        <xsl:when test="$month = 7">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_jul')"/></xsl:call-template>
        </xsl:when>
        <xsl:when test="$month = 8">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_aug')"/></xsl:call-template>
        </xsl:when>
        <xsl:when test="$month = 9">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_sep')"/></xsl:call-template>
        </xsl:when>
        <xsl:when test="$month = 10">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_oct')"/></xsl:call-template>
        </xsl:when>
        <xsl:when test="$month = 11">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_nov')"/></xsl:call-template>
        </xsl:when>
        <xsl:when test="$month = 12">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="concat('date', $kind, '_dec')"/></xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'date_other'"/></xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!-- get specific cell name -->
<xsl:template name="getCellName">
  <xsl:param name="type"/>
  <xsl:param name="cell"/>

  <xsl:choose>
    <xsl:when test="$type = 1">
      <xsl:choose>
        <xsl:when test="$cell = 4"><xsl:call-template name="getText"><xsl:with-param name="id" select="'unix'"/></xsl:call-template></xsl:when>
        <xsl:when test="$cell = 5"><xsl:call-template name="getText"><xsl:with-param name="id" select="'windows'"/></xsl:call-template></xsl:when>
        <xsl:when test="$cell = 6"></xsl:when>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$type = 2">
      <xsl:choose>
        <xsl:when test="$cell = 4"><xsl:call-template name="getText"><xsl:with-param name="id" select="'user'"/></xsl:call-template></xsl:when>
        <xsl:when test="$cell = 5"><xsl:call-template name="getText"><xsl:with-param name="id" select="'admin'"/></xsl:call-template></xsl:when>
        <xsl:when test="$cell = 6"><xsl:call-template name="getText"><xsl:with-param name="id" select="'developer'"/></xsl:call-template></xsl:when>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$type = 3">
      <xsl:choose>
        <xsl:when test="$cell = 4"><xsl:call-template name="getText"><xsl:with-param name="id" select="'consultant'"/></xsl:call-template></xsl:when>
        <xsl:when test="$cell = 5"><xsl:call-template name="getText"><xsl:with-param name="id" select="'admin'"/></xsl:call-template></xsl:when>
        <xsl:when test="$cell = 6"><xsl:call-template name="getText"><xsl:with-param name="id" select="'developer'"/></xsl:call-template></xsl:when>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$type = 4">
      <xsl:choose>
        <xsl:when test="4"></xsl:when>
        <xsl:when test="5"></xsl:when>
        <xsl:when test="6"></xsl:when>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- get specific lang level label -->
<xsl:template name="getLangLevelLabel">
  <xsl:param name="level"/>

  <xsl:choose>
    <xsl:when test="$level = 0"><xsl:call-template name="getText"><xsl:with-param name="id" select="'mother_tongue'"/></xsl:call-template></xsl:when>
    <xsl:when test="$level = 1"><xsl:call-template name="getText"><xsl:with-param name="id" select="'c2'"/></xsl:call-template></xsl:when>
    <xsl:when test="$level = 2"><xsl:call-template name="getText"><xsl:with-param name="id" select="'c1'"/></xsl:call-template></xsl:when>
    <xsl:when test="$level = 3"><xsl:call-template name="getText"><xsl:with-param name="id" select="'b2'"/></xsl:call-template></xsl:when>
    <xsl:when test="$level = 4"><xsl:call-template name="getText"><xsl:with-param name="id" select="'b1'"/></xsl:call-template></xsl:when>
    <xsl:when test="$level = 5"><xsl:call-template name="getText"><xsl:with-param name="id" select="'a2'"/></xsl:call-template></xsl:when>
    <xsl:when test="$level = 6"><xsl:call-template name="getText"><xsl:with-param name="id" select="'a1'"/></xsl:call-template></xsl:when>
    <xsl:otherwise><xsl:value-of select="$level"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- get specific lang level code -->
<xsl:template name="getLangLevelCode">
  <xsl:param name="level"/>

  <xsl:choose>
    <xsl:when test="$level = 1">C2</xsl:when>
    <xsl:when test="$level = 2">C1</xsl:when>
    <xsl:when test="$level = 3">B2</xsl:when>
    <xsl:when test="$level = 4">B1</xsl:when>
    <xsl:when test="$level = 5">A2</xsl:when>
    <xsl:when test="$level = 6">A1</xsl:when>
  </xsl:choose>
</xsl:template>


<!-- prints one end of line (only for TXT) -->
<xsl:template name="printNewLine">
  <xsl:param name="count" select="1"/>

  <xsl:value-of select="$end_of_line"/>

  <xsl:if test="$count > 1">
    <xsl:call-template name="printNewLine">
      <xsl:with-param name="count" select="$count - 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- prints title bullet (only for TXT) -->
<xsl:template name="printTitleBullet">
  <xsl:value-of select="$title_bullet"/>
</xsl:template>


<!-- print char in loop -->
<xsl:template name="for.loop">
  <xsl:param name="i" select="1"/>
  <xsl:param name="count"/>
  <xsl:param name="char" select="'#'"/>

  <!-- line by line output -->
  <xsl:if test="$i &lt;= $count">
    <xsl:value-of select="$char"/>
  </xsl:if>

  <!-- repeat the loop until finished -->
  <xsl:if test="$i &lt;= $count">
    <xsl:call-template name="for.loop">
      <xsl:with-param name="i" select="$i + 1"/>
      <xsl:with-param name="count" select="$count"/>
      <xsl:with-param name="char" select="$char"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- word wrapper (http://plasmasturm.org/log/xslwordwrap/) -->
<!-- Copyright 2010 Aristotle Pagaltzis; under the MIT licence -->
<!-- http://www.opensource.org/licenses/mit-license.php -->
<xsl:template name="wrap-string">
  <xsl:param name="str"/>
  <xsl:param name="wrap-col" select="$line_length" />
  <xsl:param name="break-mark" select="$end_of_line"/>
  <xsl:param name="pos" select="0"/>
  <xsl:param name="indent" select="0"/>
  <xsl:param name="line" select="0"/>

  <xsl:choose>
    <xsl:when test="contains($str, ' ')">
      <xsl:variable name="first-word" select="substring-before($str, ' ')" />
      <xsl:variable name="pos-now" select="$pos + 1 + string-length($first-word)"/>
      <xsl:choose>
        <xsl:when test="$pos > 0 and $pos-now - 1 > $wrap-col - $indent">
          <xsl:copy-of select="$break-mark"/>
          <xsl:call-template name="wrap-string">
            <xsl:with-param name="str" select="$str"/>
            <xsl:with-param name="wrap-col" select="$wrap-col"/>
            <xsl:with-param name="break-mark" select="$break-mark"/>
            <xsl:with-param name="pos" select="0"/>
            <xsl:with-param name="indent" select="$indent"/>
            <xsl:with-param name="line" select="$line + 1"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$indent > 0 and $line > 0 and $pos = 0">
            <xsl:call-template name="for.loop">
              <xsl:with-param name="count" select="$indent"/>
              <xsl:with-param name="char" select="' '"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="$pos > 0">
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:value-of select="$first-word"/>
          <xsl:call-template name="wrap-string">
            <xsl:with-param name="str" select="substring-after($str, ' ')"/>
            <xsl:with-param name="wrap-col" select="$wrap-col"/>
            <xsl:with-param name="break-mark" select="$break-mark"/>
            <xsl:with-param name="pos" select="$pos-now"/>
            <xsl:with-param name="indent" select="$indent"/>
            <xsl:with-param name="line" select="$line + 1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$pos + string-length($str) > $wrap-col">
          <xsl:copy-of select="$break-mark"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- unify the author name -->
<xsl:template name="unify-author">
  <xsl:param name="author"/>

  <xsl:variable name="middlename">
    <xsl:if test="string-length($author/middlename)">
      <xsl:value-of select="concat(substring($author/middlename, 1, 1), '. ')"/>
    </xsl:if>
  </xsl:variable>

  <xsl:call-template name="upper-case">
    <xsl:with-param name="string" select="concat($author/lastname, ' ', $middlename, substring($author/firstname, 1, 1), '.')"/>
  </xsl:call-template>
</xsl:template>


<!-- replaces double quotation -->
<xsl:template name="replace-double-quotation">
  <xsl:param name="node"/>

  <xsl:variable name="text1">
    <xsl:call-template name="replace-string">
      <xsl:with-param name="text" select="$node"/>
      <xsl:with-param name="replace" select="'&ldquor;'"/>
      <xsl:with-param name="with" select="'&quot;'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="text2">
    <xsl:call-template name="replace-string">
      <xsl:with-param name="text" select="$text1"/>
      <xsl:with-param name="replace" select="'&rdquor;'"/>
      <xsl:with-param name="with" select="'&quot;'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:value-of select="$text2"/>
</xsl:template>


<!-- return text in specific language -->
<xsl:template name="getText">
  <xsl:param name="id"/>

  <xsl:value-of select="document(concat('../lang/', $project ,'-', $lang, '.xml'))//text[@id=$id]"/>
</xsl:template>


</xsl:transform>
