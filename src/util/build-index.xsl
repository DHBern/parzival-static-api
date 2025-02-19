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
            <xd:p><xd:b>Created on:</xd:b> Dec 19, 2024</xd:p>
            <xd:p><xd:b>Author:</xd:b> pd</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output indent="true"/>
    
    <xd:doc scope="template">
        <xd:desc>
            <xd:p><xd:b></xd:b></xd:p>
            <xd:p>Prepare data for search index.</xd:p>
        </xd:desc>
        <xd:param name="repository">Repository name.</xd:param>
        <xd:param name="path_src">Relative path to source directory.</xd:param>
        <xd:param name="path_api">Relative path to target directory.</xd:param>
        <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
        <xd:param name="task">Task name.</xd:param>
    </xd:doc>
    <xsl:template name="build-index">
        <xsl:param name="repository" select="()"/>
        <xsl:param name="path_src" as="xs:string"/>
        <xsl:param name="path_api" as="xs:string"/>
        <xsl:param name="task" as="xs:string"/>
        <xsl:param name="verbose" as="xs:boolean"/>
        <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
        
        <xsl:result-document href="{$path_api}/json/search-index-transkript.json" method="json" indent="true">
            <xsl:call-template name="build-index-scoped">
                <xsl:with-param name="docs-uris" select="uri-collection($path_src || 'data/original/transcription/?select=*.xml')"/>
                <xsl:with-param name="task" select="$task||' (transkript)'"/>
            </xsl:call-template>
        </xsl:result-document>
        <xsl:result-document href="{$path_api}/json/search-index-fassung.json" method="json" indent="true">
            <xsl:call-template name="build-index-scoped">
                <xsl:with-param name="docs-uris" select="uri-collection($path_src || 'data/original/?select=*.xml')"/>
                <xsl:with-param name="task" select="$task||' (fassung)'"/>
            </xsl:call-template>
            </xsl:result-document>
        <xsl:message>Task `{$task}` done.</xsl:message>
    </xsl:template>
    
    <xsl:template name="build-index-scoped">
        <xsl:param name="docs-uris" as="item()+"/>
        <xsl:param name="task" as="xs:string"/>
        
        <xsl:variable name="serialization-parameters">
            <output:serialization-parameters>
                <output:method value="xml"/>
                <!-- html method breaks various things -->
            </output:serialization-parameters>
        </xsl:variable>
        <xsl:variable name="names" as="map(*)*" select="
                doc('../data/names.xml')//body//@xml:id !
                map:entry(., ./parent::*/*[local-name() = ('persName', 'placeName', 'form')]/text() => string-join('; '))
                => map:merge()"/>

        <xsl:variable name="payload">
            <map>
                <map key="meta">
                    <string key="task">{$task}</string>
                    <string key="generated-by">{let $regex := '.*('||$repository||'/.+)' return
                        base-uri() => replace($regex,'$1')}</string>
                    <string key="generated-on">{current-dateTime()}</string>
                    <string key="description">Verse-level information for search index.</string>
                </map>
                <array key="docs">
                    <!--<xsl:variable name="docs-uris" select="
                            uri-collection($path_src || 'data/original/transcription/?select=*.xml'),
                            uri-collection($path_src || 'data/original/?select=*.xml')"/>-->
                    <xsl:for-each select="$docs-uris ! doc(.)//l">
                        <xsl:sort select="base-uri()"/>
                        <xsl:variable name="type" as="xs:string" select="
                                if (matches(base-uri(), 'syn\d')) then
                                    'f'
                                else
                                    't'"/>
                        <xsl:variable name="id" as="xs:string" select="
                                if ($type = 'f') then
                                    @n => replace('\s', '_')
                                else
                                    @xml:id"/>
                        <xsl:variable name="sigil" as="xs:string" select="
                                if ($type = 'f') then
                                    preceding-sibling::head
                                else
                                    base-uri() => replace('.+/(.+)\.xml', '$1')"/>
                        <map>
                            <string key="type">{$type}</string>
                            <string key="id">{$id}</string>
                            <string key="sigla">{$sigil}</string>
                            <string key="verse">{$id => tokenize('\.') => tail()}</string>
                            <string key="d">{if ($type='f') then
                                ancestor::div[@type='Dreissiger']/@n else $id =>
                                replace('^(?:fr\d{1,2})?.[kv]?_*(\d{1,3})\..*$','$1')}</string>
                            <string key="content">
                                <xsl:apply-templates mode="janus"/>
                            </string>
                            <string key="content_all">
                                <xsl:apply-templates mode="all"/>
                            </string>
                            <xsl:if test="*[@ref]">
                                <array key="terms">
                                    <xsl:for-each select="*[@ref]">
                                        <xsl:for-each
                                            select="map:get($names, @ref => substring-after(':')) => tokenize(';\s')">
                                            <string>{.}</string>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </array>
                            </xsl:if>
                        </map>
                    </xsl:for-each>
                </array>

            </map>
        </xsl:variable>
        <xsl:message use-when="$verbose">…writing {$path_api}/json/search-index-{$task=>replace('.*\((.*)\)','$1')}.json…</xsl:message>
        <xsl:sequence select="$payload => xml-to-json(map { 'indent' : true() }) => replace('\sxmlns=\p{P}.*?([\s>])','$1') => normalize-space() => replace('\s–','&#160;–') => parse-json()"/>
        
    </xsl:template>

    <!-- all TEI elements in use -->
    <xsl:template match="add|am|choice|del|ex|g|gap|hi|lb|name|note|seg|sic|subst|supplied|unclear">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- two modes: janus for janus elements (only one of two alternatives is processed) and all to process all -->
    <xsl:template match="choice" mode="janus">
        <xsl:apply-templates select="am"/>
    </xsl:template>
    <xsl:template match="choice" mode="all">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="subst" mode="janus">
        <xsl:apply-templates select="add"/>
    </xsl:template>
    <xsl:template match="subst" mode="all">
        <xsl:apply-templates mode="all"/>
    </xsl:template>
    
    <!-- whitespace padding between del and add -->
    <xsl:template match="del" mode="all">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>

</xsl:transform>
