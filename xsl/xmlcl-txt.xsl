<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: TXT stylesheet for XMLCL
  **
  ** (c) Jiri Tyr 2011
  **********************************************************
  -->


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
<xsl:param name="lang" select="/cl/@lang"/>


<!-- includes -->
<xsl:include href="includes/Setting-cl.xsl"/>
<xsl:include href="includes/Utils.xsl"/>


<!-- main template -->
<xsl:template match="/">
  <xsl:apply-templates/>
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
  <xsl:call-template name="printNewLine"/>
  <xsl:call-template name="getFullName"/>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>

  <!-- ruler -->
  <xsl:call-template name="for.loop">
    <xsl:with-param name="count" select="$line_length"/>
    <xsl:with-param name="char" select="'='"/>
  </xsl:call-template>
  <xsl:call-template name="printNewLine"/>

  <!-- address -->
  <xsl:variable name="personal_address">
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
  </xsl:variable>
  <xsl:call-template name="for.loop">
    <xsl:with-param name="count" select="($line_length - string-length($personal_address))"/>
    <xsl:with-param name="char" select="' '"/>
  </xsl:call-template>
  <xsl:value-of select="$personal_address"/>
  <xsl:call-template name="printNewLine"/>

  <!-- telephone and e-mail -->
  <xsl:variable name="personal_contact">
    <xsl:if test="./telephone">
      <xsl:value-of select="./telephone"/>
    </xsl:if>
    <xsl:if test="./email">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:if test="./email">
      <xsl:value-of select="./email"/>
    </xsl:if>
  </xsl:variable>
  <xsl:call-template name="for.loop">
    <xsl:with-param name="count" select="($line_length - string-length($personal_contact))"/>
    <xsl:with-param name="char" select="' '"/>
  </xsl:call-template>
  <xsl:value-of select="$personal_contact"/>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="3"/></xsl:call-template>

  <!-- date -->
  <xsl:call-template name="getDateFormat">
    <xsl:with-param name="format"><xsl:call-template name="getText"><xsl:with-param name="id" select="'full_date_format'"/></xsl:call-template></xsl:with-param>
    <xsl:with-param name="date" select="$current_date"/>
  </xsl:call-template>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="3"/></xsl:call-template>

  <!-- recipient -->
  <xsl:if test="document($recipients)//recipient[@id = $recipient]">
    <xsl:variable name="recipient_node" select="document($recipients)//recipient[@id = $recipient]"/>

    <xsl:variable name="recipient_address">
      <xsl:value-of select="$recipient_node/name"/>
      <xsl:call-template name="printNewLine"/>
      <!-- address -->
      <xsl:choose>
        <xsl:when test="string-length($recipient_node/residence)">
          <xsl:value-of select="$recipient_node/residence"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$recipient_node/street"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="printNewLine"/>
      <xsl:if test="string-length($recipient_node/residence)">
        <xsl:value-of select="$recipient_node/street"/>
        <xsl:call-template name="printNewLine"/>
      </xsl:if>
      <xsl:value-of select="concat($recipient_node/postcode, ' ', $recipient_node/city)"/>
      <xsl:call-template name="printNewLine"/>
      <xsl:if test="string-length($recipient_node/country)">
        <xsl:value-of select="$recipient_node/country"/>
        <xsl:call-template name="printNewLine"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="$recipient_address"/>
    <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
  </xsl:if>

  <!-- salutation -->
  <xsl:variable name="salutation_block">
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
  </xsl:variable>
  <xsl:value-of select="$salutation_block"/>
  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
</xsl:template>


<!-- text section -->
<xsl:template match="text[@show!='yes']">
</xsl:template>
<xsl:template match="text[@show='yes' or not(@show)]">
  <xsl:for-each select="p[contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)]">
    <xsl:variable name="p_text">
      <xsl:apply-templates select="."/>
    </xsl:variable>

    <xsl:variable name="indent_len">
      <xsl:choose>
        <xsl:when test="$noindent='yes' or @noindent='yes'">
          <xsl:value-of select="0"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="4"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="indent_text">
      <xsl:call-template name="for.loop">
        <xsl:with-param name="count" select="$indent_len"/>
        <xsl:with-param name="char" select="' '"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="wrap-string">
      <xsl:with-param name="str" select="concat($indent_text, normalize-space($p_text))"/>
    </xsl:call-template>

    <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
  </xsl:for-each>

  <!-- greeting -->
  <xsl:choose>
    <xsl:when test="string-length($greeting) > 0 and $greeting = 'none'">
      <!-- do nothing -->
    </xsl:when>
    <xsl:when test="string-length($greeting) > 0">
      <xsl:value-of select="$greeting"/>
      <xsl:call-template name="printNewLine"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'greeting'"/></xsl:call-template>
      <xsl:call-template name="printNewLine"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="getFullName"/>
  <xsl:call-template name="printNewLine"/>
</xsl:template>


<!-- parahraph -->
<xsl:template match="text/p">
  <xsl:apply-templates/>

  <xsl:call-template name="printNewLine"><xsl:with-param name="count" select="2"/></xsl:call-template>
</xsl:template>


<!-- recipient-name element -->
<xsl:template match="text/p//recipient-name">
  <xsl:value-of select="document($recipients)//recipient[@id = $recipient]/name"/>
</xsl:template>


<!-- post element -->
<xsl:template match="text/p//post">
  <xsl:value-of select="concat('&quot;', $post, '&quot;')"/>
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

  <xsl:value-of select="$job_listing"/>
</xsl:template>


<!-- copy any text node beneath p -->
<xsl:template match="text/p//text()">
  <xsl:copy-of select="." />
</xsl:template>


<!-- filter any other text -->
<xsl:template match="text()">
</xsl:template>


</xsl:transform>
