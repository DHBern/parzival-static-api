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
            <xd:p><xd:b>Created on:</xd:b> Nov 11, 2026</xd:p>
            <xd:p><xd:b>Author:</xd:b> pd</xd:p>
            <xd:p>Collects data for citation purposes (mainly DOI).</xd:p>
        </xd:desc>
    </xd:doc>
        
    <!-- 
    
    [
    {
        "slug": "/",
        "url": "https://parzival.unibe.ch/",
        "citation_doi": "10.…/3ef14e88",
        "citation_scope": "" 
    },
    {
   	 "slug": "/textzeugen", 
        "url": "https://parzival.unibe.ch/textzeugen",
        "citation_doi": "10.…/f42ea89a",
        "citation_scope": "Textzeugenansicht"
    },
    {
        "slug": "/transkriptionen/d",
        "url": "https://parzival.unibe.ch/transkriptionen/d/1/01",
        "citation_doi": "10.…/cbb4548d",
        "citation_scope": "Transkriptionsansicht"
    },
    {
        "slug": "/transkriptionen/fr72",
        "url": "https://parzival.unibe.ch/transkriptionen/fr72/1/01",
        "citation_doi": "10..…/67036366",
        "citation_scope": "Transkriptionsansicht"
    },
    {
        "slug": "/fassungen",
        "url": "https://parzival.unibe.ch/fassungen",
        "citation_doi": "10.…/031e67d5",
        "citation_scope": "Fassungsansicht"
    },
    {
        "slug": "/verssynopse",
        "url": "https://parzival.unibe.ch/verssynopse",
        "citation_doi": "10.…/eefa1026",
        "citation_scope": "Verssynopse"
    }
]

    -->
    
    <!-- Base64 encoding functions -->
    <xsl:import href="https://gist.githubusercontent.com/pdaengeli/419d2eac4a63c24597fdf1bdb301d1c3/raw/base64.xsl"/>
    
    <xsl:variable name="doi-prefix" select="unparsed-text-lines('../data/doi-beacon.txt')[matches(.,'^#PREFIX:')] => replace('^#PREFIX:\s*','')"/>
    
    <xsl:function name="dsl:citation.json">
        <xsl:sequence select="
            array {
            for $line in unparsed-text-lines('../data/doi-beacon.txt')[matches(.,'^[0-z]+\|\S+\|.+')]
            return map {
            'citation_doi': $doi-prefix||$line => tokenize('\|') => head(),
            'id': ($line  => tokenize('\|'))[2],
            (: full url from beacon :)
            'url': $line => tokenize('\|') => reverse() => head(),
            (: trim host and verse paths :)
            'slug': $line => tokenize('\|') => reverse() => head() => tokenize('/') => subsequence(4, 2) => string-join('/'),
            'citation_scope': $line => tokenize('\|') => reverse() => head() => dsl:citation_scope()
            }
            }
            "/>
    </xsl:function>
    
    <xsl:function name="dsl:citation_scope">
        <xsl:param name="url" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="contains($url,'transkriptionen')">Transkription</xsl:when>
            <xsl:when test="contains($url,'textzeugen')">Textzeugenansicht</xsl:when>
            <xsl:when test="contains($url,'fassungen')">Fassungsansicht</xsl:when>
            <xsl:when test="contains($url,'eintextedition')">Eintextedition</xsl:when>
            <xsl:when test="contains($url,'verssynopse')">Verssynopse</xsl:when>
            <xsl:when test="contains($url,'einfuehrung')">Einführung</xsl:when>
            <xsl:when test="contains($url,'erlaeuterungen')">Erläuterungen</xsl:when>
            <xsl:when test="contains($url,'publikationen')">Publikationen</xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
    <xd:doc scope="template">
        <xd:desc>
            <xd:p><xd:b>citations-json</xd:b></xd:p>
            <xd:p>Store array containing citation information.</xd:p>
        </xd:desc>
        <xd:param name="repository">Repository name.</xd:param>
        <xd:param name="path_src">Relative path to source directory.</xd:param>
        <xd:param name="path_api">Relative path to target directory.</xd:param>
        <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
        <xd:param name="task">Task name.</xd:param>
    </xd:doc>
    <xsl:template name="citations-json">
        <xsl:param name="repository" as="xs:string"/>
        <xsl:param name="path_src" as="xs:string"/>
        <xsl:param name="path_api" as="xs:string"/>
        <xsl:param name="verbose" as="xs:boolean"/>
        <xsl:param name="task" as="xs:string"/>
        <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
        <xsl:message>
            citation_doi: {$citations.json?1?('citation_doi')}
            id: {$citations.json?1?('id')}
            url: {$citations.json?1?('url')}
            slug: {$citations.json?1?('slug')}
            citation_scope: {$citations.json?1?('citation_scope')}
        </xsl:message>
        <xsl:result-document href="{$path_api}/json/citations.json" method="json" indent="true" use-character-maps="unescape-solidus">
            <xsl:sequence select="$citations.json"/>
        </xsl:result-document>
        <xsl:message use-when="$verbose">…writing {$path_api}/json/citations.json…</xsl:message>
        <xsl:message>Task `{$task}` done.</xsl:message>
    </xsl:template>
    
    <xd:doc scope="template">
        <xd:desc>
            <xd:p><xd:b>citations-doi</xd:b></xd:p>
            <xd:p>Generate DOI files for DataCite submission.</xd:p>
        </xd:desc>
        <xd:param name="repository">Repository name.</xd:param>
        <xd:param name="path_src">Relative path to source directory.</xd:param>
        <xd:param name="path_api">Relative path to target directory.</xd:param>
        <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
        <xd:param name="task">Task name.</xd:param>
    </xd:doc>
    <xsl:template name="citations-doi">
        <xsl:param name="repository" as="xs:string"/>
        <xsl:param name="path_src" as="xs:string"/>
        <xsl:param name="path_api" as="xs:string"/>
        <xsl:param name="verbose" as="xs:boolean"/>
        <xsl:param name="task" as="xs:string"/>
        <xsl:param name="doi-event" as="xs:string"/>
        <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
        
        <xsl:for-each select="unparsed-text-lines('../data/doi-beacon.txt')[matches(.,'^[0-z]+\|\S+\|.+')]">
            <xsl:variable name="id" select="(. => tokenize('\|'))[2]"/>
            <xsl:variable name="doi" select="$citations.json?*[?id=$id]?citation_doi"/>
            <xsl:variable name="tei" select="if (doc-available('../data/original/transcription/'||$id||'.xml')) then doc('../data/original/transcription/'||$id||'.xml')
                else doc('../data/df-descs.xml')"/>
            <xsl:variable name="dcXml">
                <xsl:call-template name="buildDcXml">
                    <xsl:with-param name="id" select="$id"/>
                    <xsl:with-param name="doi" select="$doi"/>
                    <xsl:with-param name="tei" select="$tei"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:message use-when="$verbose">…writing {$path_api}/doi/xml/{$id}.xml…</xsl:message>
            <xsl:result-document href="{$path_api}/doi/xml/{$id}.xml" method="xml" indent="true">
                <xsl:sequence select="$dcXml"/>
            </xsl:result-document>
            
            <!-- to dcJson -->
            <xsl:message use-when="$verbose">…writing {$path_api}/doi/json/{$id}.json…</xsl:message>
            <xsl:result-document href="{$path_api}/doi/json/{$id}.json" method="json" indent="true"  use-character-maps="unescape-solidus">
                
                <xsl:sequence select="
                    map {
                        'data': 
                        map {
                            'type': 'dois',
                            'attributes': 
                                map {
                                    'event': $doi-event,
                                    'doi': $doi,
                                    'xml': $dcXml => dsl:base64(),
                                    'url': $citations.json?*[?id = $id]?url
                                }
                            }
                        }
                    "/>
                
            </xsl:result-document>
            
            <!-- 
            if ($altId[normalize-space()]) then
                    map {
                    'alternateIdentifiers': [
                    map {
                    'alternateIdentifierType': 'Local project ID',
                    'alternateIdentifier':
                    ($altId => tokenize('/'))[last()]
                    => substring-after('id=')
                    }
                    ]
                    }
                    else
                    map {}
            -->
            
        </xsl:for-each>
        
        <xsl:call-template name="store-scipts"/>
        
        <!--<xsl:message use-when="$verbose">…writing {$path_api}/json/citations.json…</xsl:message>-->
        <xsl:message>Task `{$task}` done.</xsl:message>
        
    </xsl:template>
    
    <xsl:template name="buildDcXml">
        <xsl:param name="id"/>
        <xsl:param name="doi"/>
        <xsl:param name="tei"/>
        <xsl:variable name="tei" select="if ($tei//TEI[@xml:id=$id]) then $tei//TEI[@xml:id=$id] else $tei"/>
        <resource xmlns="http://datacite.org/schema/kernel-4"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://datacite.org/schema/kernel-4 https://schema.datacite.org/meta/kernel-4/metadata.xsd">
            <identifier identifierType="DOI">{$doi}</identifier>
            <xsl:choose>
                <xsl:when test="$tei/@xml:id">
                    <creators>
                        <creator nameType="Organizational">{$tei//titleStmt/editor}</creator>
                    </creators>
                    <contributors>
                        <xsl:for-each select="$tei//titleStmt/respStmt/name">
                            <contributor contributorType="{preceding-sibling::resp}">
                                <contributorName nameType="Personal">{.}</contributorName>
                            </contributor>
                        </xsl:for-each>
                    </contributors>
                </xsl:when>
                <xsl:otherwise>
                    <creators>
                        <creator>
                            <creatorName nameType="Personal">Prof. Michael Stolz</creatorName>
                            <givenName>Michael</givenName>
                            <familyName>Stolz</familyName>
                            <!-- https://orcid.org/0000-0003-3048-0060 -->
                        </creator>
                        <creator>
                            <creatorName nameType="Personal">PD Dr. Stefan Abel</creatorName>
                            <givenName>Stefan</givenName>
                            <familyName>Abel</familyName>
                            <!-- https://orcid.org/0000-0003-1520-3815 -->
                        </creator>
                    </creators>
                </xsl:otherwise>
            </xsl:choose>
            <titles>
                <title>
                    <xsl:choose>
                        <xsl:when test="contains($id,'parzival')">Wolfram von Eschenbach, ›Parzival‹: Digitale Edition</xsl:when>
                        <xsl:when test="contains($id,'textzeugen')">Parzival, Textzeugenansicht</xsl:when>
                        <xsl:when test="contains($id,'fassungen')">Parzival, Fassungsansicht</xsl:when>
                        <xsl:when test="contains($id,'eintextedition')">Parzival, Eintextedition</xsl:when>
                        <xsl:when test="contains($id,'verssynopse')">Parzival, Verssynopse</xsl:when>
                        <xsl:when test="contains($id,'einfuehrung')">Parzival, Einführung</xsl:when>
                        <xsl:when test="contains($id,'erlaeuterungen')">Parzival, Erläuterungen</xsl:when>
                        <xsl:when test="contains($id,'publikationen')">Parzival, Publikationen</xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="($tei//title[@type='main'],$tei//title[@type='sub']) => string-join(', ')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </title>
            </titles>
            <publisher>{$tei//titleStmt/editor}</publisher>
            <publicationYear>
                <xsl:choose>
                    <xsl:when test="matches($id,'parzival|textzeugen|fassungen|eintextedition|verssynopse|einfuehrung|erlaeuterungen|publikationen')">2026</xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="if ($tei//publicationStmt/date/@when) 
                            then $tei//publicationStmt/date/@when/data() 
                            else 
                                if (matches($tei//date,'\.\d{2}$')) 
                                then '20'||($tei//date=>tokenize('\.'))[last()]
                                else ($tei//date=>tokenize('\.'))[last()]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </publicationYear>
            <rightsList>
                <rights xml:lang="en" schemeURI="https://spdx.org/licenses/"
                    rightsIdentifierScheme="SPDX" rightsIdentifier="CC-BY-SA-4.0"
                    rightsURI="https://creativecommons.org/licenses/by-sa/4.0/">CC-BY-SA 4.0;
                    Copyright: Autor*innen</rights>
            </rightsList>
            <descriptions>
                <description descriptionType="Other"> </description>
            </descriptions>
            <resourceType resourceTypeGeneral="Text">Digital Scholarly Edition</resourceType>
        </resource>
    </xsl:template>
    
    <xsl:template name="store-scipts">
        <xsl:result-document href="{$path_api}/doi/scripts/file-list.txt" method="text" encoding="utf-8">
            <xsl:for-each select="unparsed-text-lines('../data/doi-beacon.txt')[matches(.,'^[0-z]+\|\S+\|.+')]">
                <xsl:text>../json/{tokenize(.,'\|')[2]}.json&#xA;</xsl:text>
            </xsl:for-each>
        </xsl:result-document>
            
        
        <xsl:result-document href="{$path_api}/doi/scripts/create-doi.sh" method="text" encoding="utf-8">
<xsl:text expand-text="false"><![CDATA[#!/bin/bash

set -u

# Check parameters
if [[ $# -lt 2 || $# -gt 3 ]]; then
    echo "Usage: $0 <test|prod> <username> [password]"
    echo "Alternatively, supply the password via DATACITE_PASSWORD."
    exit 1
fi

MODE="$1"
USERNAME="$2"
PASSWORD="${3:-${DATACITE_PASSWORD:-}}"

# Check password
if [[ -z "$PASSWORD" ]]; then
    echo "Error: No password supplied."
    exit 1
fi

# Select API endpoint
case "$MODE" in
    test)
        API_URL="https://api.test.datacite.org/dois"
        ;;
    prod)
        API_URL="https://api.datacite.org/dois"
        ;;
    *)
        echo "Error: Mode must be 'test' or 'prod'."
        exit 1
        ;;
esac

# Create authentication header
AUTH_HEADER=$(printf '%s' "$USERNAME:$PASSWORD" | base64 | tr -d '\n')

CONTENT_TYPE_HEADER="Content-Type: application/vnd.api+json"

# Process files
while IFS= read -r file || [[ -n "$file" ]]; do

    # Skip empty lines and comments
    [[ -z "$file" || "$file" == \#* ]] && continue

    if [[ -f "$file" ]]; then
        printf "\nProcessing file: %s\n" "$file"

        curl --fail-with-body -sS -X POST \
            -H "$CONTENT_TYPE_HEADER" \
            -H "Authorization: Basic $AUTH_HEADER" \
            -d @"$file" \
            "$API_URL"

        echo
    else
        echo "File not found: $file"
    fi

done < file-list.txt]]></xsl:text>

        </xsl:result-document>
        
        <xsl:result-document href="{$path_api}/doi/scripts/update-doi.sh" method="text" encoding="utf-8">
            <xsl:text expand-text="false">
                fooo
            </xsl:text>
        </xsl:result-document>
        
        <xsl:result-document href="{$path_api}/doi/scripts/README.md" method="text" encoding="utf-8">
            <xsl:text expand-text="false"># DOI scripts

* Make the scripts executable
* Run them in `test` or `prod` mode:
    ```
    ./create-doi.sh test myusername mypassword
    
    ./create-doi.sh prod myusername mypassword
    ```
* or using an env var
    ```
    export DATACITE_PASSWORD="mypassword"
    
    ./create-doi.sh test myusername
    ```

            </xsl:text>
        </xsl:result-document>
    </xsl:template>
    
</xsl:transform>