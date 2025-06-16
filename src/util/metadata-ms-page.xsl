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
  exclude-result-prefixes="dsl xs xd map array"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Apr 23, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> pd</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <!-- local params -->
  <xd:doc>
    <xd:param name="split-output-pages">Generate multiple (true) or one output file (false).</xd:param>
  </xd:doc>
  <xsl:param name="split-output-pages" static="true" select="true()"/>
  
  <xd:doc scope="template">
    <xd:desc>
      <xd:p><xd:b>metadata-ms-page</xd:b></xd:p>
      <xd:p>Generate information on manuscript pages.</xd:p>
    </xd:desc>
    <xd:param name="repository">Repository name.</xd:param>
    <xd:param name="path_src">Relative path to source directory.</xd:param>
    <xd:param name="path_api">Relative path to target directory.</xd:param>
    <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
    <xd:param name="task">Task name.</xd:param>
  </xd:doc>
  <xsl:template name="metadata-ms-page">
    <xsl:param name="repository" select="()"/>
    <xsl:param name="path_src" as="xs:string"/>
    <xsl:param name="path_api" as="xs:string"/>
    <xsl:param name="task" as="xs:string"/>
    <xsl:param name="verbose" as="xs:boolean"/>
    <xsl:variable name="pages" as="element(Q{https://dsl.unibe.ch}pages)">
      <pages xmlns="https://dsl.unibe.ch">
        <xsl:for-each select="uri-collection($path_src||'data/original/transcription?recurse=yes;select=*.xml')"><!-- [position() lt 5] -->
          <xsl:variable name="document" as="xs:string" select="doc(.) => base-uri() => replace('.+/(.+)\.xml','$1')"/>
          <xsl:variable name="pages-by-document_sequence" as="item()+">
            <doc n="{$document}">
              <xsl:for-each-group select="doc(.)//body//*" group-starting-with="pb">
                <page n="{current-group()[self::pb]/@xml:id}">
                  <xsl:sequence select="current-group()[not(self::pb)]/@xml:id/data()"/>
                </page>
              </xsl:for-each-group>
            </doc>
          </xsl:variable>
          <xsl:sequence select="$pages-by-document_sequence"/>
        </xsl:for-each>
      </pages>
    </xsl:variable>
    
    <xsl:variable name="payload">
<!--      <map>
        <map key="meta">
          <string key="task">{$task}</string>
          <string key="generated-by">{let $regex := '.*('||$repository||'/.+)' return base-uri() => replace($regex,'$1')}</string>
          <string key="generated-on">{current-dateTime()}</string>
          <string key="description">Core metadata for dreissiger.</string>
        </map>-->

<!--          <map key="pages">-->
      <xsl:for-each select="$pages/dsl:doc">
        <map>
          <map key="meta">
            <string key="task">{$task}</string>
            <string key="generated-by">{let $regex := '.*('||$repository||'/.+)' return base-uri() => replace($regex,'$1')}</string>
            <string key="generated-on">{current-dateTime()}</string>
            <string key="description">IIIF info and contained line numbers for manuscript pages.</string>
          </map>
          <array key="{@n}">
            <xsl:for-each select="dsl:page[not(@n='')]">
              <map>
                <string key="id">{@n}</string>
                <string key="iiif">
                  <xsl:choose>
                    <!-- case: fragment -->
                    <xsl:when test="matches(@n,'^fr\d')">
                      <xsl:variable name="fragment" select="(@n => tokenize('\d{3}[rv]'))[1]"/>
                      <xsl:variable name="fragment-nr" select="$fragment => substring-after('fr') => number()" as="xs:double"/>
                      <xsl:text>https://iiif.ub.unibe.ch/image/v3/parzival/{$fragment-nr => format-number('000')}_{substring-after(@n,$fragment)}.jpf/info.json</xsl:text>
                    </xsl:when>
                    <!-- case: not fragment -->
                    <xsl:otherwise>https://iiif.ub.unibe.ch/image/v3/parzival/{@n}.jpf/info.json</xsl:otherwise>
                  </xsl:choose>
                </string>
                <array key="l">
                  <xsl:for-each select="tokenize(.)[contains(.,'_')]">
                    <string>{. => substring-after('_')}</string>
                  </xsl:for-each>
                </array>
              </map>
            </xsl:for-each>
          </array>
        </map>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
    
    <!-- outputting one file per document -->
    <xsl:for-each select="$payload/*:map" use-when="$split-output-pages">
      <xsl:message use-when="$verbose">…writing {$path_api}/json/metadata-ms-page/{*:array/@key}.json…</xsl:message>
      <xsl:result-document href="{$path_api}/json/metadata-ms-page/{*:array/@key}.json" method="json" indent="true">
        <xsl:sequence select=". => xml-to-json(map { 'indent' : true() }) => parse-json()"/>
      </xsl:result-document>
    </xsl:for-each>
    
    <xsl:result-document href="{$path_api}/json/metadata-ms-page.json" method="json" indent="false" use-when="not($split-output-pages)">
      <xsl:variable name="payload">
        <map>
          <array key="pages">
            <xsl:sequence select="$payload"/>
          </array>
        </map>
      </xsl:variable>
      <xsl:message use-when="$verbose">…writing {$path_api}/json/metadata-ms-page.json…</xsl:message>
      <xsl:sequence select="$payload => xml-to-json(map { 'indent' : true() }) => parse-json()"/>
    </xsl:result-document>
    
    <xsl:message>Task `{$task}` done.</xsl:message>
  </xsl:template>
  
</xsl:transform>
