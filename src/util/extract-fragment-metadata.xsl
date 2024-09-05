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
    'fr39' : 'Fr. 39 (Gᶻ und G&lt;sup>π&lt;/sup>)',
    'fr40' : 'Fr. 40 (Gα)',
    'fr41' : 'Fr. 41 (Gᵝ)',
    'fr42' : 'Fr. 42 (Gᵞ)',
    'fr43' : 'Fr. 43 (Gᵋ)',
    'fr44' : 'Fr. 44 (Gᵋᵋ)',
    'fr45' : 'Fr. 45 (G&lt;sup>ζ&lt;/sup>)',
    'fr46' : 'Fr. 46 (G&lt;sup>ζζ&lt;/sup>)',
    'fr47' : 'Fr. 47 (G&lt;sup>η&lt;/sup>)',
    'fr48' : 'Fr. 48 (G&lt;sup>ϑ&lt;/sup>)',
    'fr49' : 'Fr. 49 (G&lt;sup>ι&lt;/sup>)',
    'fr50' : 'Fr. 50 (G&lt;sup>λ&lt;/sup> und j)',
    'fr51' : 'Fr. 51 (G&lt;sup>ν&lt;/sup> und Gω&lt;/sup>)',
    'fr52' : 'Fr. 52 (G&lt;sup>ξ&lt;/sup>)',
    'fr53' : 'Fr. 53 (G&lt;sup>ρ&lt;/sup>)',
    'fr54' : 'Fr. 54 (G&lt;sup>ψ&lt;/sup>)',
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
  
  <xsl:variable name="quot" as="xs:string">"</xsl:variable>
  
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
    
    <xsl:result-document href="{$path_api}/json/metadata-nomenclature.json" method="json" indent="true">
      <xsl:variable name="serialization-parameters">
        <output:serialization-parameters>
          <output:method value="xml"/><!-- html method breaks various things -->
        </output:serialization-parameters>
      </xsl:variable>
      
      <xsl:variable name="payload">
        <map>
          <array key="hyparchetypes">
            <xsl:sequence select="let $xml := $hyparchetypes => json-to-xml() return $xml/*/*"/>
          </array>
          <array key="codices">
            <xsl:variable name="codices-uris" select="uri-collection($path_src||'data/original/transcription/?select=*.xml')[not(matches(.,'fr\d*\.xml'))]"/>
            <xsl:for-each select="$codices-uris ! doc(.)">
              <xsl:sort select="base-uri()"/>
              <xsl:variable name="sigil" as="xs:string" select="base-uri() => replace('.+/(.+)\.xml','$1')"/>
              <map>
                <string key="handle">{$sigil}</string>
                <string key="sigil">{if (matches($sigil,'[a-z]k'))
                  then $sigil => substring-before('k')
                  else $sigil => upper-case()
                  }</string>
                <string key="aka">{}</string>
                <array key="part">
                  <xsl:for-each select=".//msIdentifier[not(repository='Parzival-Projekt')]">
                    <map>
                      <string key="id">{idno => replace($quot,'')}</string>
                      <string key="loc">{string-join(settlement|repository,', ') => replace($quot,'')}</string>
                    </map>
                  </xsl:for-each>
                </array>
                <string key="info">
                  <xsl:variable name="info">
                    <xsl:apply-templates select="doc('../data/hs-descs.xml')//p[@corresp='Parzival-Projekt_'||$sigil]"/>
                  </xsl:variable>
                  <xsl:sequence select="serialize($info,$serialization-parameters/output:serialization-parameters) => normalize-space()"/>
                </string>
                <string key="info-h1">
                  <xsl:variable name="info-h1">
                    <xsl:apply-templates select="doc('../data/hs-descs.xml')//p[@corresp='Parzival-Projekt_'||$sigil]/title[@type='main']"/>
                  </xsl:variable>
                  <xsl:sequence select="serialize($info-h1,$serialization-parameters/output:serialization-parameters) => normalize-space()"/>
                </string>
                <string key="info-h2">
                  <xsl:variable name="info-h2">
                    <xsl:apply-templates select="doc('../data/hs-descs.xml')//p[@corresp='Parzival-Projekt_'||$sigil]/title[not(@type='main')]"/>
                  </xsl:variable>
                  <xsl:sequence select="serialize($info-h2,$serialization-parameters/output:serialization-parameters) => normalize-space()"/>
                </string>
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
                <string key="aka">{TEI/teiHeader//msFrag/msIdentifier/idno => string-join(', ') => replace($quot,'')}</string>
                <array key="part">
                  <xsl:for-each select=".//msIdentifier[not(repository='Parzival-Projekt')]">
                    <map>
                      <string key="id">{idno  => replace($quot,'')}</string>
                      <string key="loc">{string-join(settlement|repository,', ') => replace($quot,'')}</string>
                    </map>
                  </xsl:for-each>
                </array>
                <string key="info">
                  <xsl:variable name="info">
                    <xsl:apply-templates select="doc('../data/hs-descs.xml')//p[@corresp='Parzival-Projekt_'||$handle]"/>
                  </xsl:variable>
                  <xsl:sequence select="serialize($info,$serialization-parameters/output:serialization-parameters) => normalize-space()"/>
                </string>
                <string key="info-h1">
                  <xsl:variable name="info-h1">
                    <xsl:apply-templates select="doc('../data/hs-descs.xml')//p[@corresp='Parzival-Projekt_'||$handle]/title[@type='main']"/>
                  </xsl:variable>
                  <xsl:sequence select="serialize($info-h1,$serialization-parameters/output:serialization-parameters) => normalize-space()"/>
                </string>
                <string key="info-h2">
                  <xsl:variable name="info-h2">
                    <xsl:apply-templates select="doc('../data/hs-descs.xml')//p[@corresp='Parzival-Projekt_'||$handle]//list"/>
                  </xsl:variable>
                  <xsl:sequence select="serialize($info-h2,$serialization-parameters/output:serialization-parameters) => normalize-space()"/>
                </string>
              </map>
            </xsl:for-each>
          </array>
        </map>
      </xsl:variable>
      <xsl:message use-when="$verbose">…writing {$path_api}/json/metadata-nomenclature.json…</xsl:message>
      <xsl:sequence select="$payload => xml-to-json(map { 'indent' : true() })  => replace('\sxmlns=\p{P}.*?([\s>])','$1') => normalize-space() => parse-json()"/>
    </xsl:result-document>
    
    <xsl:message>Task `{$task}` done.</xsl:message>
  </xsl:template>
  
  <xsl:template match="p" exclude-result-prefixes="#all">
    <p xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="node() except title except list"/>
    </p>
  </xsl:template>
  
  <xsl:template match="ref" exclude-result-prefixes="#all">
    <a href="{@target}" target="_blank" xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  
  <xsl:template match="title" exclude-result-prefixes="#all">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="list" exclude-result-prefixes="#all">
    <ul xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  
  <xsl:template match="item" exclude-result-prefixes="#all">
    <li xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
</xsl:transform>
