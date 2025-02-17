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
    exclude-result-prefixes="array dsl map xs xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sept 2, 2024</xd:p>
            <xd:p><xd:b>Author:</xd:b> pd</xd:p>
            <xd:p>Adds manuscript descriptions (prose) to the teiHeader.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:template match="physDesc[parent::msDesc[msIdentifier/altIdentifier/@type='Parzival-Projekt']]" mode="pass-through">
        <xsl:param name="idno" as="xs:string?"/>
        <xsl:variable name="idno" as="xs:string" select="$idno => substring-before('.xml') => normalize-space()"/>
        <xsl:copy>
            <xsl:if test="not(matches($idno => substring-before('.xml'),'fr'))">
                <objectDesc xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:copy-of select="doc('../../data/hs-descs.xml')//*:objectDesc/*:p[@corresp=('Parzival-Projekt_'||$idno)]"/>
                </objectDesc>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="msDesc[not(physDesc)]" mode="pass-through">
        <xsl:param name="idno" as="xs:string?"/>
        <xsl:variable name="idno" as="xs:string" select="$idno => substring-before('.xml') => normalize-space()"/>
        <xsl:copy>
            <xsl:copy-of select="msIdentifier"/>
            <xsl:if test="not(matches($idno => substring-before('.xml'),'fr'))">
                <physDesc xmlns="http://www.tei-c.org/ns/1.0">
                    <objectDesc xmlns="http://www.tei-c.org/ns/1.0">
                        <xsl:copy-of select="doc('../../data/hs-descs.xml')//*:objectDesc/*:p[@corresp=('Parzival-Projekt_'||$idno)]"/>
                    </objectDesc>
                </physDesc>
            </xsl:if>
            <xsl:apply-templates select="node() except msIdentifier"/>
        </xsl:copy>
    </xsl:template>

</xsl:transform>