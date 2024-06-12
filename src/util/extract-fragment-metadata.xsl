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
      <xd:p><xd:b>Created on:</xd:b> Feb 25, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> pd</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output indent="true"/>
  
  <xsl:variable name="hyparchetypes" as="text()" expand-text="false">
    <![CDATA[
    [
      {
      "sigil": "*D",
      "handle": "*D",
      "aka": "Wolframs Parzival",
      "witnesses": ["d"]
      },
      {
      "sigil": "*m",
      "handle": "*m",
      "aka": "Gruppe der Lauberhandschriften",
      "witnesses": ["mk", "n", "o"]
      },
      {
      "sigil": "*G",
      "handle": "*G",
      "aka": "Cgm 19",
      "witnesses": ["g", "i", "l", "m", "o", "q", "r", "z"]
      },
      {
      "sigil": "*T (U)",
      "handle": "*T",
      "aka": "Frühe Textfassung",
      "witnesses": ["t", "u", "v", "vv", "w"]
      }
    ]
    ]]>
  </xsl:variable>
  
  <xsl:variable name="fragment-sigla" as="map(*)" select="
    map{
    'fr1' : 'Fr. 1 (a)',
    'fr2' : 'Fr. 2 (b)',
    'fr3' : 'Fr. 3 (c)',
    'fr4' : 'Fr. 4 (ç)',
    'fr5' : 'Fr. 5 (d)',
    'fr6' : 'Fr. 6 (e)',
    'fr7' : 'Fr. 7 (f)',
    'fr8' : 'Fr. 8 (g)',
    'fr9' : 'Fr. 9 (h)',
    'fr10' : 'Fr. 10 (i)',
    'fr11' : 'Fr. 11 (k)',
    'fr12' : 'Fr. 12 (l)',
    'fr13' : 'Fr. 13 (ll)',
    'fr14' : 'Fr. 14 (r)',
    'fr15' : 'Fr. 15 (s)',
    'fr16' : 'Fr. 16 (t)',
    'fr17' : 'Fr. 17 (E)',
    'fr18' : 'Fr. 18 (Gᵛ, F und Gˡ)',
    'fr19' : 'Fr. 19 (Gᵃ)',
    'fr20' : 'Fr. 20 (Gᵇ)',
    'fr21' : 'Fr. 21 (Gᶜ)',
    'fr22' : 'Fr. 22 (Gᵈ)',
    'fr23' : 'Fr. 23 (Gᵉ)',
    'fr24' : 'Fr. 24 (Gᶠ)',
    'fr25' : 'Fr. 25 (Gᵍ)',
    'fr26' : 'Fr. 26 (Gʰ)',
    'fr27' : 'Fr. 27 (Gⁱ)',
    'fr28' : 'Fr. 28 (Gʲ)',
    'fr29' : 'Fr. 29 (Gᵒ)',
    'fr30' : 'Fr. 30 (Gᵖ)',
    'fr31' : 'Fr. 31 (G&#x107A5;)',
    'fr32' : 'Fr. 32 (Gʳ)',
    'fr33' : 'Fr. 33 (Gˢ)',
    'fr34' : 'Fr. 34 (Gᵗ)',
    'fr35' : 'Fr. 35 (Gᵘ)',
    'fr36' : 'Fr. 36 (Gʷ)',
    'fr37' : 'Fr. 37 (Gˣ)',
    'fr38' : 'Fr. 38 (Gʸ)',
    'fr39' : 'Fr. 39 (Gz und Gπ)',
    'fr40' : 'Fr. 40 (Gα)',
    'fr41' : 'Fr. 41 (Gᵝ)',
    'fr42' : 'Fr. 42 (Gᵞ)',
    'fr43' : 'Fr. 43 (Gᵋ)',
    'fr44' : 'Fr. 44 (Gᵋᵋ)',
    'fr45' : 'Fr. 45 (Gζ)',
    'fr46' : 'Fr. 46 (Gζζ)',
    'fr47' : 'Fr. 47 (Gη)',
    'fr48' : 'Fr. 48 (Gϑ)',
    'fr49' : 'Fr. 49 (Gι)',
    'fr50' : 'Fr. 50 (Gλ und j)',
    'fr51' : 'Fr. 51 (Gν und Gω)',
    'fr52' : 'Fr. 52 (Gξ)',
    'fr53' : 'Fr. 53 (Gρ)',
    'fr54' : 'Fr. 54 (Gψ)',
    'fr55' : 'Fr. 55 (B)',
    'fr56' : 'Fr. 56 (C)',
    'fr57' : 'Fr. 57 (H)',
    'fr58' : 'Fr. 58 (q)',
    'fr59' : 'Fr. 59',
    'fr60' : 'Fr. 60',
    'fr61' : 'Fr. 61',
    'fr62' : 'Fr. 62',
    'fr63' : 'Fr. 63',
    'fr64' : 'Fr. 64',
    'fr65' : 'Fr. 65',
    'fr66' : 'Fr. 66',
    'fr67' : 'Fr. 67',
    'fr68' : 'Fr. 68',
    'fr69' : 'Fr. 69',
    'fr70' : 'Fr. 70',
    'fr71' : 'Fr. 71',
    'fr72' : 'Fr. 72'
    }"/>
  
  <xd:doc scope="template">
    <xd:desc>
      <xd:p><xd:b></xd:b></xd:p>
      <xd:p>Extract naming information from files.</xd:p>
    </xd:desc>
    <xd:param name="repository">Repository name.</xd:param>
    <xd:param name="path_src">Relative path to source directory.</xd:param>
    <xd:param name="path_api">Relative path to target directory.</xd:param>
    <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
    <xd:param name="task">Task name.</xd:param>
  </xd:doc>
  <xsl:template name="metadata-nomenclature">
    <xsl:param name="repository" select="()"/>
    <xsl:param name="path_src" as="xs:string"/>
    <xsl:param name="path_api" as="xs:string"/>
    <xsl:param name="task" as="xs:string"/>
    <xsl:param name="verbose" as="xs:boolean"/>
    <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
    
    <xsl:result-document href="{$path_api}/json/metadata-nomenclature.json" method="json" indent="false">
      <xsl:variable name="payload">
        <map>
          <array key="hyparchetypes">
            <xsl:sequence select="$hyparchetypes => json-to-xml()"/>
          </array>
          <array key="codices">
            <xsl:variable name="fragment-uris" select="uri-collection($path_src||'data/original/transcription/?select=*.xml')[not(matches(.,'fr\d*\.xml'))]"/>
            <xsl:for-each select="$fragment-uris ! doc(.)">
              <xsl:sort select="base-uri()"/>
              <xsl:variable name="sigil" as="xs:string" select="base-uri() => replace('.+/(.+)\.xml','$1')"/>
              <map>
                <string key="handle">{$sigil}</string>
                <string key="sigil">{if (matches($sigil,'[a-z]k'))
                  then $sigil => substring-before('k')
                  else $sigil => upper-case()
                  }</string>
                <string key="aka">{}</string>
                <string key="cod">{TEI/teiHeader//msDesc/msIdentifier/idno => string-join(', ')}</string>
                <string key="loc">{TEI/teiHeader/fileDesc//repository}</string>
              </map>
            </xsl:for-each>
          </array>
          <array key="fragments">
            <xsl:variable name="fragment-uris" select="uri-collection($path_src||'data/original/transcription/?select=fr*.xml')"/>
            <xsl:for-each select="$fragment-uris ! doc(.)">
              <xsl:sort select="base-uri()"/>
              <xsl:variable name="handle" as="xs:string" select="base-uri() => replace('.+/(.+)\.xml','$1')"/>
              <map>
                <string key="handle">{$handle}</string>
                <string key="sigil">{map:get($fragment-sigla,$handle)}</string>
                <string key="aka">{TEI/teiHeader//msFrag/msIdentifier/idno => string-join(', ')}</string>
                <string key="cod">{TEI/teiHeader//msDesc/msIdentifier/idno}</string>
                <string key="loc">{TEI/teiHeader/fileDesc//repository}</string>
              </map>
            </xsl:for-each>
          </array>
        </map>
      </xsl:variable>
      <xsl:message use-when="$verbose">…writing {$path_api}/json/metadata-nomenclature.json…</xsl:message>
      <xsl:sequence select="$payload => xml-to-json(map { 'indent' : true() }) => parse-json()"/>
    </xsl:result-document>
    
    <xsl:message>Task `{$task}` done.</xsl:message>
  </xsl:template>
  
</xsl:transform>