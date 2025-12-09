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
  exclude-result-prefixes="#all"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> May 8, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> pd</xd:p>
      <xd:p>Copies amended original TEI files (as received from editors) to dist.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <!-- uses mode "pass-through" from pass-through-originals.xsl -->
  <xsl:mode name="refine-originals" on-no-match="shallow-copy"/>
  <xsl:mode name="substitute-quotation-marks" on-no-match="shallow-copy"/>
  <xsl:mode name="lowercase-xml-ids" on-no-match="shallow-copy"/>
  <xsl:mode name="tmp-fix-for-ybild" on-no-match="shallow-copy"/>

  <xd:doc scope="template">
    <xd:desc>
      <xd:p><xd:b>flatten-originals</xd:b></xd:p>
      <xd:p>Copies amended original TEI files (as received from editors) to dist.</xd:p>
    </xd:desc>
    <xd:param name="repository">Repository name.</xd:param>
    <xd:param name="path_src">Relative path to source directory.</xd:param>
    <xd:param name="path_api">Relative path to target directory.</xd:param>
    <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
    <xd:param name="task">Task name.</xd:param>
  </xd:doc>
  <xsl:template name="flatten-originals">
    <xsl:param name="repository" as="xs:string"/>
    <xsl:param name="path_src" as="xs:string"/>
    <xsl:param name="path_api" as="xs:string"/>
    <xsl:param name="verbose" as="xs:boolean"/>
    <xsl:param name="task" as="xs:string"/>
    <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
    <xsl:for-each select="uri-collection($path_src||'data/original?recurse=yes;select=*.xml')">
      <xsl:variable name="idno" as="xs:string" select=".  => substring-after('original/transcription/')"/>
      <xsl:message use-when="$verbose">…writing {$path_api}/tei/flattened/{. => replace('.+/(.*)','$1')}…</xsl:message>
      
      <xsl:variable name="pass1">
        <xsl:choose>
          <!-- special treatment for syn69, syn70, syn71; rationale given below -->
          <xsl:when test="matches(.,'syn69\.xml|syn70\.xml|syn71\.xml')">
            <xsl:apply-templates select="doc(.)/node()" mode="refine-originals"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="doc(.)/node()" mode="pass-through">
              <xsl:with-param name="idno" select="$idno"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="pass2">
        <xsl:choose>
          <xsl:when test="matches(.,'syn\d*\.xml')">
            <xsl:apply-templates select="$pass1" mode="substitute-quotation-marks"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="$pass1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="pass3">
          <xsl:apply-templates select="$pass2" mode="lowercase-xml-ids"/>
      </xsl:variable>
      
      <xsl:variable name="pass99">
        <xsl:apply-templates select="$pass3" mode="tmp-fix-for-ybild"/>
      </xsl:variable>
      
      <xsl:result-document href="{$path_api}/tei/flattened/{. => replace('.+/(.*)','$1')}" method="xml" encoding="UTF-8" indent="false">
        <xsl:sequence select="$pass99"/>
      </xsl:result-document>
    </xsl:for-each>
    <xsl:message>Task `{$task}` done.</xsl:message>
  </xsl:template>
  
  <!-- In Tustep, a workaround was applied to handle Lachmann's divergent numbering in Dreissiger 69-71.
       This resulted in makeshift verse numbers in the output files, that need to be substituted. -->
  <xsl:template match="@n" mode="refine-originals">
    <xsl:attribute name="n" select="dsl:permute-verse-numbers(.)"/>
  </xsl:template>
  
  <xsl:template match="@loc" mode="refine-originals">
    <xsl:attribute name="loc" select="dsl:permute-verse-numbers(.)"/>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>Lachmann's numbering deviated for verses 69.29 to 71.6 from trandition. 
      This necessitated a workaround in Tustep that resulted in makeshift numbers such as 69.107.
      This function substitutes them with appropriate verse numbers.</xd:desc>
  </xd:doc>
  <xsl:function name="dsl:permute-verse-numbers">
    <xsl:param name="value" as="xs:string"/>
    <xsl:sequence select="$value =>
    replace('\s69\.107',' 70.7') =>
    replace('\s69\.108',' 70.8') =>
    replace('\s70\.101',' 71.1') =>
    replace('\s70\.102',' 71.2') =>
    replace('\s70\.103',' 71.3') =>
    replace('\s70\.104',' 71.4') =>
    replace('\s70\.105',' 71.5') =>
    replace('\s70\.106',' 71.6') =>
    replace('\s70\.929',' 69.29') =>
    replace('\s70\.930',' 69.30') =>
    replace('\s71\.901',' 70.1') =>
    replace('\s71\.902',' 70.2') =>
    replace('\s71\.903',' 70.3') =>
    replace('\s71\.904',' 70.4') =>
    replace('\s71\.905',' 70.5') =>
    replace('\s71\.906',' 70.6')
    "/>
  </xsl:function>
  
  <xsl:template match="text()[matches(.,$quot||'|'||$apos)]" mode="substitute-quotation-marks">
    <xsl:sequence select=". => dsl:substitute-quotes()"/>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>For Fassungen (syn) quotation marks are not differentiated in the Tustep output. 
      Depending on the context, opening and closing Guillements are substituted.</xd:desc>
  </xd:doc>
  <xsl:function name="dsl:substitute-quotes">
    <xsl:param name="value" as="xs:string"/>
    <xsl:sequence select="$value
      (: double quotes mid-string:)
      => replace($quot||'(\p{P})','«$1') 
      => replace($quot||'(\s+)','«$1') 
      => replace('(\s+)'||$quot,'$1»') 
      
      (: double quotes at start/end of string:)
      => replace('^'||$quot,'$1»')
      => replace($quot||'$','«$1')
      
      (: apostrophes mid-string:)
      => replace($apos||'(\p{P})','‹$1') 
      => replace($apos||'(\s+)','‹$1') 
      => replace('(\s+)'||$apos,'$1›') 
      
      (: apostrophes at start/end of string:)
      => replace('^'||$apos,'$1›')
      => replace($apos||'$','‹$1')
      "/>
  </xsl:function>
  
  <xd:doc>
    <xd:desc>Tustep exports may contain upper-case file and line IDs (this first occurred 2025-11-10). 
      They are normalised to lower-case to keep mappings working.</xd:desc>
  </xd:doc>
  <xsl:template match="@xml:id[parent::*[local-name()=('l','pb','cb')]]" mode="lowercase-xml-ids">
    <xsl:attribute name="xml:id" select="if (matches(.,'-\d{2}-I+$')) then . ! substring-before(.,'-I') => lower-case() || replace(.,'.+(-I+$)','$1') else . => lower-case()"/>
  </xsl:template>
  
  <xsl:template match="note/@target | metamark/@target" mode="lowercase-xml-ids">
    <xsl:attribute name="target" select="((tokenize(.,'\s') => head() => lower-case()) || ' ' || (tokenize(.,'\s') => tail() => string-join(' '))) => normalize-space()"/>
  </xsl:template>
  
  <!-- pass 99; remove when data input fixed -->
  <xsl:template match="text()[matches(.,'^\[ybild\]$')]" mode="tmp-fix-for-ybild">
    <milestone xmlns="http://www.tei-c.org/ns/1.0" unit="Nicht_ausgeführtes_Bild_mit_Nachtrag"/>
  </xsl:template>

</xsl:transform>
