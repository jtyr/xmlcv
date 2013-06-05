<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: XHTML stylesheet for XMLCV
  **
  ** (c) Jiri Tyr 2008-2011
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
               xmlns="http://www.w3.org/1999/xhtml"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<!-- output settings -->
<xsl:output
  method="xml"
  encoding="UTF-8"
  doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
  indent="no"
/>


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

  <xsl:variable name="css_path_local">
    <xsl:choose>
      <xsl:when test="/cv/@css-path">
        <xsl:value-of select="concat(/cv/@css-path, '/')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$css_path"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <html>
    <xsl:attribute name="xml:lang"><xsl:value-of select="$lang"/></xsl:attribute>
    <xsl:attribute name="lang"><xsl:value-of select="$lang"/></xsl:attribute>
    <head>
      <title><xsl:value-of select="$title"/></title>
      <meta http-equiv="Content-Language" content="{$lang}"/>
      <meta http-equiv="Content-Type" content="text/html; Charset=UTF-8"/>
      <meta http-equiv="Content-Style-Type" content="text/css" />
      <meta http-equiv="Content-Script-Type" content="text/javascript"/>
      <meta name="author" content="{$author}"/>
      <meta name="copyright" content="{$author}"/>
      <meta name="generator" content="xmlcv"/>
      <meta name="keywords" content="xmlcv,cv,xsl,xslt,xhtml,fo,pdf"/>
      <meta name="description" content="{$title}"/>
      <link media="screen" href="{$css_path_local}xmlcv.css" type="text/css" rel="stylesheet"/>
    </head>
    <body class="xmlcv">

      <div id="Page">
        <xsl:if test="string-length(/cv/@show-title) = 0 or (string-length(/cv/@show-title) and /cv/@show-title='yes')">
          <div id="cv_container" class="cv_title">
            <span id="cv_text"><xsl:call-template name="getText"><xsl:with-param name="id" select="'cv'"/></xsl:call-template></span>
          </div>
        </xsl:if>

        <xsl:apply-templates/>

        <div class="generated_by"><a rel="external" href="http://jtyr.github.io/xmlcv/"><xsl:call-template name="getText"><xsl:with-param name="id" select="'generated_by'"/></xsl:call-template></a></div>

      </div>

      <script type="text/javascript">
      <xsl:comment>
        // if this does not work, set attribute margin-left in section .personal_block in xmlcv.css
        var t = document.getElementById('cv_text').offsetLeft;
        var c = document.getElementById('cv_container').offsetLeft;
        if (t-c > 0) {
          document.getElementById('personal').style.width = (t-c-5) + 'px';
        }

        // all rel="external" links will be open in new window
        window.onload = externalLinks;

        function externalLinks() {
          if (document.getElementsByTagName) {
            var anchors = document.getElementsByTagName('a');

            for (var i=0; i&lt;anchors.length; i++) {
              var anchor = anchors[i];

              if (anchor.getAttribute('href') &amp;&amp; anchor.getAttribute('rel') == 'external') {
                anchor.target = '_blank';
              }
            }
          }
        }
      </xsl:comment>
      </script>

    </body>
  </html>
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
  <!-- size of address element -->
  <xsl:variable name="address_size">
    <xsl:choose>
      <xsl:when test="address/postcode and address/city">
        <xsl:value-of select="count(child::address/*) - 2"/>
      </xsl:when>
      <xsl:when test="address">
        <xsl:value-of select="count(child::address/*) - 1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- get number of lines in personal table -->
  <xsl:variable name="personal_length" select="count(child::*) + $address_size"/>
  <!-- get photo url -->
  <xsl:variable name="photo_url" select="./@photo-url"/>
  <!-- get photo height -->
  <xsl:variable name="photo_height">
    <xsl:choose>
      <xsl:when test="string-length(./@photo-height)">
        <xsl:value-of select="./@photo-height"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$personal_length * ($font_size + 1) * 1.333"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- get middlename -->
  <xsl:variable name="middlename">
    <xsl:if test="string-length(./name/middlename)">
      <xsl:value-of select="concat(./name/middlename, ' ')"/>
    </xsl:if>
  </xsl:variable>

  <table class="personal_table">
    <!-- name -->
    <tr>
      <td id="personal" class="personal_table_cell_label"><xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_name'"/></xsl:call-template></td>
      <td class="personal_table_cell_text"><xsl:value-of select="concat(./name/firstname, ' ', $middlename, ./name/lastname)"/></td>
      <td rowspan="{$personal_length}" class="personal_photo_cell">
        <xsl:if test="string-length($photo_url)">
          <img src="{$photo_url}" height="{$photo_height}" id="photo" class="personal_photo_graphic" alt="{concat(./name/firstname, ' ', $middlename, ./name/lastname)}"/>
        </xsl:if>
      </td>
    </tr>

    <xsl:apply-templates/>

  </table>
</xsl:template>


<!-- address -->
<xsl:template match="personal/address">
  <tr>
    <td class="personal_table_cell_label" rowspan="{count(child::*) - 1}"><xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_address'"/></xsl:call-template></td>
    <xsl:choose>
      <xsl:when test="string-length(./residence)">
        <td class="personal_table_cell_text"><xsl:value-of select="./residence"/></td>
      </xsl:when>
      <xsl:otherwise>
        <td class="personal_table_cell_text"><xsl:value-of select="./street"/></td>
      </xsl:otherwise>
    </xsl:choose>
  </tr>
  <xsl:if test="string-length(./residence)">
    <tr>
      <td class="personal_table_cell_text"><xsl:value-of select="./street"/></td>
    </tr>
  </xsl:if>
  <tr>
    <td class="personal_table_cell_text"><xsl:value-of select="concat(./postcode, '  ', ./city)"/></td>
  </tr>
  <xsl:if test="string-length(./country)">
    <tr>
      <td class="personal_table_cell_text"><xsl:value-of select="./country"/></td>
    </tr>
  </xsl:if>
</xsl:template>


<!-- telephone -->
<xsl:template match="personal/telephone">
  <tr>
    <td class="personal_table_cell_label">
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
    </td>
    <td class="personal_table_cell_text"><xsl:value-of select="."/></td>
  </tr>
</xsl:template>


<!-- fax -->
<xsl:template match="personal/fax">
  <tr>
    <td class="personal_table_cell_label">
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
    </td>
    <td class="personal_table_cell_text"><xsl:value-of select="."/></td>
  </tr>
</xsl:template>


<!-- email -->
<xsl:template match="personal/email">
  <tr>
    <td class="personal_table_cell_label"><xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_email'"/></xsl:call-template></td>
    <td class="personal_table_cell_text">
      <a href="{concat('mailto:', .)}">
        <xsl:value-of select="."/>
      </a>
    </td>
  </tr>
</xsl:template>


<!-- PGP key ID -->
<xsl:template match="personal/pgp-id">
  <tr>
    <td class="personal_table_cell_label"><xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_pgpid'"/></xsl:call-template></td>
    <td class="personal_table_cell_text"><xsl:value-of select="."/></td>
  </tr>
</xsl:template>


<!-- im -->
<xsl:template match="personal/im">
  <tr>
    <td class="personal_table_cell_label"><xsl:value-of select="@type"/>:</td>
    <td class="personal_table_cell_text"><xsl:value-of select="."/></td>
  </tr>
</xsl:template>


<!-- homepage -->
<xsl:template match="personal/homepage">
  <tr>
    <td class="personal_table_cell_label"><xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_homepage'"/></xsl:call-template></td>
    <td class="personal_table_cell_text"><a rel="external" href="{./homepage}"><xsl:value-of select="."/></a></td>
  </tr>
</xsl:template>


<!-- nationality -->
<xsl:template match="personal/nationality">
  <tr>
    <td class="personal_table_cell_label"><xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_nationality'"/></xsl:call-template></td>
    <td class="personal_table_cell_text"><xsl:value-of select="."/></td>
  </tr>
</xsl:template>


<!-- birthday -->
<xsl:template match="personal/birthday">
  <tr>
    <td class="personal_table_cell_label"><xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_birthday'"/></xsl:call-template></td>
    <td class="personal_table_cell_text">
      <xsl:call-template name="getDateFormat">
        <xsl:with-param name="format"><xsl:call-template name="getText"><xsl:with-param name="id" select="'full_date_format'"/></xsl:call-template></xsl:with-param>
        <xsl:with-param name="date" select="."/>
      </xsl:call-template>
    </td>
  </tr>
</xsl:template>


<!-- age -->
<xsl:template match="personal/age">
  <tr>
    <td class="personal_table_cell_label"><xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_age'"/></xsl:call-template></td>
    <td class="personal_table_cell_text"><xsl:value-of select="."/></td>
  </tr>
</xsl:template>


<!-- gender -->
<xsl:template match="personal/gender">
  <tr>
    <td class="personal_table_cell_label"><xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_gender'"/></xsl:call-template></td>
    <td class="personal_table_cell_text">
      <xsl:choose>
        <xsl:when test="@type = 'F' or @type = 'f'">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_gender_female'"/></xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_gender_male'"/></xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </tr>
</xsl:template>


<!-- status -->
<xsl:template match="personal/status">
  <tr>
    <td class="personal_table_cell_label"><xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_merital_status'"/></xsl:call-template></td>
    <td class="personal_table_cell_text"><xsl:value-of select="."/></td>
  </tr>
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
  <div class="section">
    <xsl:choose>
      <xsl:when test="string-length(title)">
        <div class="section_title"><xsl:value-of select="title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/></div>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></div>
      </xsl:when>
    </xsl:choose>

    <div class="text_block">
      <xsl:apply-templates select="text[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/>
    </div>
  </div>
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
  <div class="section">
    <xsl:choose>
      <xsl:when test="string-length(title)">
        <div class="section_title"><xsl:value-of select="title"/></div>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></div>
      </xsl:when>
      <xsl:otherwise>
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience'"/></xsl:call-template></div>
      </xsl:otherwise>
    </xsl:choose>

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

    <table class="list_block">
      <xsl:for-each select="./experience[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]">
        <xsl:sort select="concat(substring(./interval/start, 4, 4), substring(./interval/start, 1, 2))" order="descending"/>

        <tr class="list_item_row">
          <td class="list_item_label">
            <xsl:call-template name="getInterval">
              <xsl:with-param name="interval" select="./interval"/>
            </xsl:call-template>
          </td>
          <td class="experience_block">
            <xsl:choose>
              <xsl:when test="string-length(./title/@url)">
                <div class="experience_title"><a href="{./title/@url}"><xsl:value-of select="./title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/></a></div>
              </xsl:when>
              <xsl:otherwise>
                <div class="experience_title"><xsl:value-of select="./title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/></div>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="./employer">
              <div class="experience_employer">
                <xsl:choose>
                  <xsl:when test="string-length(./employer/person)">
                    <xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_responsible'"/></xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience_employer'"/></xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="string-length(./employer/person)"><xsl:value-of select="./employer/person"/>
                  <xsl:choose>
                    <xsl:when test="string-length(./employer/email)">
                      <xsl:text> (</xsl:text>
                      <a href="mailto:{./employer/email}"><xsl:value-of select="./employer/email"/></a>
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
              </div>
            </xsl:if>
            <xsl:if test="(string-length(./description[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]) and string-length($show_desc) = 0) or (string-length($show_desc) > 0 and $show_desc = 'yes')">
              <div class="experience_description">
                <xsl:apply-templates select="./description[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/>
              </div>
            </xsl:if>

            <xsl:if test="./keys and string-length($show_keys) and $show_keys='yes'">
              <div class="experience_keys">
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
              </div>
            </xsl:if>
          </td>
        </tr>
      </xsl:for-each>
    </table>

  </div>
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
  <div class="section">
    <xsl:choose>
      <xsl:when test="string-length(title)">
        <div class="section_title"><xsl:value-of select="title"/></div>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></div>
      </xsl:when>
      <xsl:otherwise>
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'education'"/></xsl:call-template></div>
      </xsl:otherwise>
    </xsl:choose>

    <table class="list_block education_block">
      <xsl:for-each select="./edu">
        <tr>
          <td class="list_item_label">
            <xsl:call-template name="getInterval">
              <xsl:with-param name="interval" select="./interval"/>
            </xsl:call-template>
          </td>
          <td class="list_item_body">
            <xsl:value-of select="./title"/>
            <xsl:if test="string-length(./institute/name)">
              <xsl:text>, </xsl:text><xsl:value-of select="./institute/name"/>
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
          </td>
        </tr>
      </xsl:for-each>
    </table>

  </div>
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
  <div class="section">
    <xsl:choose>
      <xsl:when test="string-length(title)">
        <div class="section_title"><xsl:value-of select="title"/></div>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></div>
      </xsl:when>
      <xsl:otherwise>
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'special_skills'"/></xsl:call-template></div>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:variable name="format">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'short_date_format'"/></xsl:call-template>
    </xsl:variable>

    <table class="list_block">
      <xsl:for-each select="./skill">
        <tr>
          <td class="list_item_label">
            <xsl:call-template name="getDateFormat">
              <xsl:with-param name="format" select="$format"/>
              <xsl:with-param name="date" select="./date"/>
            </xsl:call-template>
          </td>
          <td class="list_item_body">
            <xsl:value-of select="./title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>

  </div>
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
  <div style="padding-bottom: 2px;">
    <xsl:choose>
      <xsl:when test="string-length(title)">
        <div class="section_title"><xsl:value-of select="title"/></div>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></div>
      </xsl:when>
      <xsl:otherwise>
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'language_skills'"/></xsl:call-template></div>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="./language[not(@mother-tongue = 'yes')]">
      <div style="padding-bottom: 1mm"><span style="font-style: italic"><xsl:call-template name="getText"><xsl:with-param name="id" select="'table_mother_tongue'"/></xsl:call-template></span>

        <xsl:for-each select="./language[@mother-tongue = 'yes']">
          <xsl:sort select="./lang"/>

          <xsl:value-of select="./lang"/>

          <xsl:if test="not(position() = last())">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </div>
    </xsl:if>

    <table class="table" style="margin-bottom: 0px;">
      <tr>
        <th rowspan="2">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_language'"/></xsl:call-template>
        </th>
        <th colspan="4">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_understanding'"/></xsl:call-template>
        </th>
        <th colspan="4">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_speaking'"/></xsl:call-template>
        </th>
        <th colspan="2" rowspan="2" style="width: 17.5%">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_writing'"/></xsl:call-template>
        </th>
      </tr>

      <tr>
        <th colspan="2">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_listening'"/></xsl:call-template>
        </th>
        <th colspan="2">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_reading'"/></xsl:call-template>
        </th>
        <th colspan="2">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_interaction'"/></xsl:call-template>
        </th>
        <th colspan="2">
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'table_production'"/></xsl:call-template>
        </th>
      </tr>

      <xsl:for-each select="./language[not(@mother-tongue = 'yes')]">
        <xsl:sort select="./lang"/>

          <tr>
            <!-- lang -->
            <td>
              <xsl:if test="position() = 1">
                <xsl:attribute name="style">width: 12.5%;</xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="position() = last()">
                  <xsl:attribute name="style">text-align: left; text-indent: 1mm; border-bottom: none;</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="style">text-align: left; text-indent: 1mm;</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:value-of select="./lang"/>
            </td>

            <!-- understanding - listening - code -->
            <td>
              <xsl:if test="position() = 1">
                <xsl:attribute name="style">width: 3.5%;</xsl:attribute>
              </xsl:if>
              <xsl:if test="position() = last()">
                <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
              </xsl:if>
              <xsl:call-template name="getLangLevelCode">
                <xsl:with-param name="level" select="understanding/listening"/>
              </xsl:call-template>
            </td>

            <!-- understanding - listening - label -->
            <td>
              <xsl:if test="position() = 1">
                <xsl:attribute name="style">width: 14%;</xsl:attribute>
              </xsl:if>
              <xsl:if test="position() = last()">
                <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
              </xsl:if>
              <xsl:call-template name="getLangLevelLabel">
                <xsl:with-param name="level" select="understanding/listening"/>
              </xsl:call-template>
            </td>

            <!-- understanding - reading - code -->
            <td>
              <xsl:if test="position() = 1">
                <xsl:attribute name="style">width: 3.5%;</xsl:attribute>
              </xsl:if>
              <xsl:if test="position() = last()">
                <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
              </xsl:if>
              <xsl:call-template name="getLangLevelCode">
                <xsl:with-param name="level" select="understanding/reading"/>
              </xsl:call-template>
            </td>

            <!-- understanding - reading - label -->
            <td>
              <xsl:if test="position() = 1">
                <xsl:attribute name="style">width: 14%;</xsl:attribute>
              </xsl:if>
              <xsl:if test="position() = last()">
                <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
              </xsl:if>
              <xsl:call-template name="getLangLevelLabel">
                <xsl:with-param name="level" select="understanding/reading"/>
              </xsl:call-template>
            </td>

            <!-- speaking - interaction - code -->
            <td>
              <xsl:if test="position() = 1">
                <xsl:attribute name="style">width: 3.5%;</xsl:attribute>
              </xsl:if>
              <xsl:if test="position() = last()">
                <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
              </xsl:if>
              <xsl:call-template name="getLangLevelCode">
                <xsl:with-param name="level" select="speaking/interaction"/>
              </xsl:call-template>
            </td>

            <!-- speaking - interaction - label -->
            <td>
              <xsl:if test="position() = 1">
                <xsl:attribute name="style">width: 14%;</xsl:attribute>
              </xsl:if>
              <xsl:if test="position() = last()">
                <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
              </xsl:if>
              <xsl:call-template name="getLangLevelLabel">
                <xsl:with-param name="level" select="speaking/interaction"/>
              </xsl:call-template>
            </td>

            <!-- speaking - production - code -->
            <td>
              <xsl:if test="position() = 1">
                <xsl:attribute name="style">width: 3.5%;</xsl:attribute>
              </xsl:if>
              <xsl:if test="position() = last()">
                <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
              </xsl:if>
              <xsl:call-template name="getLangLevelCode">
                <xsl:with-param name="level" select="speaking/production"/>
              </xsl:call-template>
            </td>

              <!-- speaking - production - label -->
            <td>
              <xsl:if test="position() = 1">
                <xsl:attribute name="style">width: 14%;</xsl:attribute>
              </xsl:if>
              <xsl:if test="position() = last()">
                <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
              </xsl:if>
              <xsl:call-template name="getLangLevelLabel">
                <xsl:with-param name="level" select="speaking/production"/>
              </xsl:call-template>
            </td>

            <!-- writing - code -->
            <td>
              <xsl:if test="position() = 1">
                <xsl:attribute name="style">width: 3.5%;</xsl:attribute>
              </xsl:if>
              <xsl:if test="position() = last()">
                <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
              </xsl:if>
              <xsl:call-template name="getLangLevelCode">
                <xsl:with-param name="level" select="writing"/>
              </xsl:call-template>
            </td>

            <!-- writing - label -->
            <td>
              <xsl:if test="position() = 1">
                <xsl:attribute name="style">width: 14%;</xsl:attribute>
              </xsl:if>
              <xsl:if test="position() = last()">
                <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
              </xsl:if>
              <xsl:call-template name="getLangLevelLabel">
                <xsl:with-param name="level" select="writing"/>
              </xsl:call-template>
            </td>

          </tr>
        </xsl:for-each>
      </table>

      <div class="language_table_note">
        <xsl:call-template name="getText"><xsl:with-param name="id" select="'language_table_note'"/></xsl:call-template>
      </div>

  </div>
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
  <div class="section">
    <xsl:choose>
      <xsl:when test="string-length(title)">
        <div class="section_title"><xsl:value-of select="title"/></div>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></div>
      </xsl:when>
      <xsl:otherwise>
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'language_skills'"/></xsl:call-template></div>
      </xsl:otherwise>
    </xsl:choose>

    <table class="list_block">
      <xsl:for-each select="./language">
        <xsl:sort select="./lang"/>

        <tr>
          <td class="list_item_label">
            <xsl:value-of select="./lang"/>
          </td>
          <td class="list_item_body">
              <xsl:value-of select="$labeled_list_separator"/>
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
          </td>
        </tr>
      </xsl:for-each>
    </table>

  </div>
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
  <div class="section">
    <xsl:choose>
      <xsl:when test="string-length(title)">
        <div class="section_title"><xsl:value-of select="title"/></div>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></div>
      </xsl:when>
    </xsl:choose>

    <table class="list_block">
      <xsl:choose>
        <xsl:when test="string-length(@sort) and @sort = 'no'">
          <xsl:for-each select="./item">
            <tr>
              <td class="list_item_label">
                <xsl:value-of select="./label"/>
              </td>
              <td class="list_item_body">
                <xsl:value-of select="$labeled_list_separator"/>
                <xsl:value-of select="./value"/>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="./item">
            <xsl:sort select="./label"/>
            <tr>
              <td class="list_item_label">
                <xsl:value-of select="./label"/>
              </td>
              <td class="list_item_body">
                <xsl:value-of select="$labeled_list_separator"/>
                <xsl:value-of select="./value"/>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </table>

  </div>
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
  <div class="section">
    <xsl:choose>
      <xsl:when test="string-length(title)">
        <div class="section_title"><xsl:value-of select="title"/></div>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></div>
      </xsl:when>
    </xsl:choose>

    <div>
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
    </div>

  </div>
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

    <div class="section">
      <div class="signature_padding_top">
        <xsl:call-template name="getDateFormat">
          <xsl:with-param name="format"><xsl:call-template name="getText"><xsl:with-param name="id" select="'full_date_format'"/></xsl:call-template></xsl:with-param>
          <xsl:with-param name="date" select="$current_date"/>
        </xsl:call-template>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="/cv/personal/address/city"/>
      </div>
      <div class="signature_line">
        <xsl:value-of select="concat(/cv/personal/name/firstname, ' ', $middlename, /cv/personal/name/lastname)"/>
      </div>
      <br style="clear: both;"/>
    </div>
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
  <div class="section">
    <xsl:choose>
      <xsl:when test="string-length(title)">
        <div class="section_title"><xsl:value-of select="title"/></div>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></div>
      </xsl:when>
      <xsl:otherwise>
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'publications'"/></xsl:call-template></div>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="./publ">
      <div class="publications_block">
        <xsl:if test="position() != last()">
          <xsl:attribute name="style">padding-bottom: 2pt;</xsl:attribute>
        </xsl:if>

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

        <span class="publication_title"><xsl:value-of select="concat(' ', ./title, '.')"/></span>

        <xsl:if test="string-length(./event)">
          <xsl:value-of select="concat(' ', ./event, '.')"/>
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
          <xsl:text> Online [</xsl:text>
          <a rel="external" href="{./url}">
            <xsl:value-of select="./url"/>
          </a>
          <xsl:text>].</xsl:text>
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
      </div>
    </xsl:for-each>

  </div>
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
  <div class="section">
    <xsl:choose>
      <xsl:when test="string-length(title)">
        <div class="section_title"><xsl:value-of select="title"/></div>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></div>
      </xsl:when>
      <xsl:otherwise>
        <div class="section_title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'computer_knowledge'"/></xsl:call-template></div>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="./table">

      <table class="table">

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

        <tr>
          <th>
            <xsl:choose>
              <xsl:when test="@type = 5">
                <xsl:attribute name="style">width: 61%; text-align: left; padding-left: 1mm;</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="style">width: 25%</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="./title"/>
          </th>
          <th style="width: 15%;">
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'years_of_use'"/></xsl:call-template>
          </th>
          <th style="width: 12%;">
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'last_use'"/></xsl:call-template>
          </th>
          <xsl:if test="@type != 5">
            <th style="width: 12%;">
              <xsl:value-of select="$fourth_cell"/>
            </th>
            <th style="width: 12%;">
              <xsl:value-of select="$fifth_cell"/>
            </th>
            <th style="width: 12%;">
              <xsl:value-of select="$sixth_cell"/>
            </th>
          </xsl:if>
          <th style="width: 12%;">
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'self_rating'"/></xsl:call-template>
            <xsl:if test="position() = 1">
              <xsl:call-template name="getText"><xsl:with-param name="id" select="'self_rating_range'"/></xsl:call-template>
            </xsl:if>
          </th>
        </tr>

        <xsl:variable name="type" select="@type"/>

        <xsl:for-each select="./row">
          <xsl:sort select="./name"/>

            <tr>
              <!-- name -->
              <td>
                <xsl:choose>
                  <xsl:when test="position() = last()">
                    <xsl:attribute name="style">text-align: left; text-indent: 1mm; border-bottom: none;</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="style">text-align: left; text-indent: 1mm;</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="./name"/>
              </td>

              <!-- years of use -->
              <td>
                <xsl:if test="position() = last()">
                  <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="string-length(./interval/end)">
                     <xsl:value-of select="./interval/end - ./interval/start"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$current_year - ./interval/start"/>
                  </xsl:otherwise>
                </xsl:choose>
              </td>

              <!-- last use -->
              <td>
                <xsl:if test="position() = last()">
                  <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="string-length(./interval/end)">
                    <xsl:value-of select="./interval/end"/>
                  </xsl:when>
                  <xsl:when test="string-length(./interval/end) = 0 or (string-length(./interval/end) > 0 and ./interval/end = $current_year)">
                    <xsl:call-template name="getText"><xsl:with-param name="id" select="'now'"/></xsl:call-template>
                  </xsl:when>
                </xsl:choose>
              </td>

              <xsl:variable name="cross"><xsl:call-template name="getText"><xsl:with-param name="id" select="'cross'"/></xsl:call-template></xsl:variable>
              <xsl:variable name="dash"><xsl:call-template name="getText"><xsl:with-param name="id" select="'dash'"/></xsl:call-template></xsl:variable>

              <xsl:if test="$type != 5">
              <!-- unix | user | consultant -->
              <td>
                <xsl:if test="position() = last()">
                  <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
                </xsl:if>

                  <xsl:choose>
                  <xsl:when test="$type = 1 and string-length(./unix)">
                    <xsl:value-of select="$cross"/>
                  </xsl:when>
                  <xsl:when test="$type = 2 and string-length(./user)">
                    <xsl:value-of select="$cross"/>
                  </xsl:when>
                  <xsl:when test="$type = 3 and string-length(./consultant)">
                    <xsl:value-of select="$cross"/>
                  </xsl:when>
                  <xsl:otherwise>
                    &nbsp;
                  </xsl:otherwise>
                </xsl:choose>
              </td>

              <!-- windows | admin -->
              <td>
                <xsl:if test="position() = last()">
                  <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="$type = 1 and string-length(./windows)">
                    <xsl:value-of select="$cross"/>
                  </xsl:when>
                  <xsl:when test="($type = 2 or $type = 3) and string-length(./admin)">
                    <xsl:value-of select="$cross"/>
                  </xsl:when>
                  <xsl:otherwise>
                    &nbsp;
                  </xsl:otherwise>
                </xsl:choose>
              </td>

              <!-- developer -->
              <td>
                <xsl:if test="position() = last()">
                  <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="($type = 2 or $type = 3) and string-length(./developer)">
                    <xsl:value-of select="$cross"/>
                  </xsl:when>
                  <xsl:otherwise>
                    &nbsp;
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              </xsl:if>

              <!-- rating -->
              <td>
                <xsl:if test="position() = last()">
                  <xsl:attribute name="style">border-bottom: none;</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="./rating"/>
              </td>
            </tr>
        </xsl:for-each>

      </table>

    </xsl:for-each>

  </div>
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
        <xsl:call-template name="getText"><xsl:with-param name="id" select="'interval_dash'"/></xsl:call-template>
      </td>
      <td class="interval_side_cell">
        <xsl:choose>
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


<!-- bold text or description -->
<xsl:template match="b">
  <b><xsl:apply-templates/></b>
</xsl:template>


<!-- italic text or description -->
<xsl:template match="i">
  <i><xsl:apply-templates/></i>
</xsl:template>


<!-- underline text or description -->
<xsl:template match="u">
  <u><xsl:apply-templates/></u>
</xsl:template>


<!-- Nth text or description -->
<xsl:template match="nth">
  <span class="text_description-nth"><xsl:apply-templates/></span>
</xsl:template>


<!-- copy any text node beneath text or description -->
<xsl:template match="text//text()">
  <xsl:copy-of select="." />
</xsl:template>
<xsl:template match="description//text()">
  <xsl:copy-of select="." />
</xsl:template>


<!-- filter any other text -->
<xsl:template match="text()">
</xsl:template>


</xsl:transform>
