<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: XHTML stylesheet for XMLCL
  **
  ** (c) Jiri Tyr 2011
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
               xmlns:fo="http://www.w3.org/1999/XSL/Format"
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
<xsl:param name="lang" select="/cl/@lang"/>


<!-- includes -->
<xsl:include href="includes/Setting-cl.xsl"/>
<xsl:include href="includes/Utils.xsl"/>


<!-- main template -->
<xsl:template match="/">
  <xsl:variable name="author">
    <xsl:call-template name="getFullName"/>
  </xsl:variable>

  <xsl:variable name="title">
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'cl'"/></xsl:call-template>
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'of'"/></xsl:call-template>
    <xsl:value-of select="$author"/>
  </xsl:variable>

  <xsl:variable name="css_path_local">
    <xsl:choose>
      <xsl:when test="/cl/@css-path">
        <xsl:value-of select="concat(/cl/@css-path, '/')"/>
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
      <meta name="keywords" content="xmlcv,cl,cover letter,xsl,xslt,xhtml,fo,pdf"/>
      <meta name="description" content="{$title}"/>
      <link media="screen" href="{$css_path_local}xmlcl.css" type="text/css" rel="stylesheet"/>
    </head>
    <body class="xmlcl">
      <div id="Page">
        <xsl:apply-templates/>

        <div class="generated_by"><a rel="external" href="http://xmlcv.sourceforge.net"><xsl:call-template name="getText"><xsl:with-param name="id" select="'generated_by'"/></xsl:call-template></a></div>
      </div>

      <script type="text/javascript">
      <xsl:comment>
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
  <!-- name -->
  <div class="personal_name">
    <xsl:call-template name="getFullName"/>
  </div>

  <!-- ruler -->
  <div class="ruler">.</div>

  <!-- address -->
  <div class="personal_address">
    <xsl:choose>
      <xsl:when test="string-length(./address/residence)">
        <xsl:value-of select="./address/residence"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="./address/street"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>, </xsl:text>
    <xsl:if test="string-length(./address/residence)">
      <xsl:value-of select="./address/street"/>
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:value-of select="concat(./address/postcode, ' ', ./address/city)"/>
    <xsl:if test="string-length(./address/country)">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="./address/country"/>
    </xsl:if>
  </div>

  <!-- telephone and e-mail -->
  <div class="personal_contact">
    <xsl:if test="./telephone">
      <xsl:value-of select="./telephone"/>
    </xsl:if>
    <xsl:if test="./email">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:if test="./email">
      <a href="{concat('mailto:', ./email)}">
        <xsl:value-of select="./email"/>
      </a>
    </xsl:if>
  </div>

  <!-- date -->
  <div class="date">
    <xsl:call-template name="getDateFormat">
      <xsl:with-param name="format"><xsl:call-template name="getText"><xsl:with-param name="id" select="'full_date_format'"/></xsl:call-template></xsl:with-param>
      <xsl:with-param name="date" select="$current_date"/>
    </xsl:call-template>
  </div>

  <!-- recipient -->
  <xsl:if test="document($recipients)//recipient[@id = $recipient]">
    <xsl:variable name="recipient_node" select="document($recipients)//recipient[@id = $recipient]"/>

    <div class="recipients">
      <div><xsl:value-of select="$recipient_node/name"/></div>
      <!-- address -->
      <div>
        <xsl:choose>
          <xsl:when test="string-length($recipient_node/residence)">
            <xsl:value-of select="$recipient_node/residence"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$recipient_node/street"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
      <xsl:if test="string-length($recipient_node/residence)">
        <div>
          <xsl:value-of select="$recipient_node/street"/>
        </div>
      </xsl:if>
      <div>
        <xsl:value-of select="concat($recipient_node/postcode, ' ', $recipient_node/city)"/>
      </div>
      <xsl:if test="string-length($recipient_node/country)">
        <div>
          <xsl:value-of select="$recipient_node/country"/>
        </div>
      </xsl:if>
    </div>
  </xsl:if>

  <!-- salutation -->
  <div class="salutation_block">
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'salutation_beginning'"/></xsl:call-template>
    <xsl:choose>
      <xsl:when test="string-length($salutation)">
        <xsl:value-of select="$salutation"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="getText"><xsl:with-param name="id" select="'salutation_default'"/></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'salutation_end'"/></xsl:call-template>
  </div>
</xsl:template>


<!-- text section -->
<xsl:template match="text[@show!='yes']">
</xsl:template>
<xsl:template match="text[@show='yes' or not(@show)]">
  <xsl:for-each select="p[contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)]">
    <xsl:apply-templates select="."/>
  </xsl:for-each>

  <!-- greeting -->
  <div class="greeting">
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'greeting'"/></xsl:call-template>
  </div>
  <div class="greeting_name">
    <xsl:call-template name="getFullName"/>
  </div>
</xsl:template>


<!-- parahraph -->
<xsl:template match="text/p">
  <div class="text_p hyphenation">
    <xsl:if test="$noindent='yes' or @noindent='yes'">
      <xsl:attribute name="text-indent">0</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </div>
</xsl:template>


<!-- bold text -->
<xsl:template match="text/p//b">
  <b>
    <xsl:apply-templates/>
  </b>
</xsl:template>


<!-- italic text -->
<xsl:template match="text/p//i">
  <i>
    <xsl:apply-templates/>
  </i>
</xsl:template>


<!-- underline text -->
<xsl:template match="text/p//u">
  <u>
    <xsl:apply-templates/>
  </u>
</xsl:template>


<!-- Nth text -->
<xsl:template match="text/p//nth">
  <span class="text_nth">
    <xsl:apply-templates/>
  </span>
</xsl:template>


<!-- post element -->
<xsl:template match="text/p//post">
  <xsl:value-of select="$post"/>
</xsl:template>


<!-- job-listing element -->
<xsl:template match="text/p//job-listing">
  <xsl:variable name="job_listing">
    <xsl:choose>
      <xsl:when test="string-length($job-listing)">
        <xsl:value-of select="$job-listing"/>
      </xsl:when>
      <xsl:when test="string-length(document($recipients)//recipient[@id = $recipient]/job-listing)">
        <xsl:value-of select="document($recipients)//recipient[@id = $recipient]/job-listing"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>???</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="url_prefix">
    <xsl:if test="not(starts-with($job_listing, 'http://') or starts-with($job_listing, 'https://'))">
      <xsl:text>http://</xsl:text>
    </xsl:if>
  </xsl:variable>

  <a href="{concat($url_prefix, $job_listing)}">
    <xsl:value-of select="$job_listing"/>
  </a>
</xsl:template>


<!-- copy any text node beneath p -->
<xsl:template match="text/p//text()">
  <xsl:copy-of select="." />
</xsl:template>


<!-- filter any other text -->
<xsl:template match="text()">
</xsl:template>


</xsl:transform>
