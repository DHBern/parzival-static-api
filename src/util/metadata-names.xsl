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
            <xd:p>Entity names.</xd:p>
        </xd:desc>
        <xd:param name="repository">Repository name.</xd:param>
        <xd:param name="path_src">Relative path to source directory.</xd:param>
        <xd:param name="path_api">Relative path to target directory.</xd:param>
        <xd:param name="verbose">Toggle verbose output (true/false).</xd:param>
        <xd:param name="task">Task name.</xd:param>
    </xd:doc>
    <xsl:template name="metadata-names">
        <xsl:param name="repository" select="()"/>
        <xsl:param name="path_src" as="xs:string"/>
        <xsl:param name="path_api" as="xs:string"/>
        <xsl:param name="task" as="xs:string"/>
        <xsl:param name="verbose" as="xs:boolean"/>
        <xsl:message use-when="$verbose">Starting task: {$task}</xsl:message>
        
        <xsl:result-document href="{$path_api}/json/names.json" method="json" indent="true">
            <xsl:variable name="serialization-parameters">
                <output:serialization-parameters>
                    <output:method value="xml"/><!-- html method breaks various things -->
                </output:serialization-parameters>
            </xsl:variable>
            
            <xsl:variable name="payload">
                <map>
                    <map key="meta">
                        <string key="task">{$task}</string>
                        <string key="generated-by">{let $regex := '.*('||$repository||'/.+)' return base-uri() => replace($regex,'$1')}</string>
                        <string key="generated-on">{current-dateTime()}</string>
                        <string key="description">Entity names.</string>
                    </map>
                    <array key="names">
                        <xsl:variable name="names.xml" select="doc($path_src||'data/names.xml')"/>
                        <!-- listPerson, listRelation, listPlace, listNym -->
                        <!-- TODO: clarify need for relations; if needed, decide how to implement the structure -->
                        <map>                                
                            <array key="persons">
                                <xsl:for-each select="$names.xml//listPerson/person">
                                    <map>
                                        <string key="id">{@xml:id}</string>
                                        <array key="name">
                                            <xsl:for-each select="persName">
                                                <string>{.}</string>
                                            </xsl:for-each>
                                        </array>
                                        <string key="sex">{sex}</string>
                                        <array key="source">
                                            <xsl:for-each select="@source => tokenize('\s')">
                                                <string>{.}</string>
                                            </xsl:for-each>
                                        </array>
                                    </map>
                                </xsl:for-each>
                            </array>
                            <array key="places">
                                <xsl:for-each select="$names.xml//listPlace/place">
                                    <map>
                                        <string key="id">{@xml:id}</string>
                                        <array key="name">
                                            <xsl:for-each select="placeName">
                                                <string>{.}</string>
                                            </xsl:for-each>
                                        </array>
                                        <string key="type">{@type}</string>
                                    </map>
                                </xsl:for-each>
                            </array>
                            <array key="nyms">
                                <xsl:for-each select="$names.xml//listNym/nym">
                                    <map>
                                        <string key="id">{@xml:id}</string>
                                        <array key="name">
                                            <xsl:for-each select="form">
                                                <string>{.}</string>
                                            </xsl:for-each>
                                        </array>
                                        <array key="def">
                                            <xsl:for-each select="def">
                                                <string>{.}</string>
                                            </xsl:for-each>
                                        </array>
                                        <string key="type">{@type}</string>
                                    </map>
                                </xsl:for-each>
                            </array>
                        </map>
                    </array>
                    
                </map>
            </xsl:variable>
            <xsl:message use-when="$verbose">…writing {$path_api}/json/names.json…</xsl:message>
            <xsl:sequence select="$payload => xml-to-json(map { 'indent' : true() }) => replace('\sxmlns=\p{P}.*?([\s>])','$1') => normalize-space() => replace('\s–','&#160;–') => parse-json()"/>
        </xsl:result-document>
        
        <xsl:message>Task `{$task}` done.</xsl:message>
    </xsl:template>
    
    
</xsl:transform>