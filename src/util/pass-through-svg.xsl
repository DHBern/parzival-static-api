<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns="http://www.w3.org/2005/xpath-functions"
  xmlns:dsl="https://dsl.unibe.ch"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array"
  xpath-default-namespace="http://www.w3.org/2000/svg"
  expand-text="true"
  exclude-result-prefixes="array dsl map xs xd"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Jun 04, 2025</xd:p>
      <xd:p><xd:b>Author:</xd:b> pd</xd:p>
      <xd:p>Copies all original SVG files (as received from editors) to dist, while applying some corrections.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:mode name="pass-through" on-no-match="shallow-copy"/>
  
  <xd:doc scope="template">
    <xd:desc>
      <xd:p><xd:b>pass-through-svg</xd:b></xd:p>
      <xd:p>Copies all original SVG files (as received from editors) to dist, while applying some corrections.</xd:p>
    </xd:desc>
    <xd:param name="repository">Repository name.</xd:param>
    <xd:param name="path_src">Relative path to source directory.</xd:param>
    <xd:param name="path_api">Relative path to target directory.</xd:param>
    <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
    <xd:param name="task">Task name.</xd:param>
  </xd:doc>
  <xsl:template name="pass-through-svg">
    <xsl:param name="repository" as="xs:string"/>
    <xsl:param name="path_src" as="xs:string"/>
    <xsl:param name="path_api" as="xs:string"/>
    <xsl:param name="verbose" as="xs:boolean"/>
    <xsl:param name="task" as="xs:string"/>
    <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
    <xsl:for-each select="uri-collection($path_src||'data/svg?recurse=yes;select=*.svg')">
      <xsl:message use-when="$verbose">…writing {$path_api}/svg/{(. => tokenize('/'))[last()] => lower-case()}…</xsl:message>
      <xsl:result-document href="{$path_api}/svg/{(. => tokenize('/'))[last()] => lower-case()}" method="xml" encoding="UTF-8" indent="true">
        <xsl:apply-templates select="doc(.)/node()" mode="pass-through"/>
      </xsl:result-document>
    </xsl:for-each>
    <xsl:message>Task `{$task}` done.</xsl:message>
  </xsl:template>
  
  <!-- deactivate rect elements (editing artifacts) -->
  <!--<xsl:template match="rect" mode="pass-through">
    <xsl:text disable-output-escaping="yes">&lt;!-\-</xsl:text>
    <xsl:copy-of select="."/>
    <xsl:text disable-output-escaping="yes">-\-&gt;</xsl:text>
  </xsl:template>-->
  
</xsl:transform>
