<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns="http://www.w3.org/2005/xpath-functions"
  xmlns:dsl="https://dsl.unibe.ch"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array"
  xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  expand-text="true"
  exclude-result-prefixes="#all"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> May 28, 2025</xd:p>
      <xd:p><xd:b>Author:</xd:b> pd</xd:p>
      <xd:p>Apparatus information (distribution, structural, readings)</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:mode name="distribution" on-no-match="shallow-skip"/>
  
  <xsl:variable name="serialization-parameters">
    <output:serialization-parameters>
      <output:method value="xml"/>
    </output:serialization-parameters>
  </xsl:variable>
  
  <xsl:character-map name="unescape-solidus">
    <xsl:output-character character="/" string="/"/>
  </xsl:character-map>
  
  <xsl:variable name="base-uri" select="base-uri()"/>
  
  <!-- local params -->
  <xd:doc>
    <xd:param name="split-output-syn">Generate multiple (true) or one output file (false).</xd:param>
  </xd:doc>
  <xsl:param name="split-output-syn" static="true" select="true()"/>
  
  <xd:doc scope="template">
    <xd:desc>
      <xd:p><xd:b>metadata-syn-apps</xd:b></xd:p>
      <xd:p>Generate information for apparatus entries (synopsis).</xd:p>
    </xd:desc>
    <xd:param name="repository">Repository name.</xd:param>
    <xd:param name="path_src">Relative path to source directory.</xd:param>
    <xd:param name="path_api">Relative path to target directory.</xd:param>
    <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
    <xd:param name="task">Task name.</xd:param>
  </xd:doc>
  <xsl:template name="metadata-syn-apps">
    <xsl:param name="repository" select="()"/>
    <xsl:param name="path_src" as="xs:string"/>
    <xsl:param name="path_api" as="xs:string"/>
    <xsl:param name="task" as="xs:string"/>
    <xsl:param name="verbose" as="xs:boolean"/>
        
    <xsl:variable name="syn-views" as="element(Q{https://dsl.unibe.ch}syn-views)">
      <syn-views xmlns="https://dsl.unibe.ch">
        <xsl:for-each select="uri-collection($path_src||'data/original?recurse=no;select=syn*.xml')"><!-- [position() lt 5] -->
          <xsl:variable name="document" as="xs:string" select="doc(.) => base-uri() => replace('.+/(.+)\.xml','$1')"/>
          <map key="{$document}" xmlns="http://www.w3.org/2005/xpath-functions">
            <xsl:call-template name="metadata" use-when="$split-output-syn">
              <xsl:with-param name="task" select="$task"/>
            </xsl:call-template>
            <array key="versions" xmlns="http://www.w3.org/2005/xpath-functions">
              <xsl:for-each select="doc(.)//div[@type='Dreissiger']">
                <map>
                  <string key="handle">{./div[@type='Textteil']/head}</string>
                  <string key="distribution">
                    <xsl:variable name="content">
                      <xsl:apply-templates select="./div/listApp[@type='Verteilung']/app/rdg" mode="distribution"/>
                    </xsl:variable>
                    <xsl:sequence select="serialize($content,$serialization-parameters/output:serialization-parameters) => normalize-space()"/>
                  </string>
                  <array key="structure">
                    <xsl:apply-templates select="./div/listApp[@type='Gliederung']/app" mode="structure"/>
                  </array>
                  <array key="reading">
                    <xsl:apply-templates select="./div/listApp[@type='Lesarten']/app" mode="reading"/>
                  </array>
                </map>
              </xsl:for-each>
            </array>
          </map>
        </xsl:for-each>
      </syn-views>
    </xsl:variable>
    
    <xsl:variable name="payload">
      <xsl:call-template name="metadata" use-when="not($split-output-syn)">
        <xsl:with-param name="task" select="$task"/>
      </xsl:call-template>
      <xsl:for-each select="$syn-views/*">
        <xsl:sequence select="."/>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
    
    <!-- outputting one file per document -->
    <xsl:for-each select="$payload/*:map" use-when="$split-output-syn">
      <xsl:message use-when="$verbose">…writing {$path_api}/json/syn/{@key}.json…</xsl:message>
        <xsl:result-document href="{$path_api}/json/syn/{@key}.json" method="json" indent="true" exclude-result-prefixes="#all" use-character-maps="unescape-solidus">
<!--        <xsl:sequence select="."/>-->
          <xsl:sequence select=". => xml-to-json(map { 'indent' : true() }) => parse-json()"/>
      </xsl:result-document>
    </xsl:for-each>
    
    <xsl:result-document href="{$path_api}/json/syn-views.json" method="json" indent="true" use-character-maps="unescape-solidus" use-when="not($split-output-syn)">
      <xsl:variable name="payload">
        <map>
            <xsl:sequence select="$payload"/>
        </map>
      </xsl:variable>
      <xsl:message use-when="$verbose">…writing {$path_api}/json/syn-views.json…</xsl:message>
      <xsl:sequence select="$payload => xml-to-json(map { 'indent' : true() }) => parse-json()"/>
    </xsl:result-document>
    
    <xsl:message>Task `{$task}` done.</xsl:message>
  </xsl:template>
  
  <xsl:template name="metadata">
    <xsl:param name="task" as="xs:string"/>
    <map key="meta">
      <string key="task">{$task}</string>
      <string key="generated-by">{let $regex := '.*('||$repository||'/.+)' return $base-uri => replace($regex,'$1')}</string>
      <string key="generated-on">{current-dateTime()}</string>
      <string key="description">Apparatus information (distribution, structural, readings).</string>
    </map>
  </xsl:template>
  
  <xsl:template match="rdg" mode="distribution">
    <!--<div>-->
    <ul xmlns="">
      <xsl:for-each-group select="node()" group-starting-with="wit">
        <xsl:if test="matches(current-group() => string-join(),'\S')">
          <li xmlns="">
            <xsl:apply-templates select="current-group()" mode="distribution"/>
          </li>
        </xsl:if>
      </xsl:for-each-group>
    </ul>
    <!--</div>-->
  </xsl:template>
  
  <!--<xsl:template match="wit" mode="distribution">
    <xsl:apply-templates mode="distribution"/>
  </xsl:template>-->
  
  <xsl:template match="note" mode="distribution">
    <span xmlns=""><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="text()[matches(.,'\S')]" mode="distribution">
    <xsl:variable name="v-apos">V'</xsl:variable>
    <xsl:sequence select=". => replace('(n|m|o)k','$1') => replace('VV',$v-apos) => normalize-space()"/>
  </xsl:template>
  
  <xsl:template match="text()[matches(.,'^\s*$')]" mode="distribution">
    <xsl:if test="following-sibling::*[1][self::note]">
      <xsl:sequence select="."/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="app[node()]" mode="structure">
    <xsl:variable name="content">
      <xsl:apply-templates mode="structure"/>
    </xsl:variable>
    <map>
      <string key="{@loc => tokenize('\.') => tail()}">
        <xsl:sequence select="serialize($content,$serialization-parameters/output:serialization-parameters) 
          => normalize-space() => replace('class='||$quot||'(.+?)'||$quot,'class='||$apos||'$1'||$apos)"/>
      </string>
    </map>
  </xsl:template>
  
  <xsl:template match="wit" mode="structure">
    <a xmlns="">
      <xsl:apply-templates mode="structure"/>
    </a>
  </xsl:template>
  
  <xsl:template match="note" mode="structure">
    <span class="{local-name()}" xmlns="">{.}</span>
  </xsl:template>
  
  <xsl:template match="text()[matches(.,'\S')]" mode="structure">
    <xsl:sequence select=". => replace('(n|m|o)k','$1') => replace('VV','V'||$apos) => normalize-space()"/>
  </xsl:template>

  <xsl:template match="app[node()]" mode="reading">
    <xsl:variable name="content">
      <xsl:apply-templates mode="reading"/>
    </xsl:variable>
    <map>
      <string key="{@loc => tokenize('\.') => tail()}">
        <xsl:sequence select="serialize($content,$serialization-parameters/output:serialization-parameters) 
          => normalize-space() => replace('class='||$quot||'(.+?)'||$quot,'class='||$apos||'$1'||$apos)"/>
      </string>
    </map>
  </xsl:template>
  
  <xsl:template match="lem" mode="reading">
    <span class="{local-name()}" xmlns="">{.}</span><xsl:text> ] </xsl:text>
  </xsl:template>
  
  <xsl:template match="rdg" mode="reading">
    <span class="{local-name()}" xmlns="">
      <xsl:apply-templates mode="reading"/>
    </span>
  </xsl:template>
  
  <xsl:template match="del" mode="reading">
    <xsl:text>[</xsl:text>
      <xsl:apply-templates mode="reading"/>
    <xsl:text>]</xsl:text>
    <xsl:if test="following-sibling::*[1][self::add]">
      <xsl:text>: </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="wit" mode="reading">
    <a xmlns="">{. => replace('(n|m|o)k','$1') => replace('VV','V'||$apos) => normalize-space()}</a>
  </xsl:template>

  <xsl:template match="note" mode="reading">
    <span class="{local-name()}" xmlns="">{.}</span>
  </xsl:template>  

</xsl:transform>
