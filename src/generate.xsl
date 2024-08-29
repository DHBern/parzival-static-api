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
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:param name="path_api" as="xs:string" select="'../dist/api' => dsl:resolve-local-path()"/>
  <xsl:param name="path_src" as="xs:string" select="'' => dsl:resolve-local-path()"/>
  
  <xsl:param name="do" as="xs:string" static="true" select="''"/>
  <xsl:param name="all" as="xs:boolean" static="true" select="false()"/>
  
  <xsl:param name="verbose" as="xs:boolean" static="true" select="false()"/>
  <xsl:param name="repository" as="xs:string" select="'parzival-static-api'"/>
  
  <xsl:include href="util/pass-through-originals.xsl"/>
  <xsl:include href="util/flatten-originals.xsl"/>
  <xsl:include href="util/contiguous-ranges.xsl"/>
  <xsl:include href="util/metadata-ms-page.xsl"/>
  <xsl:include href="util/extract-fragment-metadata.xsl"/>
  
  <xd:doc>
    <xd:desc>Initial template.</xd:desc>
  </xd:doc>
  <xsl:template match="/">

    <xsl:call-template name="pass-through-originals" use-when="$all or $do => contains-token('pass-through-originals')">
      <xsl:with-param name="repository" as="xs:string" select="$repository"/>
      <xsl:with-param name="path_src" as="xs:string" select="$path_src"/>
      <xsl:with-param name="path_api" as="xs:string" select="$path_api"/>
      <xsl:with-param name="verbose" as="xs:boolean" select="$verbose"/>
      <xsl:with-param name="task" as="xs:string" select="'pass-through-originals'"/>
    </xsl:call-template>
    
    <xsl:call-template name="flatten-originals" use-when="$all or $do => contains-token('flatten-originals')">
      <xsl:with-param name="repository" as="xs:string" select="$repository"/>
      <xsl:with-param name="path_src" as="xs:string" select="$path_src"/>
      <xsl:with-param name="path_api" as="xs:string" select="$path_api"/>
      <xsl:with-param name="verbose" as="xs:boolean" select="$verbose"/>
      <xsl:with-param name="task" as="xs:string" select="'flatten-originals'"/>
    </xsl:call-template>
    
    <xsl:call-template name="contiguous-ranges" use-when="$all or $do => contains-token('contiguous-ranges')">
      <xsl:with-param name="repository" as="xs:string" select="$repository"/>
      <xsl:with-param name="path_src" as="xs:string" select="$path_src"/>
      <xsl:with-param name="path_api" as="xs:string" select="$path_api"/>
      <xsl:with-param name="verbose" as="xs:boolean" select="$verbose"/>
      <xsl:with-param name="task" as="xs:string" select="'contiguous-ranges'"/>
    </xsl:call-template>
    
    <xsl:call-template name="metadata-nomenclature" use-when="$all or $do => contains-token('metadata-nomenclature')">
      <xsl:with-param name="repository" as="xs:string" select="$repository"/>
      <xsl:with-param name="path_src" as="xs:string" select="$path_src"/>
      <xsl:with-param name="path_api" as="xs:string" select="$path_api"/>
      <xsl:with-param name="verbose" as="xs:boolean" select="$verbose"/>
      <xsl:with-param name="task" as="xs:string" select="'metadata-nomenclature'"/>
    </xsl:call-template>

    <xsl:call-template name="metadata-ms-page" use-when="$all or $do => contains-token('metadata-ms-page')">
      <xsl:with-param name="repository" as="xs:string" select="$repository"/>
      <xsl:with-param name="path_src" as="xs:string" select="$path_src"/>
      <xsl:with-param name="path_api" as="xs:string" select="$path_api"/>
      <xsl:with-param name="verbose" as="xs:boolean" select="$verbose"/>
      <xsl:with-param name="task" as="xs:string" select="'metadata-ms-page'"/>
    </xsl:call-template>
    
    <xsl:if test="$do='' and not($all)">
      <xsl:message>No action defined. Use parameter $do (tasks as tokens) or $all (boolean).</xsl:message>
    </xsl:if>
    
  </xsl:template>
  
  <xd:doc>
    <xd:desc>Resolve paths relative to the location of this file.</xd:desc>
    <xd:param name="input">Path segment.</xd:param>
  </xd:doc>
  <xsl:function name="dsl:resolve-local-path">
    <xsl:param name="input" as="xs:string"/>
    <xsl:sequence select="base-uri(document('')) => replace('(.+/)(.*)','$1') || $input"/>
  </xsl:function>

  
</xsl:transform>
