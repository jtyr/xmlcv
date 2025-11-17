<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: TXT stylesheet for XMLCV
  **
  ** (c) Jiri Tyr 2011-2025
  **********************************************************
  -->


<!DOCTYPE xsl:stylesheet [
  <!-- entities used in this document - necessary for Firefox -->
  <!-- if you are missing some entity, just add it from external entities files -->
  <!ENTITY nbsp	"&#x00A0;">

  <!-- external entities - doesn't work in Firefox -->
  <!ENTITY % ISOlat1 SYSTEM './ent/iso-lat1.ent'>
  %ISOlat1;
  <!ENTITY % ISOnum  SYSTEM './ent/iso-num.ent'>
  %ISOnum;
  <!ENTITY % ISOpub  SYSTEM './ent/iso-pub.ent'>
  %ISOpub;
]>


<xsl:transform version="1.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<!-- output settings -->
<xsl:output
  method="text"
  encoding="UTF-8"
/>


<!-- remove all whitespaces -->
<xsl:strip-space elements="*"/>


<!-- global params -->
<xsl:param name="lang" select="/cv/@lang"/>


<!-- includes -->
<xsl:include href="includes/Setting-cv.xsl"/>
<xsl:include href="includes/Utils.xsl"/>


<!-- main template -->
<xsl:template match="/">
  <xsl:variable name="author">
    <xsl:variable name="middlename">
      <xsl:if test="string-length(/cv/personal/name/middlename)">
        <xsl:value-of select="concat(/cv/personal/name/middlename, ' ')"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="concat(/cv/personal/name/firstname, ' ', $middlename, /cv/personal/name/lastname)"/>
  </xsl:variable>

  <xsl:variable name="title">
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'cv'"/></xsl:call-template>
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'of'"/></xsl:call-template>
    <xsl:value-of select="$author"/>
  </xsl:variable>

  <xsl:variable name="cv">
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'cv'"/></xsl:call-template>
  </xsl:variable>

  <xsl:if test="string-length(/cv/@show-title) = 0 or (string-length(/cv/@show-title) and /cv/@show-title='yes')">
    <xsl:call-template name="for.loop">
      <xsl:with-param name="count" select="string-length($cv) + 8"/>
    </xsl:call-template>
    <xsl:call-template name="printNewLine"/>

    <xsl:text>### </xsl:text>
    <xsl:value-of select="$cv"/>
    <xsl:text> ###</xsl:text>
    <xsl:call-template name="printNewLine"/>

    <xsl:call-template name="for.loop">
      <xsl:with-param name="count" select="string-length($cv) + 8"/>
    </xsl:call-template>

    <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="3"/></xsl:call-template>
  </xsl:if>

  <xsl:apply-templates/>

  <xsl:call-template name="for.loop">
    <xsl:with-param name="count" select="$line_length"/>
    <xsl:with-param name="char" select="'-'"/>
  </xsl:call-template>
  <xsl:call-template name="printNewLine"/>

  <xsl:variable name="footer">
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'generated_by'"/></xsl:call-template>
    <xsl:text> (http://jtyr.github.io/xmlcv/) - </xsl:text>
    <xsl:call-template name="getDateFormat">
      <xsl:with-param name="format"><xsl:call-template name="getText"><xsl:with-param name="id" select="'full_date_format'"/></xsl:call-template></xsl:with-param>
      <xsl:with-param name="date" select="$current_date"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="for.loop">
    <xsl:with-param name="count" select="($line_length - string-length($footer)) div 2"/>
    <xsl:with-param name="char" select="' '"/>
  </xsl:call-template>

  <xsl:value-of select="$footer"/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>



<!--
 #####################
 ## S E C T I O N S ##
 #####################
-->

<!-- pesonal section -->
<xsl:template match="personal[@show!='yes']">
</xsl:template>
<xsl:template match="personal[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="personal-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="personal-run">
  <!-- get middlename -->
  <xsl:variable name="middlename">
    <xsl:if test="string-length(./name/middlename)">
      <xsl:value-of select="concat(./name/middlename, ' ')"/>
    </xsl:if>
  </xsl:variable>

  <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_name'"/></xsl:call-template>
  <xsl:value-of select="concat(' ', ./name/firstname, ' ', $middlename, ./name/lastname)"/>
  <xsl:call-template name="printNewLine"/>

  <xsl:apply-templates/>

  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
</xsl:template>


<!-- name -->
<xsl:template match="personal/name">
</xsl:template>


<!-- address -->
<xsl:template match="personal/address">
  <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_address'"/></xsl:call-template>
  <xsl:if test="string-length(./residence)">
    <xsl:value-of select="concat(' ', ./residence, ',')"/>
  </xsl:if>
  <xsl:value-of select="concat(' ', ./street, ', ', ./postcode, ' ', ./city)"/>
  <xsl:if test="string-length(./country)">
    <xsl:value-of select="concat(', ', ./country)"/>
  </xsl:if>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- telephone -->
<xsl:template match="personal/telephone">
    <xsl:choose>
      <xsl:when test="string-length(@mobile) and @mobile = 'yes'">
        <xsl:choose>
          <xsl:when test="string-length(@type) and @type = 'private'">
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_mobile_private'"/></xsl:call-template>
          </xsl:when>
          <xsl:when test="string-length(@type) and @type = 'office'">
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_mobile_office'"/></xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_mobile'"/></xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="string-length(@type) and @type = 'private'">
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_telephone_private'"/></xsl:call-template>
          </xsl:when>
          <xsl:when test="string-length(@type) and @type = 'office'">
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_telephone_office'"/></xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_telephone'"/></xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="concat(' ', .)"/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- fax -->
<xsl:template match="personal/fax">
  <xsl:choose>
    <xsl:when test="string-length(@type) and @type = 'private'">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_fax_private'"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="string-length(@type) and @type = 'office'">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_fax_office'"/></xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_fax'"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="concat(' ', .)"/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- email -->
<xsl:template match="personal/email">
  <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_email'"/></xsl:call-template>
  <xsl:value-of select="concat(' ', .)"/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- PGP key ID -->
<xsl:template match="personal/pgp-id">
  <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_pgpid'"/></xsl:call-template>
  <xsl:value-of select="concat(' ', .)"/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- im -->
<xsl:template match="personal/im">
  <xsl:value-of select="./im/@type"/>
  <xsl:value-of select="concat(': ', .)"/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- homepage -->
<xsl:template match="personal/homepage">
  <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_homepage'"/></xsl:call-template>
  <xsl:value-of select="concat(' ', .)"/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- nationality -->
<xsl:template match="personal/nationality">
  <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_nationality'"/></xsl:call-template>
  <xsl:value-of select="concat(' ', .)"/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- birthday -->
<xsl:template match="personal/birthday">
  <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_birthday'"/></xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:call-template name="getDateFormat">
    <xsl:with-param name="format"><xsl:call-template name="getText"><xsl:with-param name="id" select="'full_date_format'"/></xsl:call-template></xsl:with-param>
    <xsl:with-param name="date" select="."/>
  </xsl:call-template>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- age -->
<xsl:template match="personal/age">
  <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_age'"/></xsl:call-template>
  <xsl:value-of select="concat(' ', .)"/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- gender -->
<xsl:template match="personal/gender">
  <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_gender'"/></xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:choose>
    <xsl:when test="@type = 'F' or @type = 'f'">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_gender_female'"/></xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_gender_male'"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- status -->
<xsl:template match="personal/status">
  <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_merital_status'"/></xsl:call-template>
  <xsl:value-of select="concat(' ', .)"/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- text-block section -->
<xsl:template match="text-block[@show!='yes']">
</xsl:template>
<xsl:template match="text-block[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="text-block-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="text-block-run">
  <xsl:choose>
    <xsl:when test="string-length(title)">
      <xsl:call-template name="printTitleBullet"/>
      <xsl:value-of select="title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/>
      <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="string-length(title/@id)">
      <xsl:call-template name="printTitleBullet"/>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template>
      <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
    </xsl:when>
  </xsl:choose>

  <xsl:call-template name="wrap-string">
    <xsl:with-param name="str" select="normalize-space(text[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))])"/>
  </xsl:call-template>

  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="3"/></xsl:call-template>
</xsl:template>


<!-- work experience section -->
<xsl:template match="work-experience[@show!='yes']">
</xsl:template>
<xsl:template match="work-experience[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="work-experience-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="work-experience-run">
  <xsl:call-template name="printTitleBullet"/>
  <xsl:choose>
    <xsl:when test="string-length(title)">
      <xsl:apply-templates select="title"/>
    </xsl:when>
    <xsl:when test="string-length(title/@id)">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience'"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>

  <xsl:variable name="show_desc" select="@show-description"/>
  <xsl:variable name="show_keys">
    <xsl:choose>
      <xsl:when test="string-length($show_keys)">
        <xsl:value-of select="$show_keys"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@show-keys"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:for-each select="./experience[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]">
    <xsl:sort select="substring(concat(substring(./interval/end, 4, 4), substring(./interval/end, 1, 2), '999999'), 1, 6)" order="descending"/>

    <xsl:text>[</xsl:text>
    <xsl:call-template name="getInterval">
      <xsl:with-param name="interval" select="./interval"/>
    </xsl:call-template>
    <xsl:text>]</xsl:text>
    <xsl:call-template name="printNewLine"/>

    <xsl:choose>
      <xsl:when test="string-length(./title/@url)">
        <xsl:value-of select="concat('&quot;', ./title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))], '&quot;')"/>
        <xsl:call-template name="printNewLine"/>
        <xsl:value-of select="concat('Web: ', ./title/@url)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('&quot;', ./title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))], '&quot;')"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="printNewLine"/>

    <xsl:if test="./employer">
      <xsl:variable name="employer_label">
        <xsl:choose>
          <xsl:when test="string-length(./employer/label)">
            <xsl:value-of select="./employer/label"/>
          </xsl:when>
          <xsl:when test="string-length(./employer/person)">
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_responsible'"/></xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_employer'"/></xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="employer_text">
        <xsl:value-of select="$employer_label"/>

        <xsl:if test="string-length(./employer/person)"><xsl:value-of select="./employer/person"/>
          <xsl:choose>
            <xsl:when test="string-length(./employer/email)">
              <xsl:text> (</xsl:text>
              <xsl:value-of select="./employer/email"/>
              <xsl:text>)</xsl:text>
              <xsl:if test="./employer/email[following-sibling::*]"><xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_separator'"/></xsl:call-template></xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="./employer/person[following-sibling::*]"><xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_separator'"/></xsl:call-template></xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="string-length(./employer/department)"><xsl:value-of select="./employer/department"/><xsl:if test="./employer/department[following-sibling::*]"><xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_separator'"/></xsl:call-template></xsl:if></xsl:if>
        <xsl:if test="string-length(./employer/institute)"><xsl:value-of select="./employer/institute"/><xsl:if test="./employer/institute[following-sibling::*]"><xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_separator'"/></xsl:call-template></xsl:if></xsl:if>
        <xsl:if test="./employer/address">
          <xsl:if test="string-length(./employer/address/street)"><xsl:value-of select="./employer/address/street"/><xsl:if test="./employer/address/street[following-sibling::*]"><xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_separator'"/></xsl:call-template></xsl:if></xsl:if>
          <xsl:if test="string-length(./employer/address/postcode)"><xsl:value-of select="./employer/address/postcode"/><xsl:text> </xsl:text></xsl:if>
          <xsl:if test="string-length(./employer/address/city)"><xsl:value-of select="./employer/address/city"/><xsl:if test="./employer/address/city[following-sibling::*]"><xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_separator'"/></xsl:call-template></xsl:if></xsl:if>
          <xsl:if test="string-length(./employer/address/country)"><xsl:value-of select="./employer/address/country"/></xsl:if>
        </xsl:if>
        <xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_final'"/></xsl:call-template>
      </xsl:variable>

      <xsl:call-template name="wrap-string">
        <xsl:with-param name="str" select="$employer_text"/>
        <xsl:with-param name="indent" select="string-length($employer_label)"/>
      </xsl:call-template>

      <xsl:call-template name="printNewLine"/>
    </xsl:if>

    <xsl:variable name="desc">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_description'"/></xsl:call-template>
    </xsl:variable>

    <xsl:if test="(string-length(./description[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]) and string-length($show_desc) = 0) or (string-length($show_desc) > 0 and $show_desc = 'yes')">
      <xsl:variable name="description_content">
        <xsl:apply-templates select="./description[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/>
      </xsl:variable> 
      <xsl:call-template name="wrap-string">
        <xsl:with-param name="str" select="concat($desc, $description_content)"/>
      </xsl:call-template>
      <xsl:call-template name="printNewLine"/>
    </xsl:if>

    <xsl:if test="./keys and string-length($show_keys) and $show_keys='yes'">
      <xsl:variable name="keys_str">
        <xsl:if test="string-length(./keys/@title)">
          <xsl:value-of select="./keys/@title"/>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="string-length(./keys/@sort) and ./keys/@sort = 'no'">
            <xsl:for-each select="./keys/key">
              <xsl:value-of select="text()"/>
              <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="./keys/key">
              <xsl:sort select="."/>
              <xsl:value-of select="text()"/>
              <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
              </xsl:if>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:call-template name="wrap-string">
        <xsl:with-param name="str" select="$keys_str"/>
      </xsl:call-template>
      <xsl:call-template name="printNewLine"/>
    </xsl:if>

    <xsl:call-template name="printNewLine"/>
  </xsl:for-each>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- education and qualification section -->
<xsl:template match="education[@show!='yes']">
</xsl:template>
<xsl:template match="education[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="education-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="education-run">
  <xsl:call-template name="printTitleBullet"/>
  <xsl:choose>
    <xsl:when test="string-length(title)">
      <xsl:value-of select="title"/>
    </xsl:when>
    <xsl:when test="string-length(title/@id)">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'education'"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>

  <xsl:for-each select="./edu">
    <xsl:text>[</xsl:text>
    <xsl:call-template name="getInterval">
      <xsl:with-param name="interval" select="./interval"/>
    </xsl:call-template>
    <xsl:text>]</xsl:text>
    <xsl:call-template name="printNewLine"/>

    <xsl:value-of select="concat('&quot;', ./title, '&quot;')"/>
    <xsl:call-template name="printNewLine"/>

    <xsl:variable name="institut_text">
      <xsl:if test="string-length(./institute/name)">
        <xsl:text></xsl:text><xsl:value-of select="./institute/name"/>
      </xsl:if>
      <xsl:if test="string-length(./institute/department)">
        <xsl:text>, </xsl:text><xsl:value-of select="./institute/department"/>
      </xsl:if>
      <xsl:if test="string-length(./institute/city)">
        <xsl:text>, </xsl:text><xsl:value-of select="./institute/city"/>
      </xsl:if>
      <xsl:if test="string-length(./institute/country)">
        <xsl:text>, </xsl:text><xsl:value-of select="./institute/country"/>
      </xsl:if>
      <xsl:text>.</xsl:text>
    </xsl:variable>

    <xsl:call-template name="wrap-string">
      <xsl:with-param name="str" select="$institut_text"/>
    </xsl:call-template>

    <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
  </xsl:for-each>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- skills section -->
<xsl:template match="skills[@show!='yes']">
</xsl:template>
<xsl:template match="skills[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="skills-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="skills-run">
  <xsl:call-template name="printTitleBullet"/>
  <xsl:choose>
    <xsl:when test="string-length(title)">
      <xsl:value-of select="title"/>
    </xsl:when>
    <xsl:when test="string-length(title/@id)">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'special_skills'"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>

  <xsl:variable name="format">
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'short_date_format'"/></xsl:call-template>
  </xsl:variable>

  <xsl:for-each select="./skill">
    <xsl:variable name="skill_label">
      <xsl:call-template name="getDateFormat">
        <xsl:with-param name="format" select="$format"/>
        <xsl:with-param name="date" select="./date"/>
      </xsl:call-template>
      <xsl:text> - </xsl:text>
    </xsl:variable>

    <xsl:call-template name="wrap-string">
      <xsl:with-param name="str" select="concat($skill_label, ./title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))])"/>
      <xsl:with-param name="indent" select="string-length($skill_label)"/>
    </xsl:call-template>
    <xsl:call-template name="printNewLine"/>
  </xsl:for-each>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
</xsl:template>


<!-- language-table section -->
<xsl:template match="language-table[@show!='yes']">
</xsl:template>
<xsl:template match="language-table[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="language-table-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="language-table-run">
  <xsl:call-template name="printTitleBullet"/>
  <xsl:choose>
    <xsl:when test="string-length(title)">
      <xsl:value-of select="title"/>
    </xsl:when>
    <xsl:when test="string-length(title/@id)">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'language_skills'"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>

  <xsl:if test="./language[not(@mother-tongue = 'yes')]">
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_mother_tongue'"/></xsl:call-template>

    <xsl:for-each select="./language[@mother-tongue = 'yes']">
      <xsl:sort select="./lang"/>

      <xsl:value-of select="./lang"/>

      <xsl:if test="not(position() = last())">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
  </xsl:if>

  <xsl:for-each select="./language[not(@mother-tongue = 'yes')]">
    <xsl:sort select="./lang"/>

    <!-- lang -->
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_language'"/></xsl:call-template>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="concat('&quot;', ./lang, '&quot;')"/>
    <xsl:call-template name="printNewLine"/>

    <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_understanding'"/></xsl:call-template>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="printNewLine"/>

    <!-- understanding - listening -->
    <xsl:text> * </xsl:text>
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_listening'"/></xsl:call-template>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="getLangLevelCode">
      <xsl:with-param name="level" select="understanding/listening"/>
    </xsl:call-template>
    <xsl:text> - </xsl:text>
    <xsl:call-template name="getLangLevelLabel">
      <xsl:with-param name="level" select="understanding/listening"/>
    </xsl:call-template>
    <xsl:call-template name="printNewLine"/>

    <!-- understanding - reading -->
    <xsl:text> * </xsl:text>
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_reading'"/></xsl:call-template>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="getLangLevelCode">
      <xsl:with-param name="level" select="understanding/reading"/>
    </xsl:call-template>
    <xsl:text> - </xsl:text>
    <xsl:call-template name="getLangLevelLabel">
      <xsl:with-param name="level" select="understanding/reading"/>
    </xsl:call-template>
    <xsl:call-template name="printNewLine"/>

    <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_speaking'"/></xsl:call-template>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="printNewLine"/>

    <!-- speaking - interaction -->
    <xsl:text> * </xsl:text>
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_interaction'"/></xsl:call-template>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="getLangLevelCode">
      <xsl:with-param name="level" select="speaking/interaction"/>
    </xsl:call-template>
    <xsl:text> - </xsl:text>
    <xsl:call-template name="getLangLevelLabel">
      <xsl:with-param name="level" select="speaking/interaction"/>
    </xsl:call-template>
    <xsl:call-template name="printNewLine"/>

    <!-- speaking - production -->
    <xsl:text> * </xsl:text>
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_production'"/></xsl:call-template>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="getLangLevelCode">
      <xsl:with-param name="level" select="speaking/production"/>
    </xsl:call-template>
    <xsl:text> - </xsl:text>
    <xsl:call-template name="getLangLevelLabel">
      <xsl:with-param name="level" select="speaking/production"/>
    </xsl:call-template>
    <xsl:call-template name="printNewLine"/>

    <!-- writing -->
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_writing'"/></xsl:call-template>
    <xsl:text>: </xsl:text>
    <xsl:call-template name="getLangLevelCode">
      <xsl:with-param name="level" select="writing"/>
    </xsl:call-template>
    <xsl:text> - </xsl:text>
    <xsl:call-template name="getLangLevelLabel">
      <xsl:with-param name="level" select="writing"/>
    </xsl:call-template>
    <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
  </xsl:for-each>

  <xsl:text>(</xsl:text>
  <xsl:call-template name="getText"><xsl:with-param name="id" select="'language_table_note'"/></xsl:call-template>
  <xsl:text>)</xsl:text>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="3"/></xsl:call-template>
</xsl:template>


<!-- language-list section -->
<xsl:template match="language-list[@show!='yes']">
</xsl:template>
<xsl:template match="language-list[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="language-list-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="language-list-run">
  <xsl:call-template name="printTitleBullet"/>
  <xsl:choose>
    <xsl:when test="string-length(title)">
      <xsl:value-of select="title"/>
    </xsl:when>
    <xsl:when test="string-length(title/@id)">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'language_skills'"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>

  <xsl:for-each select="./language">
    <xsl:sort select="./lang"/>

    <xsl:value-of select="concat(./lang, $labeled_list_separator)"/>
    <xsl:choose>
      <xsl:when test="string-length(@mother-tongue) and @mother-tongue = 'yes'">
        <xsl:call-template name="getLangLevelLabel">
          <xsl:with-param name="level" select="'0'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="getLangLevelLabel">
          <xsl:with-param name="level" select="./level"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="printNewLine"/>
  </xsl:for-each>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
</xsl:template>


<!-- labeled-list section -->
<xsl:template match="labeled-list[@show!='yes']">
</xsl:template>
<xsl:template match="labeled-list[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="labeled-list-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="labeled-list-run">
  <xsl:call-template name="printTitleBullet"/>
  <xsl:choose>
    <xsl:when test="string-length(title)">
      <xsl:value-of select="title"/>
    </xsl:when>
    <xsl:when test="string-length(title/@id)">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template>
    </xsl:when>
  </xsl:choose>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>

  <xsl:choose>
    <xsl:when test="string-length(@sort) and @sort = 'no'">
      <xsl:for-each select="./item">
        <xsl:value-of select="concat(./label, $labeled_list_separator)"/>
        <xsl:apply-templates select="./value"/>
        <xsl:call-template name="printNewLine"/>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="./item">
        <xsl:sort select="./label"/>
        <xsl:value-of select="concat(./label, $labeled_list_separator)"/>
        <xsl:apply-templates select="./value"/>
        <xsl:call-template name="printNewLine"/>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
</xsl:template>


<!-- list section -->
<xsl:template match="list[@show!='yes']">
</xsl:template>
<xsl:template match="list[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="list-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="list-run">
  <xsl:choose>
    <xsl:when test="string-length(title)">
      <xsl:call-template name="printTitleBullet"/>
      <xsl:value-of select="title"/>
      <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="string-length(title/@id)">
      <xsl:call-template name="printTitleBullet"/>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template>
      <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
    </xsl:when>
  </xsl:choose>

  <xsl:variable name="listText">
    <xsl:choose>
      <xsl:when test="string-length(@sort) and @sort = 'no'">
        <xsl:for-each select="./item">
          <xsl:value-of select="text()"/>
          <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="./item">
          <xsl:sort select="."/>
          <xsl:value-of select="text()"/>
          <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="wrap-string">
    <xsl:with-param name="str" select="$listText"/>
  </xsl:call-template>

  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="3"/></xsl:call-template>
</xsl:template>


<!-- signature line -->
<xsl:template match="signature[@show!='yes']">
</xsl:template>
<xsl:template match="signature[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="signature-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="signature-run">
  <xsl:if test="string-length($show_signature) and $show_signature = 'yes'">
    <!-- get middlename -->
    <xsl:variable name="middlename">
      <xsl:if test="string-length(/cv/personal/name/middlename)">
        <xsl:value-of select="concat(/cv/personal/name/middlename, ' ')"/>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="date_place">
      <xsl:call-template name="getDateFormat">
        <xsl:with-param name="format"><xsl:call-template name="getText"><xsl:with-param name="id" select="'full_date_format'"/></xsl:call-template></xsl:with-param>
        <xsl:with-param name="date" select="$current_date"/>
      </xsl:call-template>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="/cv/personal/address/city"/>
    </xsl:variable>

    <xsl:variable name="name">
      <xsl:value-of select="concat(/cv/personal/name/firstname, ' ', $middlename, /cv/personal/name/lastname)"/>
    </xsl:variable>

    <xsl:variable name="underline_length">
      <xsl:choose>
        <xsl:when test="string-length($name) > 20">
          <xsl:value-of select="string-length($name)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="20"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="indent">
      <xsl:choose>
        <xsl:when test="string-length($name) &lt; $underline_length">
          <xsl:value-of select="$line_length - $underline_length + (($underline_length - string-length($name)) div 2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$line_length - $underline_length"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="$date_place"/>
    <xsl:call-template name="printNewLine"/>

    <xsl:call-template name="for.loop">
      <xsl:with-param name="count" select="$line_length - $underline_length"/>
      <xsl:with-param name="char" select="' '"/>
    </xsl:call-template>
    <xsl:call-template name="for.loop">
      <xsl:with-param name="count" select="$underline_length"/>
      <xsl:with-param name="char" select="'-'"/>
    </xsl:call-template>
    <xsl:call-template name="printNewLine"/>

    <xsl:call-template name="for.loop">
      <xsl:with-param name="count" select="floor($indent)"/>
      <xsl:with-param name="char" select="' '"/>
    </xsl:call-template>
    <xsl:value-of select="$name"/>

    <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="3"/></xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- publications section -->
<xsl:template match="publications[@show!='yes']">
</xsl:template>
<xsl:template match="publications[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="publications-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="publications-run">
  <xsl:call-template name="printTitleBullet"/>
  <xsl:choose>
    <xsl:when test="string-length(title)">
      <xsl:value-of select="title"/>
    </xsl:when>
    <xsl:when test="string-length(title/@id)">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'publications'"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>

  <xsl:for-each select="./publ">
    <xsl:variable name="publication">
      <xsl:choose>
        <xsl:when test="./authors">
          <xsl:for-each select="./authors/author">
            <xsl:call-template name="unify-author">
              <xsl:with-param name="author" select="."/>
            </xsl:call-template>
            <xsl:if test="position() != last()">
              <xsl:text> - </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="unify-author">
            <xsl:with-param name="author" select="./author"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:value-of select="concat(' ', '&quot;', ./title, '&quot;', '.')"/>

      <xsl:if test="string-length(./event)">
        <xsl:variable name="event">
          <xsl:call-template name="replace-double-quotation">
            <xsl:with-param name="node" select="./event"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat(' ', $event, '.')"/>
      </xsl:if>

      <xsl:if test="string-length(./department)">
        <xsl:value-of select="concat(' ', ./department, '.')"/>
      </xsl:if>

      <xsl:if test="string-length(./institut)">
        <xsl:value-of select="concat(' ', ./institut, '.')"/>
      </xsl:if>

      <xsl:if test="string-length(./city)">
        <xsl:value-of select="concat(' ', ./city, '.')"/>
      </xsl:if>

      <xsl:if test="string-length(./country)">
        <xsl:value-of select="concat(' ', ./country, '.')"/>
      </xsl:if>

      <xsl:if test="string-length(./date)">
        <xsl:value-of select="concat(' ', ./date, '.')"/>
      </xsl:if>

      <xsl:if test="string-length(./url)">
        <xsl:value-of select="concat('Online [', ./url, '].')"/>
      </xsl:if>

      <xsl:if test="string-length(./isbn)">
        <xsl:value-of select="concat(' ISBN: ', ./isbn, '.')"/>
      </xsl:if>

      <xsl:if test="string-length(./issn)">
        <xsl:value-of select="concat(' ISSN: ', ./issn, '.')"/>
      </xsl:if>

      <xsl:if test="string-length(./pages)">
        <xsl:variable name="pages_label">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'pages'"/></xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat(' ', $pages_label, ./pages, '.')"/>
      </xsl:if>
    </xsl:variable>

    <xsl:call-template name="wrap-string">
      <xsl:with-param name="str" select="$publication"/>
    </xsl:call-template>

    <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
  </xsl:for-each>

  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- computer knowledge -->
<xsl:template match="computer-knowledge[@show!='yes']">
</xsl:template>
<xsl:template match="computer-knowledge[@show='yes' or not(@show)]">
  <xsl:if test="(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))">
    <xsl:call-template name="computer-knowledge-run"/>
  </xsl:if>
</xsl:template>
<xsl:template name="computer-knowledge-run">
  <xsl:call-template name="printTitleBullet"/>
  <xsl:choose>
    <xsl:when test="string-length(title)">
      <xsl:value-of select="title"/>
    </xsl:when>
    <xsl:when test="string-length(title/@id)">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'computer_knowledge'"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>

  <xsl:for-each select="./table">
    <xsl:variable name="fourth_cell">
      <xsl:call-template name="getCellName">
         <xsl:with-param name="type" select="@type"/>
         <xsl:with-param name="cell" select="4"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="fifth_cell">
      <xsl:call-template name="getCellName">
         <xsl:with-param name="type" select="@type"/>
         <xsl:with-param name="cell" select="5"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="sixth_cell">
     <xsl:call-template name="getCellName">
         <xsl:with-param name="type" select="@type"/>
         <xsl:with-param name="cell" select="6"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="concat(./title, ':')"/>
    <xsl:call-template name="printNewLine"/>

    <xsl:variable name="type" select="@type"/>

    <xsl:for-each select="./row">
      <xsl:sort select="./name"/>

      <!-- name -->
      <xsl:value-of select="concat('&quot;', ./name, '&quot;')"/>
      <xsl:call-template name="printNewLine"/>

      <!-- years of use -->
      <xsl:text>   </xsl:text>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'years_of_use'"/></xsl:call-template>
      <xsl:text>: </xsl:text>
      <xsl:choose>
        <xsl:when test="string-length(./interval/end)">
          <xsl:value-of select="./interval/end - ./interval/start"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$current_year - ./interval/start"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="printNewLine"/>

      <!-- last use -->
      <xsl:text>   </xsl:text>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'last_use'"/></xsl:call-template>
      <xsl:text>: </xsl:text>
      <xsl:choose>
        <xsl:when test="string-length(./interval/end)">
          <xsl:value-of select="./interval/end"/>
        </xsl:when>
        <xsl:when test="string-length(./interval/end) = 0 or (string-length(./interval/end) > 0 and ./interval/end = $current_year)">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'now'"/></xsl:call-template>
        </xsl:when>
      </xsl:choose>
      <xsl:call-template name="printNewLine"/>

      <xsl:variable name="cross"><xsl:call-template name="getText"><xsl:with-param name="id" select="'yes'"/></xsl:call-template></xsl:variable>
      <xsl:variable name="dash"><xsl:call-template name="getText"><xsl:with-param name="id" select="'no'"/></xsl:call-template></xsl:variable>

      <xsl:if test="$type != 5">
        <!-- unix | user | consultant -->
        <xsl:choose>
          <xsl:when test="$type = 1 and string-length(./unix)">
            <xsl:text>   </xsl:text>
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'unix'"/></xsl:call-template>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="$cross"/>
            <xsl:call-template name="printNewLine"/>
          </xsl:when>
          <xsl:when test="$type = 2 and string-length(./user)">
            <xsl:text>   </xsl:text>
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'user'"/></xsl:call-template>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="$cross"/>
            <xsl:call-template name="printNewLine"/>
          </xsl:when>
          <xsl:when test="$type = 3 and string-length(./consultant)">
            <xsl:text>   </xsl:text>
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'consultant'"/></xsl:call-template>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="$cross"/>
            <xsl:call-template name="printNewLine"/>
          </xsl:when>
        </xsl:choose>

        <!-- windows | admin -->
        <xsl:choose>
          <xsl:when test="$type = 1 and string-length(./windows)">
            <xsl:text>   </xsl:text>
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'windows'"/></xsl:call-template>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="$cross"/>
            <xsl:call-template name="printNewLine"/>
          </xsl:when>
          <xsl:when test="($type = 2 or $type = 3) and string-length(./admin)">
            <xsl:text>   </xsl:text>
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'admin'"/></xsl:call-template>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="$cross"/>
            <xsl:call-template name="printNewLine"/>
          </xsl:when>
        </xsl:choose>

        <!-- developer -->
        <xsl:choose>
          <xsl:when test="($type = 2 or $type = 3) and string-length(./developer)">
            <xsl:text>   </xsl:text>
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'developer'"/></xsl:call-template>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="$cross"/>
            <xsl:call-template name="printNewLine"/>
          </xsl:when>
        </xsl:choose>
      </xsl:if>

      <!-- rating -->
      <xsl:text>   </xsl:text>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'self_rating'"/></xsl:call-template>
      <xsl:if test="position() = 1">
        <xsl:call-template name="getText"><xsl:with-param name="id" select="'self_rating_range'"/></xsl:call-template>
      </xsl:if>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="./rating"/>
      <xsl:call-template name="printNewLine"/>
    </xsl:for-each>
    <xsl:call-template name="printNewLine"/>
  </xsl:for-each>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- return date interval -->
<xsl:template name="getInterval">
  <xsl:param name="interval"/>

  <xsl:variable name="format">
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'short_date_format'"/></xsl:call-template>
  </xsl:variable>

  <table class="interval_table">
    <tr>
      <td class="interval_side_cell">
        <xsl:call-template name="getDateFormat">
          <xsl:with-param name="format" select="$format"/>
          <xsl:with-param name="date" select="$interval/start"/>
        </xsl:call-template>
      </td>
      <td class="interval_separator">
        <xsl:if test="string-length($interval/end) = 0 or $interval/end != $interval/start">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'interval_dash'"/></xsl:call-template>
        </xsl:if>
      </td>
      <td class="interval_side_cell">
        <xsl:choose>
          <!-- if the END is the same as the START -->
          <xsl:when test="$interval/end = $interval/start"></xsl:when>
          <!-- if the END is presented -->
          <xsl:when test="string-length($interval/end)">
            <xsl:call-template name="getDateFormat">
              <xsl:with-param name="format" select="$format"/>
              <xsl:with-param name="date" select="$interval/end"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'interval_present'"/></xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </table>
</xsl:template>


<!-- unordered list -->
<xsl:template match="ul">
  <xsl:call-template name="printNewLine"/>
  <xsl:apply-templates/>
  <xsl:call-template name="printNewLine">
    <xsl:with-param name="count" select="2"/>
  </xsl:call-template>
</xsl:template>


<!-- unordered list item -->
<xsl:template match="ul/li">
  <xsl:text>- </xsl:text>
  <xsl:apply-templates/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- paragraph -->
<xsl:template match="p">
  <xsl:call-template name="printNewLine"/>
  <xsl:apply-templates/>
  <xsl:call-template name="printNewLine">
    <xsl:with-param name="count" select="2"/>
  </xsl:call-template>
</xsl:template>


<!-- break - new line -->
<xsl:template match="br">
  <xsl:call-template name="printNewLine"/>
</xsl:template>


</xsl:transform>
