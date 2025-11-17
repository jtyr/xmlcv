<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: FO stylesheet for XMLCV
  **
  ** (c) Jiri Tyr 2008-2025
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
<xsl:param name="lang" select="/cv/@lang"/>


<!-- includes -->
<xsl:include href="includes/Setting-cv.xsl"/>
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
            <fo:inline xsl:use-attribute-sets="footer.left">
              <xsl:call-template name="getText"><xsl:with-param name="id" select="'cv'"/></xsl:call-template>
              <xsl:call-template name="getText"><xsl:with-param name="id" select="'of'"/></xsl:call-template>
              <xsl:variable name="middlename">
                <xsl:if test="string-length(/cv/personal/name/middlename)">
                  <xsl:value-of select="concat(/cv/personal/name/middlename, ' ')"/>
                </xsl:if>
              </xsl:variable>
              <xsl:value-of select="concat(/cv/personal/name/firstname, ' ', $middlename, /cv/personal/name/lastname)"/>
            </fo:inline>
            <fo:leader leader-pattern="space"/>
            <fo:inline><fo:basic-link external-destination="http://jtyr.github.io/xmlcv/"><xsl:call-template name="getText"><xsl:with-param name="id" select="'generated_by'"/></xsl:call-template></fo:basic-link></fo:inline>
            <fo:leader leader-pattern="space"/>
            <fo:inline xsl:use-attribute-sets="footer.right">
              <xsl:call-template name="getText"><xsl:with-param name="id" select="'page_number'"/></xsl:call-template>
              <fo:page-number/>
              <xsl:call-template name="getText"><xsl:with-param name="id" select="'page_of'"/></xsl:call-template>
              <fo:page-number-citation ref-id="last-page"/>
            </fo:inline>
          </fo:block>
        </fo:static-content>
      </xsl:if>

      <fo:flow flow-name="xsl-region-body">
        <xsl:if test="string-length(/cv/@show-title) = 0 or (string-length(/cv/@show-title) and /cv/@show-title='yes')">
          <fo:block xsl:use-attribute-sets="cv.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'cv'"/></xsl:call-template></fo:block>
        </xsl:if>

        <xsl:apply-templates/>

        <fo:block id="last-page"/>
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
        <xsl:value-of select="concat(./@photo-height, 'px')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($personal_length * ($font_size + 1), 'pt')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- get middlename -->
  <xsl:variable name="middlename">
    <xsl:if test="string-length(./name/middlename)">
      <xsl:value-of select="concat(./name/middlename, ' ')"/>
    </xsl:if>
  </xsl:variable>

  <fo:table xsl:use-attribute-sets="personal.table">
    <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
      <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:if>

    <fo:table-column xsl:use-attribute-sets="personal.table.column"/>
    <fo:table-column column-width="proportional-column-width(1)"/>
    <fo:table-column column-width="proportional-column-width(1)"/>

    <fo:table-body>
      <!-- name + photo -->
      <fo:table-row>
        <fo:table-cell>
          <fo:block xsl:use-attribute-sets="personal.table.cell.label">
            <fo:block>
              <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_name'"/></xsl:call-template>
            </fo:block>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
          <fo:block><xsl:value-of select="concat(./name/firstname, ' ', $middlename, ./name/lastname)"/></fo:block>
        </fo:table-cell>
        <fo:table-cell number-rows-spanned="{$personal_length}" xsl:use-attribute-sets="personal.photo.cell">
          <fo:block>
            <xsl:if test="string-length($photo_url)">
              <fo:external-graphic src="url('{$photo_url}')" content-height="{$photo_height}" xsl:use-attribute-sets="personal.photo.graphic"/>
            </xsl:if>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>

      <xsl:apply-templates/>

    </fo:table-body>
  </fo:table>
</xsl:template>


<!-- name -->
<xsl:template match="personal/name">
</xsl:template>


<!-- address -->
<xsl:template match="personal/address">
  <fo:table-row>
    <fo:table-cell number-rows-spanned="{count(child::*) - 1}"> <!-- "-1" is for postcode + city -->
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_address'"/></xsl:call-template>
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <xsl:choose>
        <xsl:when test="string-length(./residence)">
          <fo:block><xsl:value-of select="./residence"/></fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block><xsl:value-of select="./street"/></fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </fo:table-cell>
  </fo:table-row>
  <xsl:if test="string-length(./residence)">
    <fo:table-row>
      <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
        <fo:block><xsl:value-of select="./street"/></fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:if>
  <fo:table-row>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block><xsl:value-of select="concat(./postcode, '  ', ./city)"/></fo:block>
    </fo:table-cell>
  </fo:table-row>
  <xsl:if test="string-length(./country)">
    <fo:table-row>
      <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
        <fo:block><xsl:value-of select="./country"/></fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:if>
</xsl:template>


<!-- telephone -->
<xsl:template match="personal/telephone">
  <fo:table-row>
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
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
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block><xsl:value-of select="."/></fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>


<!-- fax -->
<xsl:template match="personal/fax">
  <fo:table-row>
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
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
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block><xsl:value-of select="."/></fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>


<!-- email -->
<xsl:template match="personal/email">
  <fo:table-row>
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_email'"/></xsl:call-template>
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block>
        <fo:basic-link xsl:use-attribute-sets="link" external-destination="{concat('mailto:', .)}">
          <xsl:value-of select="."/>
        </fo:basic-link>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>


<!-- PGP key ID -->
<xsl:template match="personal/pgp-id">
  <fo:table-row>
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_pgpid'"/></xsl:call-template>
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block><xsl:value-of select="."/></fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>


<!-- im -->
<xsl:template match="personal/im">
  <fo:table-row>
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
          <xsl:value-of select="@type"/><xsl:text>:</xsl:text>
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block><xsl:value-of select="."/></fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>


<!-- homepage -->
<xsl:template match="personal/homepage">
  <fo:table-row>
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_homepage'"/></xsl:call-template>
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block>
        <fo:basic-link xsl:use-attribute-sets="link" external-destination="{.}">
          <xsl:value-of select="."/>
        </fo:basic-link>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>


<!-- nationality -->
<xsl:template match="personal/nationality">
  <fo:table-row>
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_nationality'"/></xsl:call-template>
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block><xsl:value-of select="."/></fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>


<!-- birthday -->
<xsl:template match="personal/birthday">
  <fo:table-row>
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_birthday'"/></xsl:call-template>
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block>
        <xsl:call-template name="getDateFormat">
          <xsl:with-param name="format"><xsl:call-template name="getText"><xsl:with-param name="id" select="'full_date_format'"/></xsl:call-template></xsl:with-param>
          <xsl:with-param name="date" select="."/>
        </xsl:call-template>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>


<!-- age -->
<xsl:template match="personal/age">
  <fo:table-row>
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_age'"/></xsl:call-template>
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block>
          <xsl:value-of select="."/>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>


<!-- gender -->
<xsl:template match="personal/gender">
  <fo:table-row>
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_gender'"/></xsl:call-template>
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block>
        <xsl:choose>
          <xsl:when test="@type = 'F' or @type = 'f'">
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_gender_female'"/></xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_gender_male'"/></xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>


<!-- merital status -->
<xsl:template match="personal/status">
  <fo:table-row>
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="personal.table.cell.label">
        <fo:block>
          <xsl:call-template name="getText"><xsl:with-param name="id" select="'personal_merital_status'"/></xsl:call-template>
        </fo:block>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="personal.table.cell.text">
      <fo:block><xsl:value-of select="."/></fo:block>
    </fo:table-cell>
  </fo:table-row>
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
  <fo:block xsl:use-attribute-sets="section">
    <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
      <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length(title)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:value-of select="title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/></fo:block>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></fo:block>
      </xsl:when>
    </xsl:choose>

    <fo:block xsl:use-attribute-sets="text-block.block">
      <xsl:apply-templates select="text[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/>
    </fo:block>
  </fo:block>
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
  <fo:block xsl:use-attribute-sets="section">
    <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
      <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length(title)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:apply-templates select="title"/></fo:block>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'work_experience'"/></xsl:call-template></fo:block>
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

    <xsl:for-each select="./experience[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]">
      <xsl:sort select="substring(concat(substring(./interval/end, 4, 4), substring(./interval/end, 1, 2), '999999'), 1, 6)" order="descending"/>

      <fo:list-block>
        <fo:list-item>
          <fo:list-item-label>
            <fo:block>
              <xsl:call-template name="getInterval">
                <xsl:with-param name="interval" select="./interval"/>
              </xsl:call-template>
            </fo:block>
          </fo:list-item-label>

          <fo:list-item-body xsl:use-attribute-sets="list.item.body">
            <fo:block>
              <fo:block keep-together.within-page="always">
                <xsl:choose>
                  <xsl:when test="string-length(./title/@url)">
                    <fo:block xsl:use-attribute-sets="experience.title"><fo:basic-link xsl:use-attribute-sets="link" external-destination="{./title/@url}"><xsl:value-of select="./title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/></fo:basic-link></fo:block>
                  </xsl:when>
                  <xsl:otherwise>
                    <fo:block xsl:use-attribute-sets="experience.title"><xsl:value-of select="./title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/></fo:block>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="./employer">
                  <fo:block xsl:use-attribute-sets="experience.employer">
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
                    <xsl:if test="string-length(./employer/person)"><xsl:value-of select="./employer/person"/>
                      <xsl:choose>
                        <xsl:when test="string-length(./employer/email)">
                          <xsl:text> (</xsl:text>
                          <fo:basic-link xsl:use-attribute-sets="link" external-destination="mailto:{./employer/email}"><xsl:value-of select="./employer/email"/></fo:basic-link>
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
                  </fo:block>
                </xsl:if>
              </fo:block>

              <xsl:if test="(string-length(./description[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]) and string-length($show_desc) = 0) or (string-length($show_desc) > 0 and $show_desc = 'yes')">
                <fo:block xsl:use-attribute-sets="experience.description hyphenation">
                  <xsl:apply-templates select="./description[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/>
                </fo:block>
              </xsl:if>

              <xsl:if test="./keys and string-length($show_keys) and $show_keys='yes'">
                <fo:block xsl:use-attribute-sets="experience.keys">
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
                </fo:block>
              </xsl:if>

              <fo:block margin-bottom="4pt"/>
              <fo:block/>

            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </xsl:for-each>

  </fo:block>
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
  <fo:block xsl:use-attribute-sets="section">
    <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
      <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length(title)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:value-of select="title"/></fo:block>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'education'"/></xsl:call-template></fo:block>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="./edu">
      <fo:list-block xsl:use-attribute-sets="education.block">
        <fo:list-item>
          <fo:list-item-label>
            <fo:block>
              <xsl:call-template name="getInterval">
                <xsl:with-param name="interval" select="./interval"/>
              </xsl:call-template>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body xsl:use-attribute-sets="list.item.body">
            <fo:block text-align="justify">
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
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </xsl:for-each>

  </fo:block>
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
  <fo:block xsl:use-attribute-sets="section">
    <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
      <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length(title)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:value-of select="title"/></fo:block>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'special_skills'"/></xsl:call-template></fo:block>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:variable name="format">
      <xsl:call-template name="getText"><xsl:with-param name="id" select="'short_date_format'"/></xsl:call-template>
    </xsl:variable>

    <xsl:for-each select="./skill">
      <fo:list-block>
        <fo:list-item>
          <fo:list-item-label>
            <fo:block>
              <xsl:call-template name="getDateFormat">
                <xsl:with-param name="format" select="$format"/>
                <xsl:with-param name="date" select="./date"/>
              </xsl:call-template>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body xsl:use-attribute-sets="list.item.body">
            <fo:block text-align="justify">
              <xsl:value-of select="./title[(contains(concat(' ', normalize-space(@role), ' '), concat(' ', $role, ' ')) or not(@role)) and (contains(concat(' ', normalize-space(@role2), ' '), concat(' ', $role2, ' ')) or not(@role2))]"/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </xsl:for-each>

  </fo:block>
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
  <fo:block xsl:use-attribute-sets="section">
    <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
      <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length(title)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:value-of select="title"/></fo:block>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'language_skills'"/></xsl:call-template></fo:block>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="./language[@mother-tongue and not(@mother-tongue = 'yes')]">
      <fo:block padding-after="1mm"><fo:inline font-style="italic"><xsl:call-template name="getText"><xsl:with-param name="id" select="'table_mother_tongue'"/></xsl:call-template></fo:inline>

        <xsl:for-each select="./language[@mother-tongue = 'yes']">
          <xsl:sort select="./lang"/>

          <xsl:value-of select="./lang"/>

          <xsl:if test="not(position() = last())">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </fo:block>
    </xsl:if>

    <fo:table xsl:use-attribute-sets="table" space-after="0pt">
      <fo:table-column column-width="12.5%" xsl:use-attribute-sets="table.column"/>
      <fo:table-column column-width="3.5%" xsl:use-attribute-sets="table.column"/>
      <fo:table-column column-width="14%" xsl:use-attribute-sets="table.column"/>
      <fo:table-column column-width="3.5%" xsl:use-attribute-sets="table.column"/>
      <fo:table-column column-width="14%" xsl:use-attribute-sets="table.column"/>
      <fo:table-column column-width="3.5%" xsl:use-attribute-sets="table.column"/>
      <fo:table-column column-width="14%" xsl:use-attribute-sets="table.column"/>
      <fo:table-column column-width="3.5%" xsl:use-attribute-sets="table.column"/>
      <fo:table-column column-width="14%" xsl:use-attribute-sets="table.column"/>
      <fo:table-column column-width="3.5%" xsl:use-attribute-sets="table.column"/>
      <fo:table-column column-width="14%" xsl:use-attribute-sets="table.column"/>

      <fo:table-header xsl:use-attribute-sets="table.header">
        <fo:table-row>
          <fo:table-cell xsl:use-attribute-sets="table.header.cell" number-rows-spanned="2">
            <fo:block><xsl:call-template name="getText"><xsl:with-param name="id" select="'table_language'"/></xsl:call-template></fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="table.header.cell" number-columns-spanned="4">
            <fo:block><xsl:call-template name="getText"><xsl:with-param name="id" select="'table_understanding'"/></xsl:call-template></fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="table.header.cell" number-columns-spanned="4">
            <fo:block><xsl:call-template name="getText"><xsl:with-param name="id" select="'table_speaking'"/></xsl:call-template></fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="table.header.cell" number-columns-spanned="2" number-rows-spanned="2">
            <fo:block><xsl:call-template name="getText"><xsl:with-param name="id" select="'table_writing'"/></xsl:call-template></fo:block>
          </fo:table-cell>
        </fo:table-row>

        <fo:table-row>
          <fo:table-cell xsl:use-attribute-sets="table.header.cell table.header.cell.secondrow" number-columns-spanned="2">
            <fo:block><xsl:call-template name="getText"><xsl:with-param name="id" select="'table_listening'"/></xsl:call-template></fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="table.header.cell table.header.cell.secondrow" number-columns-spanned="2">
            <fo:block><xsl:call-template name="getText"><xsl:with-param name="id" select="'table_reading'"/></xsl:call-template></fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="table.header.cell table.header.cell.secondrow" number-columns-spanned="2">
            <fo:block><xsl:call-template name="getText"><xsl:with-param name="id" select="'table_interaction'"/></xsl:call-template></fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="table.header.cell table.header.cell.secondrow" number-columns-spanned="2">
            <fo:block><xsl:call-template name="getText"><xsl:with-param name="id" select="'table_production'"/></xsl:call-template></fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>

      <fo:table-body>
        <xsl:for-each select="./language[not(@mother-tongue = 'yes')]">
          <xsl:sort select="./lang"/>

          <fo:table-row>
            <!-- lang -->
            <fo:table-cell xsl:use-attribute-sets="table.body.cell hyphenation">
              <xsl:if test="position() = last()">
                <xsl:attribute name="border-bottom">none</xsl:attribute>
              </xsl:if>
              <fo:block text-align="left" text-indent="1mm">
                <fo:block><xsl:value-of select="./lang"/></fo:block>
              </fo:block>
            </fo:table-cell>

            <!-- understanding - listening - code -->
            <fo:table-cell xsl:use-attribute-sets="table.body.cell">
              <xsl:if test="position() = last()">
                <xsl:attribute name="border-bottom">none</xsl:attribute>
              </xsl:if>
              <fo:block>
                <xsl:call-template name="getLangLevelCode">
                  <xsl:with-param name="level" select="understanding/listening"/>
                </xsl:call-template>
              </fo:block>
            </fo:table-cell>

            <!-- understanding - listening - label -->
            <fo:table-cell xsl:use-attribute-sets="table.body.cell hyphenation">
              <xsl:if test="position() = last()">
                <xsl:attribute name="border-bottom">none</xsl:attribute>
              </xsl:if>
              <fo:block>
                <xsl:call-template name="getLangLevelLabel">
                  <xsl:with-param name="level" select="understanding/listening"/>
                </xsl:call-template>
              </fo:block>
            </fo:table-cell>

              <!-- understanding - reading - code -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block>
                  <xsl:call-template name="getLangLevelCode">
                    <xsl:with-param name="level" select="understanding/reading"/>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>

              <!-- understanding - reading - label -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell hyphenation">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block>
                  <xsl:call-template name="getLangLevelLabel">
                    <xsl:with-param name="level" select="understanding/reading"/>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>

              <!-- speaking - interaction - code -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block>
                  <xsl:call-template name="getLangLevelCode">
                    <xsl:with-param name="level" select="speaking/interaction"/>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>

              <!-- speaking - interaction - label -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell hyphenation">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block>
                  <xsl:call-template name="getLangLevelLabel">
                    <xsl:with-param name="level" select="speaking/interaction"/>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>

              <!-- speaking - production - code -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block>
                  <xsl:call-template name="getLangLevelCode">
                    <xsl:with-param name="level" select="speaking/production"/>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>

              <!-- speaking - production - label -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell hyphenation">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block>
                  <xsl:call-template name="getLangLevelLabel">
                    <xsl:with-param name="level" select="speaking/production"/>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>

              <!-- writing - code -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block>
                  <xsl:call-template name="getLangLevelCode">
                    <xsl:with-param name="level" select="writing"/>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>

              <!-- writing - label -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell hyphenation">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block>
                  <xsl:call-template name="getLangLevelLabel">
                    <xsl:with-param name="level" select="writing"/>
                  </xsl:call-template>
                </fo:block>
              </fo:table-cell>

            </fo:table-row>
          </xsl:for-each>

        </fo:table-body>
      </fo:table>

      <fo:block xsl:use-attribute-sets="language.table.note">
        <xsl:call-template name="getText"><xsl:with-param name="id" select="'language_table_note'"/></xsl:call-template>
      </fo:block>

  </fo:block>
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
  <fo:block xsl:use-attribute-sets="section">
    <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
      <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length(title)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:value-of select="title"/></fo:block>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'language_skills'"/></xsl:call-template></fo:block>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="./language">
      <xsl:sort select="./lang"/>

      <fo:list-block>
        <fo:list-item>
          <fo:list-item-label>
            <fo:block>
              <xsl:value-of select="./lang"/>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body xsl:use-attribute-sets="list.item.body">
            <fo:block text-align="justify">
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
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </xsl:for-each>

  </fo:block>
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
  <fo:block xsl:use-attribute-sets="section">
    <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
      <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length(title)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:value-of select="title"/></fo:block>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></fo:block>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="string-length(@sort) and @sort = 'no'">
        <xsl:for-each select="./item">
          <fo:list-block>
            <fo:list-item>
              <fo:list-item-label>
                <fo:block>
                  <xsl:value-of select="./label"/>
                </fo:block>
              </fo:list-item-label>
              <fo:list-item-body xsl:use-attribute-sets="list.item.body">
                <fo:block text-align="justify">
                  <xsl:value-of select="$labeled_list_separator"/>
                  <xsl:apply-templates select="./value"/>
                </fo:block>
              </fo:list-item-body>
            </fo:list-item>
          </fo:list-block>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="./item">
          <xsl:sort select="./label"/>

          <fo:list-block>
            <fo:list-item>
              <fo:list-item-label>
                <fo:block>
                  <xsl:value-of select="./label"/>
                </fo:block>
              </fo:list-item-label>
              <fo:list-item-body xsl:use-attribute-sets="list.item.body">
                <fo:block text-align="justify">
                  <xsl:value-of select="$labeled_list_separator"/>
                  <xsl:apply-templates select="./value"/>
                </fo:block>
              </fo:list-item-body>
            </fo:list-item>
          </fo:list-block>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

  </fo:block>
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
  <fo:block xsl:use-attribute-sets="section">
    <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
      <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length(title)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:value-of select="title"/></fo:block>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></fo:block>
      </xsl:when>
    </xsl:choose>

    <fo:block>
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
    </fo:block>

  </fo:block>
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
    <fo:block xsl:use-attribute-sets="section">
      <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
        <xsl:attribute name="break-after">page</xsl:attribute>
      </xsl:if>

      <!-- get middlename -->
      <xsl:variable name="middlename">
        <xsl:if test="string-length(/cv/personal/name/middlename)">
          <xsl:value-of select="concat(/cv/personal/name/middlename, ' ')"/>
        </xsl:if>
      </xsl:variable>

      <fo:table width="100%" table-layout="fixed">
        <fo:table-column column-width="100%"/>
        <fo:table-body>
          <fo:table-row keep-with-next.within-page="always">
            <fo:table-cell>
              <fo:block xsl:use-attribute-sets="signature.padding.top">
                <xsl:call-template name="getDateFormat">
                  <xsl:with-param name="format"><xsl:call-template name="getText"><xsl:with-param name="id" select="'full_date_format'"/></xsl:call-template></xsl:with-param>
                  <xsl:with-param name="date" select="$current_date"/>
                </xsl:call-template>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="/cv/personal/address/city"/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
          <fo:table-row>
            <fo:table-cell xsl:use-attribute-sets="signature.padding.left">
              <fo:block-container xsl:use-attribute-sets="signature.line">
                <fo:block><xsl:value-of select="concat(/cv/personal/name/firstname, ' ', $middlename, /cv/personal/name/lastname)"/></fo:block>
              </fo:block-container>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>

    </fo:block>
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
  <fo:block xsl:use-attribute-sets="section">
    <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
      <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length(title)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:value-of select="title"/></fo:block>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'publications'"/></xsl:call-template></fo:block>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="./publ">
      <fo:block xsl:use-attribute-sets="publications.block">
        <xsl:if test="position() != last()">
          <xsl:attribute name="space-after">2pt</xsl:attribute>
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

        <xsl:text> </xsl:text>

        <fo:inline xsl:use-attribute-sets="publication.title"><xsl:value-of select="./title"/></fo:inline>
        <xsl:text>.</xsl:text>

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
          <fo:basic-link xsl:use-attribute-sets="link" external-destination="{./url}">
            <xsl:value-of select="./url"/>
          </fo:basic-link>
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
      </fo:block>
    </xsl:for-each>

  </fo:block>
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
  <fo:block xsl:use-attribute-sets="section">
    <xsl:if test="string-length(@break-after) and @break-after = 'yes'">
      <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="string-length(title)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:value-of select="title"/></fo:block>
      </xsl:when>
      <xsl:when test="string-length(title/@id)">
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="title/@id"/></xsl:call-template></fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="section.title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'computer_knowledge'"/></xsl:call-template></fo:block>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="./table">

      <fo:table xsl:use-attribute-sets="table">
        <xsl:choose>
          <xsl:when test="@type = 5">
            <fo:table-column column-width="61%" xsl:use-attribute-sets="table.column"/>
          </xsl:when>
          <xsl:otherwise>
            <fo:table-column column-width="25%" xsl:use-attribute-sets="table.column"/>
          </xsl:otherwise>
        </xsl:choose>
        <fo:table-column column-width="15%" xsl:use-attribute-sets="table.column"/>
        <fo:table-column column-width="12%" xsl:use-attribute-sets="table.column"/>
        <xsl:if test="@type != 5">
          <fo:table-column column-width="12%" xsl:use-attribute-sets="table.column"/>
          <fo:table-column column-width="12%" xsl:use-attribute-sets="table.column"/>
          <fo:table-column column-width="12%" xsl:use-attribute-sets="table.column"/>
        </xsl:if>
        <fo:table-column column-width="12%" xsl:use-attribute-sets="table.column"/>

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

        <fo:table-header xsl:use-attribute-sets="table.header">
          <fo:table-row>
            <fo:table-cell xsl:use-attribute-sets="table.header.cell">
              <xsl:if test="@type = 5">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="padding-left">1mm</xsl:attribute>
              </xsl:if>
              <fo:block><xsl:value-of select="./title"/></fo:block>
            </fo:table-cell>

            <fo:table-cell xsl:use-attribute-sets="table.header.cell">
              <fo:block><xsl:call-template name="getText"><xsl:with-param name="id" select="'years_of_use'"/></xsl:call-template></fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="table.header.cell">
              <fo:block><xsl:call-template name="getText"><xsl:with-param name="id" select="'last_use'"/></xsl:call-template></fo:block>
            </fo:table-cell>
            <xsl:if test="@type != 5">
              <fo:table-cell xsl:use-attribute-sets="table.header.cell">
                <fo:block><xsl:value-of select="$fourth_cell"/></fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="table.header.cell">
                <fo:block><xsl:value-of select="$fifth_cell"/></fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="table.header.cell">
                <fo:block><xsl:value-of select="$sixth_cell"/></fo:block>
              </fo:table-cell>
            </xsl:if>
            <fo:table-cell xsl:use-attribute-sets="table.header.cell">
              <fo:block>
                <xsl:call-template name="getText"><xsl:with-param name="id" select="'self_rating'"/></xsl:call-template>
                <xsl:if test="position() = 1">
                  <xsl:call-template name="getText"><xsl:with-param name="id" select="'self_rating_range'"/></xsl:call-template>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>

        <xsl:variable name="type" select="@type"/>

        <fo:table-body>

          <xsl:for-each select="./row">
            <xsl:sort select="./name"/>

            <fo:table-row>
              <!-- name -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block text-align="left" margin-left="1mm">
                  <fo:block><xsl:value-of select="./name"/></fo:block>
                </fo:block>
              </fo:table-cell>

              <!-- years of use -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block>
                  <xsl:variable name="end">
                    <xsl:choose>
                      <xsl:when test="string-length(./interval/end)">
                        <xsl:value-of select="./interval/end"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$current_year"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>

                  <xsl:value-of select="$end - ./interval/start + 1"/>
                </fo:block>
              </fo:table-cell>

              <!-- last use -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block>
                  <xsl:choose>
                    <xsl:when test="string-length(./interval/end)">
                      <xsl:value-of select="./interval/end"/>
                    </xsl:when>
                    <xsl:when test="string-length(./interval/end) = 0 or (string-length(./interval/end) > 0 and ./interval/end = $current_year)">
                      <xsl:call-template name="getText"><xsl:with-param name="id" select="'now'"/></xsl:call-template>
                    </xsl:when>
                  </xsl:choose>
                </fo:block>
              </fo:table-cell>

              <xsl:variable name="cross"><xsl:call-template name="getText"><xsl:with-param name="id" select="'cross'"/></xsl:call-template></xsl:variable>
              <xsl:variable name="dash"><xsl:call-template name="getText"><xsl:with-param name="id" select="'dash'"/></xsl:call-template></xsl:variable>

              <xsl:if test="$type != 5">
                <!-- unix | user | consultant -->
                <fo:table-cell xsl:use-attribute-sets="table.body.cell">
                  <xsl:if test="position() = last()">
                    <xsl:attribute name="border-bottom">none</xsl:attribute>
                  </xsl:if>

                  <fo:block>
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
                        <xsl:attribute name="color"><xsl:value-of select="$ck_not_used_color"/></xsl:attribute>
                        <xsl:value-of select="$dash"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:block>
                </fo:table-cell>

                <!-- windows | admin -->
                <fo:table-cell xsl:use-attribute-sets="table.body.cell">
                  <xsl:if test="position() = last()">
                    <xsl:attribute name="border-bottom">none</xsl:attribute>
                  </xsl:if>
                  <fo:block>
                    <xsl:choose>
                      <xsl:when test="$type = 1 and string-length(./windows)">
                        <xsl:value-of select="$cross"/>
                      </xsl:when>
                      <xsl:when test="($type = 2 or $type = 3) and string-length(./admin)">
                        <xsl:value-of select="$cross"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="color">white</xsl:attribute>
                        <xsl:value-of select="$dash"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:block>
                </fo:table-cell>

                <!-- developer -->
                <fo:table-cell xsl:use-attribute-sets="table.body.cell">
                  <xsl:if test="position() = last()">
                    <xsl:attribute name="border-bottom">none</xsl:attribute>
                  </xsl:if>
                  <fo:block>
                    <xsl:choose>
                      <xsl:when test="($type = 2 or $type = 3) and string-length(./developer)">
                        <xsl:value-of select="$cross"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="color">white</xsl:attribute>
                        <xsl:value-of select="$dash"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:block>
                </fo:table-cell>
              </xsl:if>

              <!-- rating -->
              <fo:table-cell xsl:use-attribute-sets="table.body.cell">
                <xsl:if test="position() = last()">
                  <xsl:attribute name="border-bottom">none</xsl:attribute>
                </xsl:if>
                <fo:block>
                  <xsl:value-of select="./rating"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>

        </fo:table-body>
      </fo:table>

    </xsl:for-each>

  </fo:block>
</xsl:template>


<!-- return date interval -->
<xsl:template name="getInterval">
  <xsl:param name="interval"/>

  <xsl:variable name="width" select="concat(($listitem_indent_width - $listitem_indent_distance), $listitem_indent_unit)"/>
  <xsl:variable name="format">
    <xsl:call-template name="getText"><xsl:with-param name="id" select="'short_date_format'"/></xsl:call-template>
  </xsl:variable>

  <fo:table width="{$width}" table-layout="fixed">
    <fo:table-column column-width="proportional-column-width(1)"/>
    <fo:table-column column-width="{$listitem_indent_separator_width}"/>
    <fo:table-column column-width="proportional-column-width(1)"/>
    <fo:table-body>
      <fo:table-row>
        <fo:table-cell>
          <fo:block wrap-option="no-wrap">
            <xsl:call-template name="getDateFormat">
              <xsl:with-param name="format" select="$format"/>
              <xsl:with-param name="date" select="$interval/start"/>
            </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block text-align="center">
            <xsl:if test="string-length($interval/end) = 0 or $interval/end != $interval/start">
              <xsl:call-template name="getText"><xsl:with-param name="id" select="'interval_dash'"/></xsl:call-template>
            </xsl:if>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block wrap-option="no-wrap">
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
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
    </fo:table-body>
  </fo:table>
</xsl:template>


<!-- font -->
<xsl:template match="font">
  <fo:inline>
    <xsl:if test="string-length(./@color)">
      <xsl:attribute name="color"><xsl:value-of select="./@color"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="string-length(./@size)">
      <xsl:attribute name="font-size"><xsl:value-of select="./@size"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!-- bold text or description -->
<xsl:template match="b">
  <fo:inline xsl:use-attribute-sets="text_description.b">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!-- italic text or description -->
<xsl:template match="i">
  <fo:inline xsl:use-attribute-sets="text_description.i">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!-- underline text or description -->
<xsl:template match="u">
  <fo:inline xsl:use-attribute-sets="text_description.u">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!-- Nth text or description -->
<xsl:template match="nth">
  <fo:inline xsl:use-attribute-sets="text_description.nth">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!-- unordered list -->
<xsl:template match="ul">
  <fo:block provisional-distance-between-starts="5mm" margin-bottom="1mm">
    <fo:list-block>
      <xsl:apply-templates/>
    </fo:list-block>
  </fo:block>
</xsl:template>


<!-- unordered list item -->
<xsl:template match="ul/li">
  <fo:list-item>
    <fo:list-item-label end-indent="label-end()">
      <fo:block margin-left="2mm">&#x2022;</fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block xsl:use-attribute-sets="hyphenation">
        <xsl:apply-templates/>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>


<!-- break - new line -->
<xsl:template match="br">
  <fo:block margin-top="1mm"></fo:block>
</xsl:template>


<!-- copy any text node beneath text or description -->
<xsl:template match="text//text()">
  <xsl:copy-of select="." />
</xsl:template>
<xsl:template match="description//text()">
  <xsl:copy-of select="." />
</xsl:template>


<!-- paragraph -->
<xsl:template match="p">
  <fo:block xsl:use-attribute-sets="hyphenation" margin-bottom="1mm">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>


<!-- link -->
<xsl:template match="a">
  <fo:inline>
    <fo:basic-link xsl:use-attribute-sets="link" external-destination="{@href}">
      <xsl:if test="string-length(./@color)">
        <xsl:attribute name="color"><xsl:value-of select="./@color"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </fo:basic-link>
  </fo:inline>
</xsl:template>


<!-- filter any other text -->
<xsl:template match="text()">
  <xsl:copy-of select="." />
</xsl:template>


</xsl:transform>
