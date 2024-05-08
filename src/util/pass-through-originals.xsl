<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns="http://www.w3.org/2005/xpath-functions"
  xmlns:dsl="https://dsl.unibe.ch"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  expand-text="true"
  exclude-result-prefixes="xs xd"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Mar 23, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> pd</xd:p>
      <xd:p>Copies all original TEI files (as received from editors) to dist.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xd:doc scope="template">
    <xd:desc>
      <xd:p><xd:b>pass-through-originals</xd:b></xd:p>
      <xd:p>Copies all original TEI files (as received from editors) to dist.</xd:p>
    </xd:desc>
    <xd:param name="repository">Repository name.</xd:param>
    <xd:param name="path_src">Relative path to source directory.</xd:param>
    <xd:param name="path_api">Relative path to target directory.</xd:param>
    <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
    <xd:param name="task">Task name.</xd:param>
  </xd:doc>
  <xsl:template name="pass-through-originals">
    <xsl:param name="repository" as="xs:string"/>
    <xsl:param name="path_src" as="xs:string"/>
    <xsl:param name="path_api" as="xs:string"/>
    <xsl:param name="verbose" as="xs:boolean"/>
    <xsl:param name="task" as="xs:string"/>
    <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
    <xsl:for-each select="uri-collection($path_src||'data/original?recurse=yes;select=*.xml')">
      <xsl:message use-when="$verbose">…writing {$path_api}/tei/original/{. => substring-after('original/')}…</xsl:message>
      <xsl:result-document href="{$path_api}/tei/original/{. => substring-after('original/')}">
        <xsl:sequence select="doc(.)"/>
      </xsl:result-document>
    </xsl:for-each>
    <xsl:message>Task `{$task}` done.</xsl:message>
  </xsl:template>
  
</xsl:transform>