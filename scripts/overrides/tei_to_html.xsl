<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0"
  exclude-result-prefixes="xsl tei xs">

  <!-- ==================================================================== -->
  <!--                             IMPORTS                                  -->
  <!-- ==================================================================== -->

  <xsl:import href="../.xslt-datura/tei_to_html/tei_to_html.xsl"/>

  <!-- To override, copy this file into your collection's script directory
    and change the above paths to:
    "../../.xslt-datura/tei_to_html/lib/formatting.xsl"
 -->

  <!-- For display in TEI framework, have changed all namespace declarations to http://www.tei-c.org/ns/1.0. If different (e.g. Whitman), will need to change -->
  <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"/>


  <!-- ==================================================================== -->
  <!--                           PARAMETERS                                 -->
  <!-- ==================================================================== -->

  <xsl:param name="collection"/>
  <xsl:param name="data_base"/>
  <xsl:param name="environment"/>
  <xsl:param name="image_large"/>
  <xsl:param name="image_thumb"/>
  <xsl:param name="media_base"/>
  <xsl:param name="site_url"/>

  <!-- ==================================================================== -->
  <!--                            OVERRIDES                                 -->
  <!-- ==================================================================== -->
  
  <xsl:template match="body">
    <!-- Analysis first, then the document -->
    
    <!-- for each doc with ref tyle=analysis (this is serving as the "if statement" -->
    <xsl:for-each select="/TEI/teiHeader/profileDesc/textClass//ref[@type='analysis']">
      <!-- build location for analysis files -->
      <xsl:variable name="analysis_loaction">
        <xsl:text>../../source/analysis/</xsl:text>
        <xsl:value-of select="@target"/>
        <xsl:text>.xml</xsl:text>
      </xsl:variable>
      
      <!-- for-each being used to select the analysis doc -->
      <xsl:for-each select="document($analysis_loaction)//TEI">
        <div class="tei_type_analysis">
          <xsl:apply-templates/>
        </div>
      </xsl:for-each>
      
    </xsl:for-each>

    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- overwriting ref to add special rules for included analysis docs -->
  <xsl:template match="ref">
    <xsl:choose>
      <!-- when analysis doc -->
      <xsl:when test="contains(/TEI/@xml:id,'analysis')">
        <xsl:choose>
          <!-- when footnote or target starts with "#" apply superscript but no link -->
          <xsl:when test="@type='footnote' or starts-with(@target,'#')"><sup><xsl:apply-templates/></sup></xsl:when>
          
          <!-- internal or external, use target as is -->
          <xsl:when test="@type='internal' or @type='external'">
            <a>
              <xsl:attribute name="href" select="@target"/>
              <!-- adding class attribute to style external links if needed -->
              <xsl:attribute name="class">
                <xsl:text>tei_ref_type_</xsl:text>
              <xsl:value-of select="@type"/>
              </xsl:attribute>
              
              <xsl:apply-templates/>
            </a>
          </xsl:when>
          
          <!-- all other instances, add span for later styling -->
          <xsl:otherwise><span class="analysis_ref"><xsl:apply-templates/></span></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- When target starts with #, assume it is an in page link (anchor) -->
      <xsl:when test="starts-with(@target, '#')">
        <xsl:variable name="n" select="@target"/>
        <xsl:text> </xsl:text>
        <a>
          <xsl:attribute name="id">
            <xsl:text>ref</xsl:text>
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <xsl:attribute name="class">
            <xsl:text>inlinenote</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:text>#note</xsl:text>
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <xsl:text>[note </xsl:text>
          <xsl:apply-templates/>
          <xsl:text>]</xsl:text>
        </a>
        <xsl:text> </xsl:text>
      </xsl:when>
      <!-- when marked as link, treat as an external link -->
      <xsl:when test="@type = 'link'">
        <a href="{@target}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <!-- external link -->
      <xsl:when test="starts-with(@target, 'http://') or starts-with(@target, 'https://')">
        <a href="{@target}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <!-- if the above are not true, it is assumed to be an internal to the site link -->
      <xsl:when test="@type = 'sitelink'">
        <a href="../{@target}" class="internal_link">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <!-- the below will generate a footnote / in page link -->
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="concat('#', @target)"/>
          </xsl:attribute>
          <xsl:attribute name="class">
            <xsl:text>internal_link</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
  <xsl:template match="gap">
    <span>
      <xsl:if test="@extent or @reason">
        <xsl:attribute name="class">
          <xsl:call-template name="add_attributes"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
      <!-- <xsl:if test="@extent or @reason">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="@reason"/> 
        <xsl:if test="@extent">
          <xsl:if test="@extent and @reason">
            <xsl:text> - </xsl:text>
          </xsl:if>
          <xsl:value-of select="@extent"/>
        </xsl:if>
        <xsl:text>]</xsl:text>
      </xsl:if> -->
      <xsl:text>[illegible]</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template match="table">
    <xsl:for-each select="head">
      <xsl:apply-templates select="." mode="show"/>
    </xsl:for-each>
    <table>
      <xsl:attribute name="class">
        <xsl:value-of select="@rend"/>
        <xsl:text> tei_table table table-bordered table-condensed</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  
  <xsl:template match="stage">
    <span>
      <xsl:attribute name="class">
        <xsl:call-template name="add_attributes"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template> 
  
  <xsl:template match="pb">
    <!-- grab the figure id from @facs, and if there is a .jpg, chop it off
          note: I previously also looked at xml:id for figure ID, but that's 
          incorrect -->
    <xsl:variable name="figure_id">
      <xsl:variable name="figure_id_full">
        <xsl:value-of select="normalize-space(@facs)"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="ends-with($figure_id_full, '.jpg') or ends-with($figure_id_full, '.jpeg')">
          <xsl:value-of select="substring-before($figure_id_full, '.jp')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$figure_id_full"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:if test="preceding::pb"><span class="hr">&#160;</span></xsl:if>
    <xsl:if test="$figure_id != ''">
      <span>
        <xsl:attribute name="class">
          <xsl:text>pageimage</xsl:text>
        </xsl:attribute>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="url_builder">
              <xsl:with-param name="figure_id_local" select="$figure_id"/>
              <xsl:with-param name="image_size_local" select="$image_large"/>
              <xsl:with-param name="iiif_path_local" select="$collection"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">
            <xsl:text>prettyPhoto[pp_gal]</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:text>&lt;a href=&#34;</xsl:text>
            <xsl:call-template name="url_builder_escaped">
              <xsl:with-param name="figure_id_local" select="$figure_id"/>
              <xsl:with-param name="image_size_local" select="$image_large"/>
              <xsl:with-param name="iiif_path_local" select="$collection"/>
            </xsl:call-template>
            <xsl:text>" target="_blank" &gt;open image in new window&lt;/a&gt;</xsl:text>
          </xsl:attribute>
          
          <img>
            <xsl:attribute name="src">
              <xsl:call-template name="url_builder">
                <xsl:with-param name="figure_id_local" select="$figure_id"/>
                <xsl:with-param name="image_size_local" select="$image_thumb"/>
                <xsl:with-param name="iiif_path_local" select="$collection"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="class">
              <xsl:text>display&#160;</xsl:text>
            </xsl:attribute>
          </img>
        </a>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template match="unclear">
    <span>
      <xsl:attribute name="class">
        <xsl:text>unclear </xsl:text>
        <xsl:value-of select="@reason"/>
        <xsl:text> </xsl:text>
        <xsl:attribute name="class">
          <xsl:call-template name="add_attributes"/>
        </xsl:attribute>
      </xsl:attribute>
      <xsl:apply-templates/>
      <xsl:text>[</xsl:text>
        <xsl:choose>
          <xsl:when test="@extent">
            <xsl:text>unclear, </xsl:text>
            <xsl:value-of select="@extent"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>?</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>

</xsl:stylesheet>
