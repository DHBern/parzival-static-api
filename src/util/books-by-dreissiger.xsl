<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs math xd"
  expand-text="true"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Nov 24, 2025</xd:p>
      <xd:p><xd:b>Author:</xd:b> pd</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:variable name="books-by-dreissiger" as="map(xs:integer,xs:string)">
    <xsl:map>
      <xsl:for-each select="1 to 57">
        <xsl:map-entry key="." select="'Buch I'"/>
      </xsl:for-each>
      <xsl:map-entry key="58" select="'Buch I (bis 58.26) / Buch II (ab 58.27)'"/>
      <xsl:for-each select="59 to 115">
        <xsl:map-entry key="." select="'Buch II'"/>
      </xsl:for-each>
      <xsl:map-entry key="116" select="'Buch II (bis 116.4) / Buch III (ab 116.5)'"/>
      <xsl:for-each select="117 to 178">
        <xsl:map-entry key="." select="'Buch III'"/>
      </xsl:for-each>
      <xsl:map-entry key="179" select="'Buch III (bis 179.12) / Buch IV (ab 179.13)'"/>
      <xsl:for-each select="180 to 223">
        <xsl:map-entry key="." select="'Buch IV'"/>
      </xsl:for-each>
      <xsl:for-each select="224 to 279">
        <xsl:map-entry key="." select="'Buch V'"/>
      </xsl:for-each>
      <xsl:for-each select="280 to 337">
        <xsl:map-entry key="." select="'Buch VI'"/>
      </xsl:for-each>
      <xsl:for-each select="398 to 397">
        <xsl:map-entry key="." select="'Buch VII'"/>
      </xsl:for-each>
      <xsl:for-each select="398 to 432">
        <xsl:map-entry key="." select="'Buch VIII'"/>
      </xsl:for-each>
      <xsl:for-each select="433 to 502">
        <xsl:map-entry key="." select="'Buch IX'"/>
      </xsl:for-each>
      <xsl:for-each select="503 to 552">
        <xsl:map-entry key="." select="'Buch X'"/>
      </xsl:for-each>
      <xsl:for-each select="553 to 582">
        <xsl:map-entry key="." select="'Buch XI'"/>
      </xsl:for-each>
      <xsl:for-each select="583 to 626">
        <xsl:map-entry key="." select="'Buch XII'"/>
      </xsl:for-each>
      <xsl:for-each select="627 to 678">
        <xsl:map-entry key="." select="'Buch XIII'"/>
      </xsl:for-each>
      <xsl:for-each select="679 to 733">
        <xsl:map-entry key="." select="'Buch XIV'"/>
      </xsl:for-each>
      <xsl:for-each select="734 to 786">
        <xsl:map-entry key="." select="'Buch XV'"/>
      </xsl:for-each>
      <xsl:for-each select="787 to 827">
        <xsl:map-entry key="." select="'Buch XVI'"/>
      </xsl:for-each>
    </xsl:map>
  </xsl:variable>
  
  <xd:doc scope="template">
    <xd:desc>
      <xd:p><xd:b>books-by-dreissiger</xd:b></xd:p>
      <xd:p>Output a simple list that relates Dreissiger to containing books.</xd:p>
    </xd:desc>
    <xd:param name="repository">Repository name.</xd:param>
    <xd:param name="path_src">Relative path to source directory.</xd:param>
    <xd:param name="path_api">Relative path to target directory.</xd:param>
    <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
    <xd:param name="task">Task name.</xd:param>
  </xd:doc>
  <xsl:template name="books-by-dreissiger">
    <xsl:param name="repository" as="xs:string"/>
    <xsl:param name="path_src" as="xs:string"/>
    <xsl:param name="path_api" as="xs:string"/>
    <xsl:param name="verbose" as="xs:boolean"/>
    <xsl:param name="task" as="xs:string"/>
    <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
    <xsl:message use-when="$verbose">…writing books-by-dreissiger.json…</xsl:message>
    <xsl:result-document href="{$path_api}/json/books-by-dreissiger.json" method="json" encoding="UTF-8" indent="true">
      <xsl:sequence select="$books-by-dreissiger"/>
    </xsl:result-document>
    <xsl:message>Task `{$task}` done.</xsl:message>
  </xsl:template>
  
</xsl:transform>