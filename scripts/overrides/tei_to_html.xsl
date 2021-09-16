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
  <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>


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
  
  <xsl:template match="gap">
    <span>
      <xsl:if test="@extent or @reason">
        <xsl:attribute name="class">
          <xsl:call-template name="add_attributes"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="@extent or @reason">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="@reason"/> 
        <xsl:if test="@extent">
          <xsl:if test="@extent and @reason">
            <xsl:text> - </xsl:text>
          </xsl:if>
          <xsl:value-of select="@extent"/>
        </xsl:if>
        <xsl:text>]</xsl:text>
      </xsl:if>
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

</xsl:stylesheet>
