<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/2005/xpath-functions"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs xd"
  expand-text="true"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Feb 25, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> pd</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output indent="true"/>
  
  <xsl:variable name="fragment-uris" select="uri-collection('data_parzival/data/transcription/?select=fr*.xml')"/>
  
  <xsl:template match="/">
    <xsl:variable name="map">
      <array>
        <xsl:for-each select="$fragment-uris ! doc(.)">
          <xsl:sort select="base-uri()"/>
          <map>
            <string key="handle">{base-uri() => replace('.+/(.+)\.xml','$1')}</string>
            <string key="sigil">{}</string>
            <string key="aka">{TEI/teiHeader//msFrag/msIdentifier/idno => string-join(', ')}</string>
            <string key="cod">{}</string>
            <string key="loc">{TEI/teiHeader/fileDesc//repository}</string>
          </map>
        </xsl:for-each>
      </array>
    </xsl:variable>
<!--    <xsl:sequence select="$map"/>-->
    <xsl:sequence select="xml-to-json($map, map { 'indent' : true() })"/>
  </xsl:template>
  
</xsl:stylesheet>