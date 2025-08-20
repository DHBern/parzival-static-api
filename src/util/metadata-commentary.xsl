<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns="http://www.w3.org/2005/xpath-functions"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array"
  xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization"
  exclude-result-prefixes="xs xd"
  expand-text="true"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Aug 6, 2025</xd:p>
      <xd:p><xd:b>Author:</xd:b> pd</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:variable name="quote" as="xs:string">"</xsl:variable>
  <xsl:variable name="squote" as="xs:string">'</xsl:variable>
  
  <xsl:template name="metadata-commentary">
    <xsl:param name="repository" select="()"/>
    <xsl:param name="path_src" as="xs:string"/>
    <xsl:param name="path_api" as="xs:string"/>
    <xsl:param name="task" as="xs:string"/>
    <xsl:param name="verbose" as="xs:boolean"/>
    <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
    
    <xsl:result-document href="{$path_api}/json/commentary.json" method="json" indent="true" use-character-maps="unescape-solidus">
      
      <xsl:variable name="csv-head" as="map(*)">
        <xsl:map>
          <xsl:for-each select="unparsed-text-lines('../data/fassungs_kommentar.csv')[1] ! tokenize(.,',')">
              <xsl:map-entry key="position()">{. 
                => replace('^'||$quote||'(.*)'||$quote||'$','$1')         (: remove leading and trailing quotes :)
                }</xsl:map-entry>
            </xsl:for-each>
        </xsl:map>
      </xsl:variable>
      
      <xsl:variable name="payload">
        <map>
          <map key="meta">
            <string key="task">{$task}</string>
            <string key="generated-by">{let $regex := '.*('||$repository||'/.+)' return base-uri() => replace($regex,'$1')}</string>
            <string key="generated-on">{current-dateTime()}</string>
            <string key="description">Fassungskommentar.</string>
          </map>
          <array key="commentary">
              <xsl:for-each select="unparsed-text-lines('../data/fassungs_kommentar.csv')[position() gt 1]">
                <map>
                  <!-- preprocess: make segmentation explicit -->
                  <xsl:variable name="regex1">,{$quote}{$quote},</xsl:variable><!-- ,"", -->
                  <xsl:variable name="regex2">([^{$quote}]){$quote},{$quote}</xsl:variable><!-- [^"]"," -->
                  <xsl:variable name="preprocess" select=". => replace($regex1,','||$quote||$quote||'▓') => replace($regex2,'$1'||$quote||'▓'||$quote)"/>
                  <xsl:for-each select="tokenize($preprocess,'▓')">
                    <string key="{$csv-head?(position())}">{. 
                      => replace($quote||$quote,$quote)                   (: normalise escaped double quotes:)
                      => replace('^'||$quote||'(.*)'||$quote||'$','$1')   (: remove leading and trailing quotes :)
                      => replace($quote,$squote)                          (: use single quotes :)
                      => replace('^'||$squote||'$','')                    (: missing values :)
                      }</string>
                  </xsl:for-each>
                </map>
              </xsl:for-each>
          </array>
        </map>
      </xsl:variable>
      <xsl:message use-when="$verbose">…writing {$path_api}/json/commentary.json…</xsl:message>
      <xsl:sequence select="$payload => xml-to-json(map { 'indent' : true() }) => parse-json()"/>
    </xsl:result-document>
    
    <xsl:message>Task `{$task}` done.</xsl:message>
    
  </xsl:template>
  
</xsl:transform>