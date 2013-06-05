<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: FO stylesheet for XMLCL
  **
  ** (c) Jiri Tyr 2011
  **********************************************************
  -->


<xsl:transform version="1.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:fo="http://www.w3.org/1999/XSL/Format">


<!-- output settings -->
<xsl:output
  method="xml"
  encoding="UTF-8"
  indent="no"
/>


<!-- global params -->
<xsl:param name="lang" select="/cl/@lang"/>


<!-- includes -->
<xsl:include href="includes/Setting-cl.xsl"/>
<xsl:include href="includes/Utils.xsl"/>


<!-- main template -->
<xsl:template match="/">
  <fo:root>
    <fo:layout-master-set>
      <fo:simple-page-master master-name="A4" xsl:use-attribute-sets="simple.page.master">
        <fo:region-body margin-bottom="10mm"/>
        <xsl:if test="$show_footer = 'yes'">
          <fo:region-after extent="10mm" region-name="footer"/>
        </xsl:if>
      </fo:simple-page-master>
    </fo:layout-master-set>

    <fo:page-sequence master-reference="A4" xsl:use-attribute-sets="page.sequence">
      <xsl:if test="$show_footer = 'yes'">
        <fo:static-content flow-name="footer" xsl:use-attribute-sets="footer">
          <fo:block>
            <fo:basic-link external-destination="http://jtyr.github.io/xmlcv/"><xsl:call-template name="getText"><xsl:with-param name="id" select="'generated_by'"/></xsl:call-template></fo:basic-link>
          </fo:block>
        </fo:static-content>
      </xsl:if>

      <fo:flow flow-name="xsl-region-body">
        <xsl:apply-templates/>
      </fo:flow>
    </fo:page-sequence>
  </fo:root>
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
  <fo:block xsl:use-attribute-sets="personal.name">
    <xsl:call-template name="getFullName"/>
  </fo:block>

  <!-- ruler -->
  <fo:block xsl:use-attribute-sets="ruler"/>

  <!-- address -->
  <fo:block xsl:use-attribute-sets="personal.address">
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
  </fo:block>

  <!-- telephone and e-mail -->
  <fo:block xsl:use-attribute-sets="personal.contact">
    <xsl:if test="./telephone">
      <xsl:value-of select="./telephone"/>
    </xsl:if>
    <xsl:if test="./email">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:if test="./email">
      <fo:basic-link xsl:use-attribute-sets="link" external-destination="{concat('mailto:', ./email)}">
        <xsl:value-of select="./email"/>
      </fo:basic-link>
    </xsl:if>
  </fo:block>

  <!-- date -->
  <fo:block xsl:use-attribute-sets="date">
    <xsl:call-template name="getDateFormat">
      <xsl:with-param name="format"><xsl:call-template name="getText"><xsl:with-param name="id" select="'full_date_format'"/></xsl:call-template></xsl:with-param>
      <xsl:with-param name="date" select="$current_date"/>
    </xsl:call-template>
  </fo:block>

  <!-- recipient -->
  <xsl:if test="/cl/recipients/recipient[@id = $recipient] or document($recipients)//recipient[@id = $recipient]">
    <xsl:variable name="recipient_node" select="/cl/recipients/recipient[@id = $recipient] | document($recipients)//recipient[@id = $recipient]"/>

    <fo:block xsl:use-attribute-sets="recipients">
      <fo:block><xsl:value-of select="$recipient_node/name"/></fo:block>
      <!-- address -->
      <fo:block>
        <xsl:choose>
          <xsl:when test="string-length($recipient_node/residence)">
            <xsl:value-of select="$recipient_node/residence"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$recipient_node/street"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
      <xsl:if test="string-length($recipient_node/residence)">
        <fo:block>
          <xsl:value-of select="$recipient_node/street"/>
        </fo:block>
      </xsl:if>
      <fo:block>
        <xsl:value-of select="concat($recipient_node/postcode, ' ', $recipient_node/city)"/>
      </fo:block>
      <xsl:if test="string-length($recipient_node/country)">
        <fo:block>
          <xsl:choose>
            <xsl:when test="$recipient_node/country[@lang=$lang]">
              <xsl:value-of select="$recipient_node/country[@lang=$lang]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$recipient_node/country[not(@lang)]"/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </xsl:if>
    </fo:block>
  </xsl:if>

  <!-- salutation -->
  <fo:block xsl:use-attribute-sets="salutation.block">
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
  </fo:block>
</xsl:template>


<!-- text section -->
<xsl:template match="text[@show!='yes']">
</xsl:template>
<xsl:template match="text[@show='yes' or not(@show)]">
  <xsl:for-each select="p[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]">
    <xsl:apply-templates select="."/>
  </xsl:for-each>

  <!-- greeting -->
  <xsl:choose>
    <xsl:when test="string-length($greeting) > 0 and $greeting = 'none'">
      <!-- do nothing -->
    </xsl:when>
    <xsl:when test="string-length($greeting) > 0">
      <fo:block xsl:use-attribute-sets="greeting">
        <xsl:value-of select="$greeting"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block xsl:use-attribute-sets="greeting">
        <xsl:call-template name="getText"><xsl:with-param name="id" select="'greeting'"/></xsl:call-template>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
  <fo:block xsl:use-attribute-sets="greeting.name">
    <xsl:call-template name="getFullName"/>
  </fo:block>
</xsl:template>


<!-- parahraph -->
<xsl:template match="text/p">
  <fo:block xsl:use-attribute-sets="text.p hyphenation">
    <xsl:if test="$noindent='yes' or @noindent='yes'">
      <xsl:attribute name="text-indent">0</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>


<!-- bold text -->
<xsl:template match="text/p//b">
  <fo:inline xsl:use-attribute-sets="text.b">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!-- italic text -->
<xsl:template match="text/p//i">
  <fo:inline xsl:use-attribute-sets="text.i">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!-- underline text -->
<xsl:template match="text/p//u">
  <fo:inline xsl:use-attribute-sets="text.u">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!-- Nth text -->
<xsl:template match="text/p//nth">
  <fo:inline xsl:use-attribute-sets="text.nth">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!-- recipient-name element -->
<xsl:template match="text/p//recipient-name">
  <xsl:value-of select="document($recipients)//recipient[@id = $recipient]/name"/>
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

  <fo:basic-link xsl:use-attribute-sets="link" external-destination="{concat($url_prefix, $job_listing)}">
    <xsl:value-of select="$job_listing"/>
  </fo:basic-link>
</xsl:template>


<!-- copy any text node beneath p -->
<xsl:template match="text/p//text()">
  <xsl:copy-of select="." />
</xsl:template>


<!-- filter any other text -->
<xsl:template match="text()">
</xsl:template>


</xsl:transform>
