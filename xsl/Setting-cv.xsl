<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: XMLCV Setting - shared template
  **
  ** (c) Jiri Tyr 2008-2011
  **********************************************************
  -->


<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<!--
 #########################
 ## P A R A M E T E R S ##
 #########################
-->

<!-- project name -->
<xsl:param name="project">xmlcv</xsl:param>

<!-- default role -->
<xsl:param name="role"></xsl:param>

<!-- current date -->
<xsl:param name="current_date">01/01/2011</xsl:param>

<!-- current year -->
<xsl:param name="current_year" select="substring($current_date, 7, 4)"/>

<!-- show footer -->
<xsl:param name="show_footer">yes</xsl:param>

<!-- show signature -->
<xsl:param name="show_signature">yes</xsl:param>

<!-- font size -->
<xsl:param name="font_size">12</xsl:param>

<!-- css path -->
<xsl:param name="css_path">./css/</xsl:param>

<!-- color of text in not used cell -->
<xsl:param name="ck_not_used_color">white</xsl:param> <!-- if it is white, it will be not visible -->

<!-- end of line (windows='&#xd;&#xa;', unix='&#xa;' ) -->
<xsl:param name="end_of_line" select="'&#xd;&#xa;'"/>

<!-- line length -->
<xsl:param name="line_length">80</xsl:param>

<!-- language list separator -->
<xsl:param name="labeled_list_separator"> - </xsl:param>

<!-- title bullet -->
<xsl:param name="title_bullet">### </xsl:param>

<!-- lower-case and upper-case characters -->
<xsl:param name="lc_char">abcdefghijklmnopqrstuvwxyzáčďéěíňóřšťúůýžäü</xsl:param>
<xsl:param name="uc_char">ABCDEFGHIJKLMNOPQRSTUVWXYZÁČĎÉĚÍŇÓŘŠŤÚŮÝŽÄÜ</xsl:param>

<!-- *** getInterval indent used in Work experience and Education ***
                        =>|  |<= distance
|<======== width ========>|  |
+==========+===+==========+
| Jan 2006 | - | Mar 2007 |  Text text text
+==========+===+==========+
         =>|   |<= separator_width
-->
<xsl:param name="listitem_indent_width">45</xsl:param>
<xsl:param name="listitem_indent_distance">3</xsl:param>
<xsl:param name="listitem_indent_unit">mm</xsl:param>
<xsl:param name="listitem_indent_separator_width">4.5mm</xsl:param>


<!--
 ##################################
 ## A T T R I B U T E    S E T S ##
 ##################################
-->

<!-- link -->
<xsl:attribute-set name="link">
  <xsl:attribute name="color">black</xsl:attribute>
  <xsl:attribute name="text-decoration">underline</xsl:attribute>
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
  <xsl:attribute name="margin-top">15mm</xsl:attribute>
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
  <xsl:attribute name="text-align-last">justify</xsl:attribute>
</xsl:attribute-set>

<!-- left part of the footer -->
<xsl:attribute-set name="footer.left">
  <xsl:attribute name="font-style">italic</xsl:attribute>
</xsl:attribute-set>

<!-- right part of the footer -->
<xsl:attribute-set name="footer.right">
  <xsl:attribute name="font-style">normal</xsl:attribute>
</xsl:attribute-set>


<!-- margin of list-item-body -->
<xsl:attribute-set name="list.item.body">
  <xsl:attribute name="margin-left"><xsl:value-of select="concat($listitem_indent_width, $listitem_indent_unit)"/></xsl:attribute>
</xsl:attribute-set>

<!-- curriculum vitae title -->
<xsl:attribute-set name="cv.title">
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="space-after">12pt</xsl:attribute>
  <xsl:attribute name="font-size">14pt</xsl:attribute>
</xsl:attribute-set>

<!-- section -->
<xsl:attribute-set name="section">
  <xsl:attribute name="space-after">12pt</xsl:attribute>
</xsl:attribute-set>

<!-- title of a section -->
<xsl:attribute-set name="section.title">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="font-style">italic</xsl:attribute>
  <xsl:attribute name="space-after">2pt</xsl:attribute>
  <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
</xsl:attribute-set>


<!-- personal table -->
<xsl:attribute-set name="personal.table">
  <xsl:attribute name="space-after">14pt</xsl:attribute>
  <xsl:attribute name="table-layout">fixed</xsl:attribute>
  <xsl:attribute name="width">100%</xsl:attribute>
</xsl:attribute-set>

<!-- personal table first column -->
<xsl:attribute-set name="personal.table.column">
  <xsl:attribute name="column-width">60.3mm</xsl:attribute>
</xsl:attribute-set>

<!-- personal table label cell -->
<xsl:attribute-set name="personal.table.cell.label">
  <xsl:attribute name="color">#656565</xsl:attribute>
  <xsl:attribute name="text-align">right</xsl:attribute>
  <xsl:attribute name="font-style">italic</xsl:attribute>
  <xsl:attribute name="margin-right">1mm</xsl:attribute>
</xsl:attribute-set>

<!-- personal table text cell -->
<xsl:attribute-set name="personal.table.cell.text">
  <xsl:attribute name="display-align">before</xsl:attribute>
</xsl:attribute-set>

<!-- cell where is photo located -->
<xsl:attribute-set name="personal.photo.cell">
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="display-align">center</xsl:attribute>
</xsl:attribute-set>

<!-- external-graphic of the photo -->
<xsl:attribute-set name="personal.photo.graphic">
  <xsl:attribute name="border">2px solid silver</xsl:attribute>
</xsl:attribute-set>

<!-- text-block section -->
<xsl:attribute-set name="text-block.block">
  <xsl:attribute name="text-align">justify</xsl:attribute>
</xsl:attribute-set>

<!-- text-block/text, work-experience/description - b -->
<xsl:attribute-set name="text_description.b">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>

<!-- text-block/text, work-experience/description - i -->
<xsl:attribute-set name="text_description.i">
  <xsl:attribute name="font-style">italic</xsl:attribute>
</xsl:attribute-set>

<!-- text-block/text, work-experience/description - u -->
<xsl:attribute-set name="text_description.u">
  <xsl:attribute name="text-decoration">underline</xsl:attribute>
</xsl:attribute-set>

<!-- text-block/text, work-experience/description - nth -->
<xsl:attribute-set name="text_description.nth">
  <xsl:attribute name="font-size">70%</xsl:attribute>
  <xsl:attribute name="alignment-adjust">30%</xsl:attribute>
</xsl:attribute-set>

<!-- title of a experience -->
<xsl:attribute-set name="experience.title">
  <xsl:attribute name="text-align">justify</xsl:attribute>
</xsl:attribute-set>

<!-- employer of a experience -->
<xsl:attribute-set name="experience.employer">
  <xsl:attribute name="font-size">8pt</xsl:attribute>
  <xsl:attribute name="text-align">justify</xsl:attribute>
</xsl:attribute-set>

<!-- description of a experience -->
<xsl:attribute-set name="experience.description">
  <xsl:attribute name="text-align">justify</xsl:attribute>
  <xsl:attribute name="font-size">10pt</xsl:attribute>
  <xsl:attribute name="color">#656565</xsl:attribute>
</xsl:attribute-set>

<!-- keys of a experience -->
<xsl:attribute-set name="experience.keys">
  <xsl:attribute name="text-align">justify</xsl:attribute>
  <xsl:attribute name="font-size">8pt</xsl:attribute>
  <xsl:attribute name="color">#B5B5B5</xsl:attribute>
</xsl:attribute-set>

<!-- block of a education -->
<xsl:attribute-set name="education.block">
  <xsl:attribute name="space-after">0pt</xsl:attribute>
</xsl:attribute-set>

<!-- top padding for a signature line -->
<xsl:attribute-set name="signature.padding.top">
  <xsl:attribute name="padding-top">1cm</xsl:attribute>
</xsl:attribute-set>

<!-- left padding for a signature line (100% - width of signature.line) -->
<xsl:attribute-set name="signature.padding.left">
  <xsl:attribute name="padding-left">100% - 5cm</xsl:attribute>
</xsl:attribute-set>

<!-- width and style of the signature line -->
<xsl:attribute-set name="signature.line">
  <xsl:attribute name="width">5cm</xsl:attribute>
  <xsl:attribute name="border-top">1px dashed black</xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="font-size">10pt</xsl:attribute>
  <xsl:attribute name="padding-top">1mm</xsl:attribute>
</xsl:attribute-set>

<!-- block of a publications -->
<xsl:attribute-set name="publications.block">
  <xsl:attribute name="text-align">justify</xsl:attribute>
</xsl:attribute-set>

<!-- title of a publication -->
<xsl:attribute-set name="publication.title">
  <xsl:attribute name="font-style">italic</xsl:attribute>
</xsl:attribute-set>

<!-- table -->
<xsl:attribute-set name="table">
  <xsl:attribute name="space-after">12pt</xsl:attribute>
  <xsl:attribute name="border">1px solid black</xsl:attribute>
  <xsl:attribute name="font-size">10pt</xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="table-layout">fixed</xsl:attribute>
  <xsl:attribute name="width">100%</xsl:attribute>
  <xsl:attribute name="table-omit-header-at-break">true</xsl:attribute>
</xsl:attribute-set>

<!-- column of a table -->
<xsl:attribute-set name="table.column">
  <xsl:attribute name="wrap-option">wrap</xsl:attribute>
</xsl:attribute-set>

<!-- header of the table -->
<xsl:attribute-set name="table.header">
  <xsl:attribute name="border-bottom">1px solid black</xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>

<!-- header cell of a table -->
<xsl:attribute-set name="table.header.cell">
  <xsl:attribute name="padding-top">2px</xsl:attribute>
  <xsl:attribute name="display-align">center</xsl:attribute>
  <xsl:attribute name="background-color">#e6e6e6</xsl:attribute>
  <xsl:attribute name="border-right">1px solid black</xsl:attribute>
  <xsl:attribute name="language"><xsl:value-of select="$lang"/></xsl:attribute>
  <xsl:attribute name="hyphenate">true</xsl:attribute>
  <xsl:attribute name="hyphenation-ladder-count">2</xsl:attribute>
  <xsl:attribute name="hyphenation-push-character-count">3</xsl:attribute>
  <xsl:attribute name="hyphenation-remain-character-count">4</xsl:attribute>
</xsl:attribute-set>

<!-- header cell of a table in the second row -->
<xsl:attribute-set name="table.header.cell.secondrow">
  <xsl:attribute name="border-top">1px solid black</xsl:attribute>
</xsl:attribute-set>

<!-- body cell block of a table -->
<xsl:attribute-set name="table.body.cell">
  <xsl:attribute name="padding-top">2px</xsl:attribute>
  <xsl:attribute name="border-right">1px solid black</xsl:attribute>
  <xsl:attribute name="border-bottom">0.5px solid #c0c0c0</xsl:attribute>
  <xsl:attribute name="display-align">center</xsl:attribute>
</xsl:attribute-set>

<!-- note under the language table -->
<xsl:attribute-set name="language.table.note">
  <xsl:attribute name="padding-top">2px</xsl:attribute>
  <xsl:attribute name="font-size">6pt</xsl:attribute>
  <xsl:attribute name="text-align">right</xsl:attribute>
  <xsl:attribute name="space-after">12pt</xsl:attribute>
</xsl:attribute-set>


</xsl:transform>
