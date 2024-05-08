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
      <xd:p><xd:b>Created on:</xd:b> Mar 23, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> pd</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xd:doc scope="template">
    <xd:desc>
      <xd:p><xd:b>contiguous-ranges</xd:b></xd:p>
      <xd:p>Generate information on contiguously extant Dreissiger by document.</xd:p>
    </xd:desc>
    <xd:param name="repository">Repository name.</xd:param>
    <xd:param name="path_src">Relative path to source directory.</xd:param>
    <xd:param name="path_api">Relative path to target directory.</xd:param>
    <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
    <xd:param name="task">Task name.</xd:param>
  </xd:doc>
  <xsl:template name="contiguous-ranges">
    <xsl:param name="repository" select="()"/>
    <xsl:param name="path_src" as="xs:string"/>
    <xsl:param name="path_api" as="xs:string"/>
    <xsl:param name="verbose" as="xs:boolean"/>
    <xsl:param name="task" as="xs:string"/>
    <xsl:variable name="dreissiger" as="element(Q{https://dsl.unibe.ch}groups)">
      <groups xmlns="https://dsl.unibe.ch">
        <xsl:for-each select="uri-collection($path_src||'data/original/transcription?recurse=yes;select=*.xml')">
          <xsl:variable name="document" as="xs:string" select="doc(.) => base-uri() => replace('.+/(.+)\.xml','$1')"/>
          <xsl:variable name="dreissiger-by-document_sequence" as="item()+" select="doc(.)//*:l/@xml:id ! substring-after(.,$document||'_') 
            ! substring-before(.,'.') 
            => distinct-values()"/>
          <xsl:variable name="dreissiger-by-document_max" as="xs:integer" select="$dreissiger-by-document_sequence ! number() => max() => xs:integer()"/>
          <xsl:variable name="dreissiger-by-document_interspersed" as="item()+" select="(1 to $dreissiger-by-document_max) ! 
            (if (contains-token($dreissiger-by-document_sequence,.=>xs:string())) then .=>xs:string() else 'x')"/>
          <xsl:variable name="dreissiger-by-document_grouped" as="item()+">
            <doc n="{$document}">
              <xsl:for-each-group select="$dreissiger-by-document_interspersed" group-adjacent="matches(.=>tokenize(),'\d+')">
                <xsl:if test="every $token in current-group() satisfies not($token='x')">
                  <g>{current-group()}</g>
                </xsl:if>
              </xsl:for-each-group>
            </doc>
          </xsl:variable>
          <xsl:sequence select="$dreissiger-by-document_grouped"/>            
        </xsl:for-each>
      </groups>
    </xsl:variable>
    
    <xsl:variable name="payload">
      <map>
        <map key="meta">
          <string key="task">{$task}</string>
          <string key="generated-by">{let $regex := '.*('||$repository||'/.+)' return base-uri() => replace($regex,'$1')}</string>
          <string key="generated-on">{current-dateTime()}</string>
          <string key="description">Contiguous ranges of 'Dreissiger' for each edited document; this is the backbone for the overview/linking visualisation a.k.a. 'devil's table'.</string>
        </map>
        <array key="contiguous-ranges">
          <xsl:for-each select="$dreissiger/dsl:doc">
            <xsl:sort select="@n"/>
            <map>
              <string key="label">{@n}</string>
              <!--<array key="values-sequence">
                <xsl:for-each select="dsl:g">
                  <array>
                    <xsl:for-each select="tokenize(.)">
                      <number>{.}</number>
                    </xsl:for-each>  
                  </array>
                </xsl:for-each>
              </array>-->
              <array key="values">
                <xsl:for-each select="dsl:g">
                  <array>
                    <xsl:for-each select="tokenize(.)[position()=1], tokenize(.)[position()=last()]">
                      <number>{.}</number>
                    </xsl:for-each>  
                  </array>
                </xsl:for-each>
              </array>
            </map>
          </xsl:for-each>
        </array>
      </map>
    </xsl:variable>
    
    <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
    
    <xsl:result-document href="{$path_api}/json/contiguous_ranges.json" method="json" indent="true">
      <xsl:message use-when="$verbose">…writing {$path_api}/json/contiguous_ranges.json…</xsl:message>
      <xsl:sequence select="$payload => xml-to-json(map { 'indent' : true() }) => parse-json()"/>
    </xsl:result-document>
    
    <xsl:message>Task `{$task}` done.</xsl:message>
  </xsl:template>
  
</xsl:transform>