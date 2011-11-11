<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: XMLCL Setting - shared template
  **
  ** (c) Jiri Tyr 2011
  **********************************************************
  -->


<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<!--
 #########################
 ## P A R A M E T E R S ##
 #########################
-->

<!-- ### Common parameters -->

<!-- project name -->
<xsl:param name="project">xmlcl</xsl:param>

<!-- default role -->
<xsl:param name="role"></xsl:param>

<!-- current date -->
<xsl:param name="current_date">01/01/2011</xsl:param>

<!-- show footer -->
<xsl:param name="show_footer">yes</xsl:param>

<!-- default post name -->
<xsl:param name="post">???</xsl:param>

<!-- default job listing URL -->
<xsl:param name="job-listing"></xsl:param>

<!-- default recipient -->
<xsl:param name="recipient"></xsl:param>

<!-- default salutation -->
<xsl:param name="salutation"></xsl:param>

<!-- default indentation of paragraphs -->
<xsl:param name="noindent">no</xsl:param>

<!-- lower-case and upper-case characters -->
<xsl:param name="lc_char">abcdefghijklmnopqrstuvwxyzáčďéěíňóřšťúůýžäü</xsl:param>
<xsl:param name="uc_char">ABCDEFGHIJKLMNOPQRSTUVWXYZÁČĎÉĚÍŇÓŘŠŤÚŮÝŽÄÜ</xsl:param>

<!-- Default source XML path -->
<xsl:param name="src_path"></xsl:param>

<!-- Default recilipents file name -->
<xsl:param name="recipients_file">recipients.xml</xsl:param>

<!-- Default recipients file path -->
<xsl:param name="recipients" select="concat($src_path, '/', $recipients_file)"/>


<!-- ### FO parameters -->

<!-- default signature space (2.5cm should be sufficient)-->
<xsl:param name="signature-space">0cm</xsl:param>

<!-- font size -->
<xsl:param name="font_size">12</xsl:param>


<!-- ### XHTML parameters -->

<!-- css path -->
<xsl:param name="css_path">./css/</xsl:param>


<!-- ### TXT parameters -->

<!-- end of line (windows='&#xd;&#xa;', unix='&#xa;' ) -->
<xsl:param name="end_of_line" select="'&#xd;&#xa;'"/>

<!-- line length -->
<xsl:param name="line_length">80</xsl:param>

<!-- title bullet -->
<xsl:param name="title_bullet">### </xsl:param>

<!--
 ##################################
 ## A T T R I B U T E    S E T S ##
 ##################################
 ###### for FO template only ######
 ##################################
-->

<!-- link -->
<xsl:attribute-set name="link">
  <xsl:attribute name="color">black</xsl:attribute>
  <!--
  <xsl:attribute name="text-decoration">underline</xsl:attribute>
  -->
</xsl:attribute-set>

<!-- hyphenation -->
<xsl:attribute-set name="hyphenation">
  <xsl:attribute name="language"><xsl:value-of select="$lang"/></xsl:attribute>
  <xsl:attribute name="hyphenate">true</xsl:attribute>
  <xsl:attribute name="hyphenation-ladder-count">2</xsl:attribute>
  <xsl:attribute name="hyphenation-push-character-count">3</xsl:attribute>
  <xsl:attribute name="hyphenation-remain-character-count">3</xsl:attribute>
</xsl:attribute-set>


<!-- simple page master -->
<xsl:attribute-set name="simple.page.master">
  <xsl:attribute name="page-width">210mm</xsl:attribute>
  <xsl:attribute name="page-height">297mm</xsl:attribute>
  <xsl:attribute name="margin-top">30mm</xsl:attribute>
  <xsl:attribute name="margin-bottom">10mm</xsl:attribute>
  <xsl:attribute name="margin-left">20mm</xsl:attribute>
  <xsl:attribute name="margin-right">20mm</xsl:attribute>
</xsl:attribute-set>

<!-- page sequence - global font setting -->
<xsl:attribute-set name="page.sequence">
  <xsl:attribute name="font-family">Arial</xsl:attribute>
  <xsl:attribute name="font-size"><xsl:value-of select="concat($font_size, 'pt')"/></xsl:attribute>
</xsl:attribute-set>

<!-- footer -->
<xsl:attribute-set name="footer">
  <xsl:attribute name="color">silver</xsl:attribute>
  <xsl:attribute name="font-size">8pt</xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>


<!-- ruler -->
<xsl:attribute-set name="ruler">
  <xsl:attribute name="space-before">12pt</xsl:attribute>
  <xsl:attribute name="space-after">10pt</xsl:attribute>
  <xsl:attribute name="border-bottom">2px solid black</xsl:attribute>
</xsl:attribute-set>

<!-- personal - name -->
<xsl:attribute-set name="personal.name">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="font-size">18pt</xsl:attribute>
</xsl:attribute-set>

<!-- personal - address -->
<xsl:attribute-set name="personal.address">
  <xsl:attribute name="font-size">10pt</xsl:attribute>
  <xsl:attribute name="text-align">right</xsl:attribute>
</xsl:attribute-set>

<!-- personal - contact -->
<xsl:attribute-set name="personal.contact">
  <xsl:attribute name="font-size">10pt</xsl:attribute>
  <xsl:attribute name="space-after">32pt</xsl:attribute>
  <xsl:attribute name="text-align">right</xsl:attribute>
</xsl:attribute-set>

<!-- recipients -->
<xsl:attribute-set name="recipients">
  <xsl:attribute name="space-after">24pt</xsl:attribute>
</xsl:attribute-set>

<!-- date -->
<xsl:attribute-set name="date">
  <xsl:attribute name="space-after">24pt</xsl:attribute>
</xsl:attribute-set>

<!-- salutation block -->
<xsl:attribute-set name="salutation.block">
  <xsl:attribute name="space-after">6pt</xsl:attribute>
</xsl:attribute-set>

<!-- text - p -->
<xsl:attribute-set name="text.p">
  <xsl:attribute name="space-after">8pt</xsl:attribute>
  <xsl:attribute name="text-indent">10mm</xsl:attribute>
  <xsl:attribute name="text-align">justify</xsl:attribute>
</xsl:attribute-set>

<!-- text - b -->
<xsl:attribute-set name="text.b">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>

<!-- text - i -->
<xsl:attribute-set name="text.i">
  <xsl:attribute name="font-style">italic</xsl:attribute>
</xsl:attribute-set>

<!-- text - u -->
<xsl:attribute-set name="text.u">
  <xsl:attribute name="text-decoration">underline</xsl:attribute>
</xsl:attribute-set>

<!-- text - nth -->
<xsl:attribute-set name="text.nth">
  <xsl:attribute name="font-size">70%</xsl:attribute>
  <xsl:attribute name="alignment-adjust">30%</xsl:attribute>
</xsl:attribute-set>

<!-- greeting -->
<xsl:attribute-set name="greeting">
</xsl:attribute-set>

<!-- greeting - name-->
<xsl:attribute-set name="greeting.name">
  <xsl:attribute name="space-before"><xsl:value-of select="$signature-space"/></xsl:attribute>
</xsl:attribute-set>


<!--
 ###################
 ## C O M M O N S ##
 ###################
-->

<xsl:template name="getFullName">
  <!-- get middlename -->
  <xsl:variable name="middlename">
    <xsl:if test="string-length(/cl/personal/name/middlename)">
      <xsl:value-of select="concat(/cl/personal/name/middlename, ' ')"/>
    </xsl:if>
  </xsl:variable>

  <!-- name -->
  <xsl:value-of select="concat(/cl/personal/name/firstname, ' ', $middlename, /cl/personal/name/lastname)"/>
</xsl:template>


</xsl:transform>
