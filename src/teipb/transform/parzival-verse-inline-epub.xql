(:~

    Transformation module generated from TEI ODD extensions for processing models.
    ODD: /db/apps/parzival/odd/parzival-verse-inline.odd
 :)
xquery version "3.1";

module namespace model="http://www.tei-c.org/pm/models/parzival-verse-inline/epub";

declare default element namespace "http://www.tei-c.org/ns/1.0";

declare namespace xhtml='http://www.w3.org/1999/xhtml';

declare namespace mei='http://www.music-encoding.org/ns/mei';

declare namespace pb='http://teipublisher.com/1.0';

import module namespace css="http://www.tei-c.org/tei-simple/xquery/css";

import module namespace html="http://www.tei-c.org/tei-simple/xquery/functions";

import module namespace epub="http://www.tei-c.org/tei-simple/xquery/functions/epub";

import module namespace global="http://www.tei-c.org/tei-simple/config" at "../modules/config.xqm";

(: generated template function for element spec: l :)
declare %private function model:template-l($config as map(*), $node as node()*, $params as map(*)) {
    <t xmlns=""><span class="verse-inline" data-verse="{$config?apply-children($config, $node, $params?id)}">{$config?apply-children($config, $node, $params?content)}</span></t>/*
};
(: generated template function for element spec: ptr :)
declare %private function model:template-ptr($config as map(*), $node as node()*, $params as map(*)) {
    <t xmlns=""><pb-mei url="{$config?apply-children($config, $node, $params?url)}" player="player">
                              <pb-option name="appXPath" on="./rdg[contains(@label, 'original')]" off="">Original Clefs</pb-option>
                              </pb-mei></t>/*
};
(: generated template function for element spec: lb :)
declare %private function model:template-lb($config as map(*), $node as node()*, $params as map(*)) {
    ``[|]``
};
(: generated template function for element spec: name :)
declare %private function model:template-name($config as map(*), $node as node()*, $params as map(*)) {
    <t xmlns=""><span data-ref="{$config?apply-children($config, $node, $params?ref)}">{$config?apply-children($config, $node, $params?default)}</span></t>/*
};
(: generated template function for element spec: choice :)
declare %private function model:template-choice($config as map(*), $node as node()*, $params as map(*)) {
    ``[(`{string-join($config?apply-children($config, $node, $params?default))}`)]``
};
(: generated template function for element spec: mei:mdiv :)
declare %private function model:template-mei_mdiv($config as map(*), $node as node()*, $params as map(*)) {
    <t xmlns=""><pb-mei player="player" data="{$config?apply-children($config, $node, $params?data)}"/></t>/*
};
(: generated template function for element spec: gap :)
declare %private function model:template-gap($config as map(*), $node as node()*, $params as map(*)) {
    ``[:]``
};
(: generated template function for element spec: gap :)
declare %private function model:template-gap2($config as map(*), $node as node()*, $params as map(*)) {
    ``[::]``
};
(: generated template function for element spec: gap :)
declare %private function model:template-gap3($config as map(*), $node as node()*, $params as map(*)) {
    ``[:::]``
};
(: generated template function for element spec: gap :)
declare %private function model:template-gap4($config as map(*), $node as node()*, $params as map(*)) {
    ``[:::]``
};
(: generated template function for element spec: gap :)
declare %private function model:template-gap5($config as map(*), $node as node()*, $params as map(*)) {
    ``[-*-]``
};
(:~

    Main entry point for the transformation.
    
 :)
declare function model:transform($options as map(*), $input as node()*) {
        
    let $config :=
        map:merge(($options,
            map {
                "output": ["epub","web"],
                "odd": "/db/apps/parzival/odd/parzival-verse-inline.odd",
                "apply": model:apply#2,
                "apply-children": model:apply-children#3
            }
        ))
    
    return (
        html:prepare($config, $input),
    
        let $output := model:apply($config, $input)
        return
            html:finish($config, $output)
    )
};

declare function model:apply($config as map(*), $input as node()*) {
        let $parameters := 
        if (exists($config?parameters)) then $config?parameters else map {}
        let $mode := 
        if (exists($config?mode)) then $config?mode else ()
        let $trackIds := 
        $parameters?track-ids
        let $get := 
        model:source($parameters, ?)
    return
    $input !         (
            let $node := 
                .
            return
                            typeswitch(.)
                    case element(licence) return
                        if (@target) then
                            html:link($config, ., ("tei-licence1", "licence", css:map-rend-to-class(.)), 'Licence', @target, (), map {})
                        else
                            html:omit($config, ., ("tei-licence2", css:map-rend-to-class(.)), .)
                    case element(castItem) return
                        (: Insert item, rendered as described in parent list rendition. :)
                        html:listItem($config, ., ("tei-castItem", css:map-rend-to-class(.)), ., ())
                    case element(listBibl) return
                        if (bibl) then
                            html:list($config, ., ("tei-listBibl1", css:map-rend-to-class(.)), ., ())
                        else
                            epub:block($config, ., ("tei-listBibl2", css:map-rend-to-class(.)), .)
                    case element(item) return
                        html:listItem($config, ., ("tei-item", css:map-rend-to-class(.)), ., ())
                    case element(figure) return
                        if (head or @rendition='simple:display') then
                            epub:block($config, ., ("tei-figure1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-figure2", css:map-rend-to-class(.)), .)
                    case element(teiHeader) return
                        if ($parameters?header='short') then
                            epub:block($config, ., ("tei-teiHeader3", css:map-rend-to-class(.)), .)
                        else
                            html:metadata($config, ., ("tei-teiHeader4", css:map-rend-to-class(.)), .)
                    case element(g) return
                        if (not(text())) then
                            html:glyph($config, ., ("tei-g1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-g2", css:map-rend-to-class(.)), .)
                    case element(supplied) return
                        if (parent::choice) then
                            html:inline($config, ., ("tei-supplied1", css:map-rend-to-class(.)), .)
                        else
                            if (@reason='damage') then
                                html:inline($config, ., ("tei-supplied2", css:map-rend-to-class(.)), .)
                            else
                                if (@reason='illegible' or not(@reason)) then
                                    html:inline($config, ., ("tei-supplied3", css:map-rend-to-class(.)), .)
                                else
                                    if (@reason='omitted') then
                                        html:inline($config, ., ("tei-supplied4", css:map-rend-to-class(.)), .)
                                    else
                                        html:inline($config, ., ("tei-supplied5", css:map-rend-to-class(.)), .)
                    case element(author) return
                        if (ancestor::teiHeader) then
                            epub:block($config, ., ("tei-author1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-author2", css:map-rend-to-class(.)), .)
                    case element(castList) return
                        if (child::*) then
                            html:list($config, ., css:get-rendition(., ("tei-castList", css:map-rend-to-class(.))), castItem, ())
                        else
                            $config?apply($config, ./node())
                    case element(milestone) return
                        if (@unit='Versumstellung') then
                            html:inline($config, ., ("tei-milestone", "versechange", css:map-rend-to-class(.)), .)
                        else
                            $config?apply($config, ./node())
                    case element(l) return
                        let $params := 
                            map {
                                "id": substring-after(@xml:id,'_'),
                                "content": .
                            }

                                                let $content := 
                            model:template-l($config, ., $params)
                        return
                                                html:inline(map:merge(($config, map:entry("template", true()))), ., css:get-rendition(., ("tei-l", "verse-inline", css:map-rend-to-class(.))), $content)
                    case element(closer) return
                        epub:block($config, ., ("tei-closer", css:map-rend-to-class(.)), .)
                    case element(ptr) return
                        if (parent::notatedMusic) then
                            (: Load and display external MEI :)
                            let $params := 
                                map {
                                    "url": @target,
                                    "content": .
                                }

                                                        let $content := 
                                model:template-ptr($config, ., $params)
                            return
                                                        html:pass-through(map:merge(($config, map:entry("template", true()))), ., ("tei-ptr", css:map-rend-to-class(.)), $content)
                        else
                            $config?apply($config, ./node())
                    case element(signed) return
                        if (parent::closer) then
                            epub:block($config, ., ("tei-signed1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-signed2", css:map-rend-to-class(.)), .)
                    case element(list) return
                        html:list($config, ., css:get-rendition(., ("tei-list", css:map-rend-to-class(.))), item, ())
                    case element(p) return
                        html:paragraph($config, ., css:get-rendition(., ("tei-p2", css:map-rend-to-class(.))), .)
                    case element(q) return
                        if (l) then
                            epub:block($config, ., css:get-rendition(., ("tei-q1", css:map-rend-to-class(.))), .)
                        else
                            if (ancestor::p or ancestor::cell) then
                                html:inline($config, ., css:get-rendition(., ("tei-q2", css:map-rend-to-class(.))), .)
                            else
                                epub:block($config, ., css:get-rendition(., ("tei-q3", css:map-rend-to-class(.))), .)
                    case element(epigraph) return
                        epub:block($config, ., ("tei-epigraph", css:map-rend-to-class(.)), .)
                    case element(pb) return
                        html:omit($config, ., ("tei-pb", css:map-rend-to-class(.)), .)
                    case element(docTitle) return
                        epub:block($config, ., css:get-rendition(., ("tei-docTitle", css:map-rend-to-class(.))), .)
                    case element(lb) return
                        let $params := 
                            map {
                                "type": 'line',
                                "label": @n,
                                "content": .
                            }

                                                let $content := 
                            model:template-lb($config, ., $params)
                        return
                                                html:inline(map:merge(($config, map:entry("template", true()))), ., css:get-rendition(., ("tei-lb", css:map-rend-to-class(.))), $content)
                    case element(anchor) return
                        html:anchor($config, ., ("tei-anchor", css:map-rend-to-class(.)), ., @xml:id)
                    case element(TEI) return
                        html:document($config, ., ("tei-TEI", css:map-rend-to-class(.)), .)
                    case element(w) return
                        html:inline($config, ., ("tei-w", css:map-rend-to-class(.)), .)
                    case element(stage) return
                        epub:block($config, ., ("tei-stage", css:map-rend-to-class(.)), .)
                    case element(titlePage) return
                        epub:block($config, ., css:get-rendition(., ("tei-titlePage", css:map-rend-to-class(.))), .)
                    case element(name) return
                        let $params := 
                            map {
                                "default": .,
                                "ref": @ref,
                                "content": .
                            }

                                                let $content := 
                            model:template-name($config, ., $params)
                        return
                                                html:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-name", css:map-rend-to-class(.)), $content)
                    case element(formula) return
                        if (@rendition='simple:display') then
                            epub:block($config, ., ("tei-formula1", css:map-rend-to-class(.)), .)
                        else
                            if (@rend='display') then
                                html:webcomponent($config, ., ("tei-formula4", css:map-rend-to-class(.)), ., 'pb-formula', map {"display": true()})
                            else
                                html:webcomponent($config, ., ("tei-formula5", css:map-rend-to-class(.)), ., 'pb-formula', map {})
                    case element(front) return
                        epub:block($config, ., ("tei-front", css:map-rend-to-class(.)), .)
                    case element(lg) return
                        epub:block($config, ., ("tei-lg", css:map-rend-to-class(.)), .)
                    case element(choice) return
                        if (am and ex) then
                            let $params := 
                                map {
                                    "default": ex[1],
                                    "alternate": am[1],
                                    "content": .
                                }

                                                        let $content := 
                                model:template-choice($config, ., $params)
                            return
                                                        html:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-choice1", css:map-rend-to-class(.)), $content)
                        else
                            if (sic and corr) then
                                epub:alternate($config, ., ("tei-choice2", css:map-rend-to-class(.)), ., corr[1], sic[1])
                            else
                                if (abbr and expan) then
                                    epub:alternate($config, ., ("tei-choice3", css:map-rend-to-class(.)), ., expan[1], abbr[1])
                                else
                                    if (orig and reg) then
                                        epub:alternate($config, ., ("tei-choice4", css:map-rend-to-class(.)), ., reg[1], orig[1])
                                    else
                                        $config?apply($config, ./node())
                    case element(publicationStmt) return
                        epub:block($config, ., ("tei-publicationStmt1", css:map-rend-to-class(.)), availability/licence)
                    case element(hi) return
                        if (@rend='rot') then
                            html:inline($config, ., ("tei-hi1", "red", css:map-rend-to-class(.)), .)
                        else
                            if (@rend='unterstrichen') then
                                html:inline($config, ., ("tei-hi2", "underline", css:map-rend-to-class(.)), .)
                            else
                                if (@rend='rasur') then
                                    html:inline($config, ., ("tei-hi3", "rasure", css:map-rend-to-class(.)), .)
                                else
                                    $config?apply($config, ./node())
                    case element(role) return
                        epub:block($config, ., ("tei-role", css:map-rend-to-class(.)), .)
                    case element(code) return
                        html:inline($config, ., ("tei-code", css:map-rend-to-class(.)), .)
                    case element(note) return
                        if (@resp) then
                            html:omit($config, ., ("tei-note1", css:map-rend-to-class(.)), .)
                        else
                            if (@type='Notiz') then
                                html:inline($config, ., ("tei-note2", "note", css:map-rend-to-class(.)), .)
                            else
                                if (@type='Marginalie') then
                                    html:inline($config, ., ("tei-note3", "marginalia", css:map-rend-to-class(.)), .)
                                else
                                    if (not(@type='Kapitelüberschrift')) then
                                        html:inline($config, ., ("tei-note4", "note", css:map-rend-to-class(.)), .)
                                    else
                                        $config?apply($config, ./node())
                    case element(dateline) return
                        epub:block($config, ., ("tei-dateline", css:map-rend-to-class(.)), .)
                    case element(postscript) return
                        epub:block($config, ., ("tei-postscript", css:map-rend-to-class(.)), .)
                    case element(back) return
                        epub:block($config, ., ("tei-back", css:map-rend-to-class(.)), .)
                    case element(edition) return
                        if (ancestor::teiHeader) then
                            epub:block($config, ., ("tei-edition", css:map-rend-to-class(.)), .)
                        else
                            $config?apply($config, ./node())
                    case element(del) return
                        if (@hand='#sr') then
                            html:inline($config, ., ("tei-del1", "del_sr", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-del2", "deleted", css:map-rend-to-class(.)), .)
                    case element(cell) return
                        (: Insert table cell. :)
                        html:cell($config, ., ("tei-cell", css:map-rend-to-class(.)), ., ())
                    case element(div) return
                        if (@type='title_page') then
                            epub:block($config, ., ("tei-div1", css:map-rend-to-class(.)), .)
                        else
                            if (parent::body or parent::front or parent::back) then
                                html:section($config, ., ("tei-div2", css:map-rend-to-class(.)), .)
                            else
                                epub:block($config, ., ("tei-div3", css:map-rend-to-class(.)), .)
                    case element(trailer) return
                        epub:block($config, ., ("tei-trailer", css:map-rend-to-class(.)), .)
                    case element(reg) return
                        if (@type='Synkope') then
                            html:inline($config, ., ("tei-reg", "syncope", css:map-rend-to-class(.)), .)
                        else
                            $config?apply($config, ./node())
                    case element(graphic) return
                        html:graphic($config, ., ("tei-graphic", css:map-rend-to-class(.)), ., @url, @width, @height, @scale, desc)
                    case element(ref) return
                        if (@target) then
                            html:link($config, ., ("tei-ref1", css:map-rend-to-class(.)), ., @target, (), map {})
                        else
                            if (not(node())) then
                                html:link($config, ., ("tei-ref2", css:map-rend-to-class(.)), @target, @target, (), map {})
                            else
                                html:inline($config, ., ("tei-ref3", css:map-rend-to-class(.)), .)
                    case element(titlePart) return
                        epub:block($config, ., css:get-rendition(., ("tei-titlePart", css:map-rend-to-class(.))), .)
                    case element(ab) return
                        html:paragraph($config, ., ("tei-ab", css:map-rend-to-class(.)), .)
                    case element(add) return
                        if (@hand="#sr") then
                            html:inline($config, ., ("tei-add1", "sr", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-add2", "added", css:map-rend-to-class(.)), .)
                    case element(revisionDesc) return
                        html:omit($config, ., ("tei-revisionDesc", css:map-rend-to-class(.)), .)
                    case element(subst) return
                        if (@hand[starts-with(., '#ls')]) then
                            html:inline($config, ., ("tei-subst1", "subst_ls", css:map-rend-to-class(.)), .)
                        else
                            if (@hand[starts-with(., '#sr')]) then
                                html:inline($config, ., ("tei-subst2", "subst_sr", css:map-rend-to-class(.)), .)
                            else
                                html:inline($config, ., ("tei-subst3", "subst", css:map-rend-to-class(.)), .)
                    case element(head) return
                        if ($parameters?header='short') then
                            html:inline($config, ., ("tei-head1", css:map-rend-to-class(.)), replace(string-join(.//text()[not(parent::ref)]), '^(.*?)[^\w]*$', '$1'))
                        else
                            if (parent::figure) then
                                epub:block($config, ., ("tei-head2", css:map-rend-to-class(.)), .)
                            else
                                if (parent::table) then
                                    epub:block($config, ., ("tei-head3", css:map-rend-to-class(.)), .)
                                else
                                    if (parent::lg) then
                                        epub:block($config, ., ("tei-head4", css:map-rend-to-class(.)), .)
                                    else
                                        if (parent::list) then
                                            epub:block($config, ., ("tei-head5", css:map-rend-to-class(.)), .)
                                        else
                                            if (parent::div) then
                                                html:heading($config, ., ("tei-head6", css:map-rend-to-class(.)), ., count(ancestor::div))
                                            else
                                                epub:block($config, ., ("tei-head7", css:map-rend-to-class(.)), .)
                    case element(roleDesc) return
                        epub:block($config, ., ("tei-roleDesc", css:map-rend-to-class(.)), .)
                    case element(opener) return
                        epub:block($config, ., ("tei-opener", css:map-rend-to-class(.)), .)
                    case element(speaker) return
                        epub:block($config, ., ("tei-speaker", css:map-rend-to-class(.)), .)
                    case element(castGroup) return
                        if (child::*) then
                            (: Insert list. :)
                            html:list($config, ., ("tei-castGroup", css:map-rend-to-class(.)), castItem|castGroup, ())
                        else
                            $config?apply($config, ./node())
                    case element(time) return
                        html:inline($config, ., ("tei-time", css:map-rend-to-class(.)), .)
                    case element(bibl) return
                        if (parent::listBibl) then
                            html:listItem($config, ., ("tei-bibl1", css:map-rend-to-class(.)), ., ())
                        else
                            html:inline($config, ., ("tei-bibl2", css:map-rend-to-class(.)), .)
                    case element(imprimatur) return
                        epub:block($config, ., ("tei-imprimatur", css:map-rend-to-class(.)), .)
                    case element(salute) return
                        if (parent::closer) then
                            html:inline($config, ., ("tei-salute1", css:map-rend-to-class(.)), .)
                        else
                            epub:block($config, ., ("tei-salute2", css:map-rend-to-class(.)), .)
                    case element(unclear) return
                        html:inline($config, ., ("tei-unclear", css:map-rend-to-class(.)), .)
                    case element(argument) return
                        epub:block($config, ., ("tei-argument", css:map-rend-to-class(.)), .)
                    case element(date) return
                        if (@when) then
                            epub:alternate($config, ., ("tei-date1", css:map-rend-to-class(.)), ., ., @when)
                        else
                            html:inline($config, ., ("tei-date2", css:map-rend-to-class(.)), .)
                    case element(title) return
                        if ($parameters?header='short') then
                            html:heading($config, ., ("tei-title1", css:map-rend-to-class(.)), ., 5)
                        else
                            if (parent::titleStmt/parent::fileDesc) then
                                (
                                    if (preceding-sibling::title) then
                                        html:text($config, ., ("tei-title2", css:map-rend-to-class(.)), ' — ')
                                    else
                                        (),
                                    html:inline($config, ., ("tei-title3", css:map-rend-to-class(.)), .)
                                )

                            else
                                if (not(@level) and parent::bibl) then
                                    html:inline($config, ., ("tei-title4", css:map-rend-to-class(.)), .)
                                else
                                    if (@level='m' or not(@level)) then
                                        (
                                            html:inline($config, ., ("tei-title5", css:map-rend-to-class(.)), .),
                                            if (ancestor::biblFull) then
                                                html:text($config, ., ("tei-title6", css:map-rend-to-class(.)), ', ')
                                            else
                                                ()
                                        )

                                    else
                                        if (@level='s' or @level='j') then
                                            (
                                                html:inline($config, ., ("tei-title7", css:map-rend-to-class(.)), .),
                                                if (following-sibling::* and     (  ancestor::biblFull)) then
                                                    html:text($config, ., ("tei-title8", css:map-rend-to-class(.)), ', ')
                                                else
                                                    ()
                                            )

                                        else
                                            if (@level='u' or @level='a') then
                                                (
                                                    html:inline($config, ., ("tei-title9", css:map-rend-to-class(.)), .),
                                                    if (following-sibling::* and     (    ancestor::biblFull)) then
                                                        html:text($config, ., ("tei-title10", css:map-rend-to-class(.)), '. ')
                                                    else
                                                        ()
                                                )

                                            else
                                                html:inline($config, ., ("tei-title11", css:map-rend-to-class(.)), .)
                    case element(corr) return
                        if (parent::choice and count(parent::*/*) gt 1) then
                            (: simple inline, if in parent choice. :)
                            html:inline($config, ., ("tei-corr1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-corr2", "corr", css:map-rend-to-class(.)), .)
                    case element(foreign) return
                        html:inline($config, ., ("tei-foreign", css:map-rend-to-class(.)), .)
                    case element(mei:mdiv) return
                        (: Single MEI mdiv needs to be wrapped to create complete MEI document :)
                        let $params := 
                            map {
                                "data": let $title := root($parameters?root)//titleStmt/title let $data :=   <mei xmlns="http://www.music-encoding.org/ns/mei" meiversion="4.0.0">     <meiHead>         <fileDesc>             <titleStmt>                 <title></title>             </titleStmt>             <pubStmt></pubStmt>         </fileDesc>     </meiHead>     <music>         <body>{.}</body>     </music>   </mei> return   serialize($data),
                                "content": .
                            }

                                                let $content := 
                            model:template-mei_mdiv($config, ., $params)
                        return
                                                html:pass-through(map:merge(($config, map:entry("template", true()))), ., ("tei-mei_mdiv", css:map-rend-to-class(.)), $content)
                    case element(cit) return
                        if (child::quote and child::bibl) then
                            (: Insert citation :)
                            html:cit($config, ., ("tei-cit", css:map-rend-to-class(.)), ., ())
                        else
                            $config?apply($config, ./node())
                    case element(sic) return
                        if (parent::choice and count(parent::*/*) gt 1) then
                            html:inline($config, ., ("tei-sic1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-sic2", css:map-rend-to-class(.)), .)
                    case element(fileDesc) return
                        if ($parameters?header='short') then
                            (
                                epub:block($config, ., ("tei-fileDesc1", "header-short", css:map-rend-to-class(.)), titleStmt),
                                epub:block($config, ., ("tei-fileDesc2", "header-short", css:map-rend-to-class(.)), editionStmt),
                                epub:block($config, ., ("tei-fileDesc3", "header-short", css:map-rend-to-class(.)), publicationStmt),
                                (: Output abstract containing demo description :)
                                epub:block($config, ., ("tei-fileDesc4", "sample-description", css:map-rend-to-class(.)), ../profileDesc/abstract)
                            )

                        else
                            html:title($config, ., ("tei-fileDesc5", css:map-rend-to-class(.)), titleStmt)
                    case element(titleStmt) return
                        if ($parameters?mode='title') then
                            html:heading($config, ., ("tei-titleStmt3", css:map-rend-to-class(.)), title[not(@type)], 5)
                        else
                            if ($parameters?header='short') then
                                (
                                    html:link($config, ., ("tei-titleStmt4", css:map-rend-to-class(.)), title[1], $parameters?doc, (), map {}),
                                    epub:block($config, ., ("tei-titleStmt5", css:map-rend-to-class(.)), subsequence(title, 2)),
                                    epub:block($config, ., ("tei-titleStmt6", css:map-rend-to-class(.)), author)
                                )

                            else
                                epub:block($config, ., ("tei-titleStmt7", css:map-rend-to-class(.)), .)
                    case element(body) return
                        (
                            html:index($config, ., ("tei-body1", css:map-rend-to-class(.)), 'toc', .),
                            epub:block($config, ., ("tei-body2", css:map-rend-to-class(.)), .)
                        )

                    case element(spGrp) return
                        epub:block($config, ., ("tei-spGrp", css:map-rend-to-class(.)), .)
                    case element(fw) return
                        if (ancestor::p or ancestor::ab) then
                            html:inline($config, ., ("tei-fw1", css:map-rend-to-class(.)), .)
                        else
                            epub:block($config, ., ("tei-fw2", css:map-rend-to-class(.)), .)
                    case element(encodingDesc) return
                        html:omit($config, ., ("tei-encodingDesc", css:map-rend-to-class(.)), .)
                    case element(gap) return
                        if (number(@extent)=1) then
                            let $params := 
                                map {
                                    "content": .
                                }

                                                        let $content := 
                                model:template-gap($config, ., $params)
                            return
                                                        html:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-gap1", "gap", css:map-rend-to-class(.)), $content)
                        else
                            if (number(@extent)=2) then
                                let $params := 
                                    map {
                                        "content": .
                                    }

                                                                let $content := 
                                    model:template-gap2($config, ., $params)
                                return
                                                                html:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-gap2", "gap", css:map-rend-to-class(.)), $content)
                            else
                                if (@reason="Fragmentverlust") then
                                    let $params := 
                                        map {
                                            "content": .
                                        }

                                                                        let $content := 
                                        model:template-gap3($config, ., $params)
                                    return
                                                                        html:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-gap3", "fragment-loss", css:map-rend-to-class(.)), $content)
                                else
                                    if (@extent="unbekannt" or number(@extent)>=3) then
                                        let $params := 
                                            map {
                                                "content": .
                                            }

                                                                                let $content := 
                                            model:template-gap4($config, ., $params)
                                        return
                                                                                html:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-gap4", "gap", css:map-rend-to-class(.)), $content)
                                    else
                                        let $params := 
                                            map {
                                                "content": .
                                            }

                                                                                let $content := 
                                            model:template-gap5($config, ., $params)
                                        return
                                                                                html:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-gap5", "gap", css:map-rend-to-class(.)), $content)
                    case element(quote) return
                        if (ancestor::p) then
                            (: If it is inside a paragraph then it is inline, otherwise it is block level :)
                            html:inline($config, ., css:get-rendition(., ("tei-quote1", css:map-rend-to-class(.))), .)
                        else
                            (: If it is inside a paragraph then it is inline, otherwise it is block level :)
                            epub:block($config, ., css:get-rendition(., ("tei-quote2", css:map-rend-to-class(.))), .)
                    case element(notatedMusic) return
                        html:figure($config, ., ("tei-notatedMusic", css:map-rend-to-class(.)), (ptr, mei:mdiv), label)
                    case element(seg) return
                        if (@subtype='nicht_ausgeführt') then
                            html:inline($config, ., ("tei-seg1", "not-executed", css:map-rend-to-class(.)), .)
                        else
                            if (@type='Versumstellung') then
                                html:inline($config, ., ("tei-seg2", "verse-change", css:map-rend-to-class(.)), .)
                            else
                                if (@type='kleine_Variante') then
                                    (: no special styles :)
                                    html:inline($config, ., ("tei-seg3", "small-variant", css:map-rend-to-class(.)), .)
                                else
                                    if (@type='singuläre_Lesart') then
                                        (: no special styles :)
                                        html:inline($config, ., ("tei-seg4", "singular-reading", css:map-rend-to-class(.)), .)
                                    else
                                        if (@type='große_Variante') then
                                            html:inline($config, ., ("tei-seg5", "large-variant", css:map-rend-to-class(.)), .)
                                        else
                                            if (@subtype='Großinitiale') then
                                                html:inline($config, ., ("tei-seg6", "capital-initial", css:map-rend-to-class(.)), .)
                                            else
                                                if (@subtype='Majuskel') then
                                                    html:inline($config, ., ("tei-seg7", "majuscule", css:map-rend-to-class(.)), .)
                                                else
                                                    if (@subtype='Prachtinitiale') then
                                                        html:inline($config, ., ("tei-seg8", "glory-initial", css:map-rend-to-class(.)), .)
                                                    else
                                                        if (@type='Initiale') then
                                                            html:inline($config, ., css:get-rendition(., ("tei-seg9", "initial", css:map-rend-to-class(.))), .)
                                                        else
                                                            $config?apply($config, ./node())
                    case element(profileDesc) return
                        html:omit($config, ., ("tei-profileDesc", css:map-rend-to-class(.)), .)
                    case element(row) return
                        if (@role='label') then
                            html:row($config, ., ("tei-row1", css:map-rend-to-class(.)), .)
                        else
                            (: Insert table row. :)
                            html:row($config, ., ("tei-row2", css:map-rend-to-class(.)), .)
                    case element(floatingText) return
                        epub:block($config, ., ("tei-floatingText", css:map-rend-to-class(.)), .)
                    case element(text) return
                        html:body($config, ., ("tei-text", css:map-rend-to-class(.)), .)
                    case element(byline) return
                        epub:block($config, ., ("tei-byline", css:map-rend-to-class(.)), .)
                    case element(sp) return
                        epub:block($config, ., ("tei-sp", css:map-rend-to-class(.)), .)
                    case element(table) return
                        html:table($config, ., ("tei-table", css:map-rend-to-class(.)), .)
                    case element(cb) return
                        epub:break($config, ., ("tei-cb", css:map-rend-to-class(.)), ., 'column', @n)
                    case element(group) return
                        epub:block($config, ., ("tei-group", css:map-rend-to-class(.)), .)
                    case element(exist:match) return
                        html:match($config, ., .)
                    case element() return
                        if (namespace-uri(.) = 'http://www.tei-c.org/ns/1.0') then
                            $config?apply($config, ./node())
                        else
                            .
                    case text() | xs:anyAtomicType return
                        html:escapeChars(.)
                    default return 
                        $config?apply($config, ./node())

        )

};

declare function model:apply-children($config as map(*), $node as element(), $content as item()*) {
        
    if ($config?template) then
        $content
    else
        $content ! (
            typeswitch(.)
                case element() return
                    if (. is $node) then
                        $config?apply($config, ./node())
                    else
                        $config?apply($config, .)
                default return
                    html:escapeChars(.)
        )
};

declare function model:source($parameters as map(*), $elem as element()) {
        
    let $id := $elem/@exist:id
    return
        if ($id and $parameters?root) then
            util:node-by-id($parameters?root, $id)
        else
            $elem
};

declare function model:process-annotation($html, $context as node()) {
        
    let $classRegex := analyze-string($html/@class, '\s?annotation-([^\s]+)\s?')
    return
        if ($classRegex//fn:match) then (
            if ($html/@data-type) then
                ()
            else
                attribute data-type { ($classRegex//fn:group)[1]/string() },
            if ($html/@data-annotation) then
                ()
            else
                attribute data-annotation {
                    map:merge($context/@* ! map:entry(node-name(.), ./string()))
                    => serialize(map { "method": "json" })
                }
        ) else
            ()
                    
};

declare function model:map($html, $context as node(), $trackIds as item()?) {
        
    if ($trackIds) then
        for $node in $html
        return
            typeswitch ($node)
                case document-node() | comment() | processing-instruction() return 
                    $node
                case element() return
                    if ($node/@class = ("footnote")) then
                        if (local-name($node) = 'pb-popover') then
                            ()
                        else
                            element { node-name($node) }{
                                $node/@*,
                                $node/*[@class="fn-number"],
                                model:map($node/*[@class="fn-content"], $context, $trackIds)
                            }
                    else
                        element { node-name($node) }{
                            attribute data-tei { util:node-id($context) },
                            $node/@*,
                            model:process-annotation($node, $context),
                            $node/node()
                        }
                default return
                    <pb-anchor data-tei="{ util:node-id($context) }">{$node}</pb-anchor>
    else
        $html
                    
};

