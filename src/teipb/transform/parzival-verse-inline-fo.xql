(:~

    Transformation module generated from TEI ODD extensions for processing models.
    ODD: /db/apps/parzival/odd/parzival-verse-inline.odd
 :)
xquery version "3.1";

module namespace model="http://www.tei-c.org/pm/models/parzival-verse-inline/fo";

declare default element namespace "http://www.tei-c.org/ns/1.0";

declare namespace xhtml='http://www.w3.org/1999/xhtml';

declare namespace mei='http://www.music-encoding.org/ns/mei';

declare namespace pb='http://teipublisher.com/1.0';

import module namespace css="http://www.tei-c.org/tei-simple/xquery/css";

import module namespace fo="http://www.tei-c.org/tei-simple/xquery/functions/fo";

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
                "output": ["fo"],
                "odd": "/db/apps/parzival/odd/parzival-verse-inline.odd",
                "apply": model:apply#2,
                "apply-children": model:apply-children#3
            }
        ))
    let $config := fo:init($config, $input)
    
    return (
        
        let $output := model:apply($config, $input)
        return
            $output
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
                        fo:omit($config, ., ("tei-licence2", css:map-rend-to-class(.)), .)
                    case element(castItem) return
                        (: Insert item, rendered as described in parent list rendition. :)
                        fo:listItem($config, ., ("tei-castItem", css:map-rend-to-class(.)), ., ())
                    case element(listBibl) return
                        if (bibl) then
                            fo:list($config, ., ("tei-listBibl1", css:map-rend-to-class(.)), ., ())
                        else
                            fo:block($config, ., ("tei-listBibl2", css:map-rend-to-class(.)), .)
                    case element(item) return
                        fo:listItem($config, ., ("tei-item", css:map-rend-to-class(.)), ., ())
                    case element(figure) return
                        if (head or @rendition='simple:display') then
                            fo:block($config, ., ("tei-figure1", css:map-rend-to-class(.)), .)
                        else
                            fo:inline($config, ., ("tei-figure2", css:map-rend-to-class(.)), .)
                    case element(teiHeader) return
                        fo:omit($config, ., ("tei-teiHeader2", css:map-rend-to-class(.)), .)
                    case element(g) return
                        if (not(text())) then
                            fo:glyph($config, ., ("tei-g1", css:map-rend-to-class(.)), .)
                        else
                            fo:inline($config, ., ("tei-g2", css:map-rend-to-class(.)), .)
                    case element(supplied) return
                        if (parent::choice) then
                            fo:inline($config, ., ("tei-supplied1", css:map-rend-to-class(.)), .)
                        else
                            if (@reason='damage') then
                                fo:inline($config, ., ("tei-supplied2", css:map-rend-to-class(.)), .)
                            else
                                if (@reason='illegible' or not(@reason)) then
                                    fo:inline($config, ., ("tei-supplied3", css:map-rend-to-class(.)), .)
                                else
                                    if (@reason='omitted') then
                                        fo:inline($config, ., ("tei-supplied4", css:map-rend-to-class(.)), .)
                                    else
                                        fo:inline($config, ., ("tei-supplied5", css:map-rend-to-class(.)), .)
                    case element(author) return
                        if (ancestor::teiHeader) then
                            fo:block($config, ., ("tei-author1", css:map-rend-to-class(.)), .)
                        else
                            fo:inline($config, ., ("tei-author2", css:map-rend-to-class(.)), .)
                    case element(castList) return
                        if (child::*) then
                            fo:list($config, ., css:get-rendition(., ("tei-castList", css:map-rend-to-class(.))), castItem, ())
                        else
                            $config?apply($config, ./node())
                    case element(milestone) return
                        if (@unit='Versumstellung') then
                            fo:inline($config, ., ("tei-milestone", "versechange", css:map-rend-to-class(.)), .)
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
                                                fo:inline(map:merge(($config, map:entry("template", true()))), ., css:get-rendition(., ("tei-l", "verse-inline", css:map-rend-to-class(.))), $content)
                    case element(closer) return
                        fo:block($config, ., ("tei-closer", css:map-rend-to-class(.)), .)
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
                                                        fo:pass-through(map:merge(($config, map:entry("template", true()))), ., ("tei-ptr", css:map-rend-to-class(.)), $content)
                        else
                            $config?apply($config, ./node())
                    case element(signed) return
                        if (parent::closer) then
                            fo:block($config, ., ("tei-signed1", css:map-rend-to-class(.)), .)
                        else
                            fo:inline($config, ., ("tei-signed2", css:map-rend-to-class(.)), .)
                    case element(list) return
                        fo:list($config, ., css:get-rendition(., ("tei-list", css:map-rend-to-class(.))), item, ())
                    case element(p) return
                        fo:paragraph($config, ., css:get-rendition(., ("tei-p2", css:map-rend-to-class(.))), .)
                    case element(q) return
                        if (l) then
                            fo:block($config, ., css:get-rendition(., ("tei-q1", css:map-rend-to-class(.))), .)
                        else
                            if (ancestor::p or ancestor::cell) then
                                fo:inline($config, ., css:get-rendition(., ("tei-q2", css:map-rend-to-class(.))), .)
                            else
                                fo:block($config, ., css:get-rendition(., ("tei-q3", css:map-rend-to-class(.))), .)
                    case element(epigraph) return
                        fo:block($config, ., ("tei-epigraph", css:map-rend-to-class(.)), .)
                    case element(pb) return
                        fo:omit($config, ., ("tei-pb", css:map-rend-to-class(.)), .)
                    case element(docTitle) return
                        fo:block($config, ., css:get-rendition(., ("tei-docTitle", css:map-rend-to-class(.))), .)
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
                                                fo:inline(map:merge(($config, map:entry("template", true()))), ., css:get-rendition(., ("tei-lb", css:map-rend-to-class(.))), $content)
                    case element(anchor) return
                        fo:anchor($config, ., ("tei-anchor", css:map-rend-to-class(.)), ., @xml:id)
                    case element(TEI) return
                        fo:document($config, ., ("tei-TEI", css:map-rend-to-class(.)), .)
                    case element(w) return
                        fo:inline($config, ., ("tei-w", css:map-rend-to-class(.)), .)
                    case element(stage) return
                        fo:block($config, ., ("tei-stage", css:map-rend-to-class(.)), .)
                    case element(titlePage) return
                        fo:block($config, ., css:get-rendition(., ("tei-titlePage", css:map-rend-to-class(.))), .)
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
                                                fo:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-name", css:map-rend-to-class(.)), $content)
                    case element(formula) return
                        if (@rendition='simple:display') then
                            fo:block($config, ., ("tei-formula1", css:map-rend-to-class(.)), .)
                        else
                            if (@rend='display') then
                                (: No function found for behavior: webcomponent :)
                                $config?apply($config, ./node())
                            else
                                (: No function found for behavior: webcomponent :)
                                $config?apply($config, ./node())
                    case element(front) return
                        fo:block($config, ., ("tei-front", css:map-rend-to-class(.)), .)
                    case element(lg) return
                        fo:block($config, ., ("tei-lg", css:map-rend-to-class(.)), .)
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
                                                        fo:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-choice1", css:map-rend-to-class(.)), $content)
                        else
                            if (sic and corr) then
                                fo:alternate($config, ., ("tei-choice2", css:map-rend-to-class(.)), ., corr[1], sic[1])
                            else
                                if (abbr and expan) then
                                    fo:alternate($config, ., ("tei-choice3", css:map-rend-to-class(.)), ., expan[1], abbr[1])
                                else
                                    if (orig and reg) then
                                        fo:alternate($config, ., ("tei-choice4", css:map-rend-to-class(.)), ., reg[1], orig[1])
                                    else
                                        $config?apply($config, ./node())
                    case element(publicationStmt) return
                        fo:omit($config, ., ("tei-publicationStmt2", css:map-rend-to-class(.)), .)
                    case element(hi) return
                        if (@rend='rot') then
                            fo:inline($config, ., ("tei-hi1", "red", css:map-rend-to-class(.)), .)
                        else
                            if (@rend='unterstrichen') then
                                fo:inline($config, ., ("tei-hi2", "underline", css:map-rend-to-class(.)), .)
                            else
                                if (@rend='rasur') then
                                    fo:inline($config, ., ("tei-hi3", "rasure", css:map-rend-to-class(.)), .)
                                else
                                    $config?apply($config, ./node())
                    case element(role) return
                        fo:block($config, ., ("tei-role", css:map-rend-to-class(.)), .)
                    case element(code) return
                        fo:inline($config, ., ("tei-code", css:map-rend-to-class(.)), .)
                    case element(note) return
                        if (@resp) then
                            fo:omit($config, ., ("tei-note1", css:map-rend-to-class(.)), .)
                        else
                            if (@type='Notiz') then
                                fo:inline($config, ., ("tei-note2", "note", css:map-rend-to-class(.)), .)
                            else
                                if (@type='Marginalie') then
                                    fo:inline($config, ., ("tei-note3", "marginalia", css:map-rend-to-class(.)), .)
                                else
                                    if (not(@type='Kapitelüberschrift')) then
                                        fo:inline($config, ., ("tei-note4", "note", css:map-rend-to-class(.)), .)
                                    else
                                        $config?apply($config, ./node())
                    case element(dateline) return
                        fo:block($config, ., ("tei-dateline", css:map-rend-to-class(.)), .)
                    case element(postscript) return
                        fo:block($config, ., ("tei-postscript", css:map-rend-to-class(.)), .)
                    case element(back) return
                        fo:block($config, ., ("tei-back", css:map-rend-to-class(.)), .)
                    case element(edition) return
                        if (ancestor::teiHeader) then
                            fo:block($config, ., ("tei-edition", css:map-rend-to-class(.)), .)
                        else
                            $config?apply($config, ./node())
                    case element(del) return
                        if (@hand='#sr') then
                            fo:inline($config, ., ("tei-del1", "del_sr", css:map-rend-to-class(.)), .)
                        else
                            fo:inline($config, ., ("tei-del2", "deleted", css:map-rend-to-class(.)), .)
                    case element(cell) return
                        (: Insert table cell. :)
                        fo:cell($config, ., ("tei-cell", css:map-rend-to-class(.)), ., ())
                    case element(div) return
                        if (@type='title_page') then
                            fo:block($config, ., ("tei-div1", css:map-rend-to-class(.)), .)
                        else
                            if (parent::body or parent::front or parent::back) then
                                fo:section($config, ., ("tei-div2", css:map-rend-to-class(.)), .)
                            else
                                fo:block($config, ., ("tei-div3", css:map-rend-to-class(.)), .)
                    case element(trailer) return
                        fo:block($config, ., ("tei-trailer", css:map-rend-to-class(.)), .)
                    case element(reg) return
                        if (@type='Synkope') then
                            fo:inline($config, ., ("tei-reg", "syncope", css:map-rend-to-class(.)), .)
                        else
                            $config?apply($config, ./node())
                    case element(graphic) return
                        fo:graphic($config, ., ("tei-graphic", css:map-rend-to-class(.)), ., @url, @width, @height, @scale, desc)
                    case element(ref) return
                        if (@target) then
                            fo:link($config, ., ("tei-ref1", css:map-rend-to-class(.)), ., @target, map {})
                        else
                            if (not(node())) then
                                fo:link($config, ., ("tei-ref2", css:map-rend-to-class(.)), @target, @target, map {})
                            else
                                fo:inline($config, ., ("tei-ref3", css:map-rend-to-class(.)), .)
                    case element(titlePart) return
                        fo:block($config, ., css:get-rendition(., ("tei-titlePart", css:map-rend-to-class(.))), .)
                    case element(ab) return
                        fo:paragraph($config, ., ("tei-ab", css:map-rend-to-class(.)), .)
                    case element(add) return
                        if (@hand="#sr") then
                            fo:inline($config, ., ("tei-add1", "sr", css:map-rend-to-class(.)), .)
                        else
                            fo:inline($config, ., ("tei-add2", "added", css:map-rend-to-class(.)), .)
                    case element(revisionDesc) return
                        fo:omit($config, ., ("tei-revisionDesc", css:map-rend-to-class(.)), .)
                    case element(subst) return
                        if (@hand[starts-with(., '#ls')]) then
                            fo:inline($config, ., ("tei-subst1", "subst_ls", css:map-rend-to-class(.)), .)
                        else
                            if (@hand[starts-with(., '#sr')]) then
                                fo:inline($config, ., ("tei-subst2", "subst_sr", css:map-rend-to-class(.)), .)
                            else
                                fo:inline($config, ., ("tei-subst3", "subst", css:map-rend-to-class(.)), .)
                    case element(head) return
                        if ($parameters?header='short') then
                            fo:inline($config, ., ("tei-head1", css:map-rend-to-class(.)), replace(string-join(.//text()[not(parent::ref)]), '^(.*?)[^\w]*$', '$1'))
                        else
                            if (parent::figure) then
                                fo:block($config, ., ("tei-head2", css:map-rend-to-class(.)), .)
                            else
                                if (parent::table) then
                                    fo:block($config, ., ("tei-head3", css:map-rend-to-class(.)), .)
                                else
                                    if (parent::lg) then
                                        fo:block($config, ., ("tei-head4", css:map-rend-to-class(.)), .)
                                    else
                                        if (parent::list) then
                                            fo:block($config, ., ("tei-head5", css:map-rend-to-class(.)), .)
                                        else
                                            if (parent::div) then
                                                fo:heading($config, ., ("tei-head6", css:map-rend-to-class(.)), ., count(ancestor::div))
                                            else
                                                fo:block($config, ., ("tei-head7", css:map-rend-to-class(.)), .)
                    case element(roleDesc) return
                        fo:block($config, ., ("tei-roleDesc", css:map-rend-to-class(.)), .)
                    case element(opener) return
                        fo:block($config, ., ("tei-opener", css:map-rend-to-class(.)), .)
                    case element(speaker) return
                        fo:block($config, ., ("tei-speaker", css:map-rend-to-class(.)), .)
                    case element(castGroup) return
                        if (child::*) then
                            (: Insert list. :)
                            fo:list($config, ., ("tei-castGroup", css:map-rend-to-class(.)), castItem|castGroup, ())
                        else
                            $config?apply($config, ./node())
                    case element(time) return
                        fo:inline($config, ., ("tei-time", css:map-rend-to-class(.)), .)
                    case element(bibl) return
                        if (parent::listBibl) then
                            fo:listItem($config, ., ("tei-bibl1", css:map-rend-to-class(.)), ., ())
                        else
                            fo:inline($config, ., ("tei-bibl2", css:map-rend-to-class(.)), .)
                    case element(imprimatur) return
                        fo:block($config, ., ("tei-imprimatur", css:map-rend-to-class(.)), .)
                    case element(salute) return
                        if (parent::closer) then
                            fo:inline($config, ., ("tei-salute1", css:map-rend-to-class(.)), .)
                        else
                            fo:block($config, ., ("tei-salute2", css:map-rend-to-class(.)), .)
                    case element(unclear) return
                        fo:inline($config, ., ("tei-unclear", css:map-rend-to-class(.)), .)
                    case element(argument) return
                        fo:block($config, ., ("tei-argument", css:map-rend-to-class(.)), .)
                    case element(date) return
                        fo:inline($config, ., ("tei-date2", css:map-rend-to-class(.)), .)
                    case element(title) return
                        if ($parameters?header='short') then
                            fo:heading($config, ., ("tei-title1", css:map-rend-to-class(.)), ., 5)
                        else
                            if (parent::titleStmt/parent::fileDesc) then
                                (
                                    if (preceding-sibling::title) then
                                        fo:text($config, ., ("tei-title2", css:map-rend-to-class(.)), ' — ')
                                    else
                                        (),
                                    fo:inline($config, ., ("tei-title3", css:map-rend-to-class(.)), .)
                                )

                            else
                                if (not(@level) and parent::bibl) then
                                    fo:inline($config, ., ("tei-title4", css:map-rend-to-class(.)), .)
                                else
                                    if (@level='m' or not(@level)) then
                                        (
                                            fo:inline($config, ., ("tei-title5", css:map-rend-to-class(.)), .),
                                            if (ancestor::biblFull) then
                                                fo:text($config, ., ("tei-title6", css:map-rend-to-class(.)), ', ')
                                            else
                                                ()
                                        )

                                    else
                                        if (@level='s' or @level='j') then
                                            (
                                                fo:inline($config, ., ("tei-title7", css:map-rend-to-class(.)), .),
                                                if (following-sibling::* and     (  ancestor::biblFull)) then
                                                    fo:text($config, ., ("tei-title8", css:map-rend-to-class(.)), ', ')
                                                else
                                                    ()
                                            )

                                        else
                                            if (@level='u' or @level='a') then
                                                (
                                                    fo:inline($config, ., ("tei-title9", css:map-rend-to-class(.)), .),
                                                    if (following-sibling::* and     (    ancestor::biblFull)) then
                                                        fo:text($config, ., ("tei-title10", css:map-rend-to-class(.)), '. ')
                                                    else
                                                        ()
                                                )

                                            else
                                                fo:inline($config, ., ("tei-title11", css:map-rend-to-class(.)), .)
                    case element(corr) return
                        if (parent::choice and count(parent::*/*) gt 1) then
                            (: simple inline, if in parent choice. :)
                            fo:inline($config, ., ("tei-corr1", css:map-rend-to-class(.)), .)
                        else
                            fo:inline($config, ., ("tei-corr2", "corr", css:map-rend-to-class(.)), .)
                    case element(foreign) return
                        fo:inline($config, ., ("tei-foreign", css:map-rend-to-class(.)), .)
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
                                                fo:pass-through(map:merge(($config, map:entry("template", true()))), ., ("tei-mei_mdiv", css:map-rend-to-class(.)), $content)
                    case element(cit) return
                        if (child::quote and child::bibl) then
                            (: Insert citation :)
                            fo:cit($config, ., ("tei-cit", css:map-rend-to-class(.)), ., ())
                        else
                            $config?apply($config, ./node())
                    case element(sic) return
                        if (parent::choice and count(parent::*/*) gt 1) then
                            fo:inline($config, ., ("tei-sic1", css:map-rend-to-class(.)), .)
                        else
                            fo:inline($config, ., ("tei-sic2", css:map-rend-to-class(.)), .)
                    case element(fileDesc) return
                        if ($parameters?header='short') then
                            (
                                fo:block($config, ., ("tei-fileDesc1", "header-short", css:map-rend-to-class(.)), titleStmt),
                                fo:block($config, ., ("tei-fileDesc2", "header-short", css:map-rend-to-class(.)), editionStmt),
                                fo:block($config, ., ("tei-fileDesc3", "header-short", css:map-rend-to-class(.)), publicationStmt),
                                (: Output abstract containing demo description :)
                                fo:block($config, ., ("tei-fileDesc4", "sample-description", css:map-rend-to-class(.)), ../profileDesc/abstract)
                            )

                        else
                            fo:title($config, ., ("tei-fileDesc5", css:map-rend-to-class(.)), titleStmt)
                    case element(titleStmt) return
                        fo:heading($config, ., ("tei-titleStmt2", css:map-rend-to-class(.)), ., ())
                    case element(body) return
                        (
                            fo:index($config, ., ("tei-body1", css:map-rend-to-class(.)), ., 'toc'),
                            fo:block($config, ., ("tei-body2", css:map-rend-to-class(.)), .)
                        )

                    case element(spGrp) return
                        fo:block($config, ., ("tei-spGrp", css:map-rend-to-class(.)), .)
                    case element(fw) return
                        if (ancestor::p or ancestor::ab) then
                            fo:inline($config, ., ("tei-fw1", css:map-rend-to-class(.)), .)
                        else
                            fo:block($config, ., ("tei-fw2", css:map-rend-to-class(.)), .)
                    case element(encodingDesc) return
                        fo:omit($config, ., ("tei-encodingDesc", css:map-rend-to-class(.)), .)
                    case element(gap) return
                        if (number(@extent)=1) then
                            let $params := 
                                map {
                                    "content": .
                                }

                                                        let $content := 
                                model:template-gap($config, ., $params)
                            return
                                                        fo:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-gap1", "gap", css:map-rend-to-class(.)), $content)
                        else
                            if (number(@extent)=2) then
                                let $params := 
                                    map {
                                        "content": .
                                    }

                                                                let $content := 
                                    model:template-gap2($config, ., $params)
                                return
                                                                fo:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-gap2", "gap", css:map-rend-to-class(.)), $content)
                            else
                                if (@reason="Fragmentverlust") then
                                    let $params := 
                                        map {
                                            "content": .
                                        }

                                                                        let $content := 
                                        model:template-gap3($config, ., $params)
                                    return
                                                                        fo:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-gap3", "fragment-loss", css:map-rend-to-class(.)), $content)
                                else
                                    if (@extent="unbekannt" or number(@extent)>=3) then
                                        let $params := 
                                            map {
                                                "content": .
                                            }

                                                                                let $content := 
                                            model:template-gap4($config, ., $params)
                                        return
                                                                                fo:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-gap4", "gap", css:map-rend-to-class(.)), $content)
                                    else
                                        let $params := 
                                            map {
                                                "content": .
                                            }

                                                                                let $content := 
                                            model:template-gap5($config, ., $params)
                                        return
                                                                                fo:inline(map:merge(($config, map:entry("template", true()))), ., ("tei-gap5", "gap", css:map-rend-to-class(.)), $content)
                    case element(quote) return
                        if (ancestor::p) then
                            (: If it is inside a paragraph then it is inline, otherwise it is block level :)
                            fo:inline($config, ., css:get-rendition(., ("tei-quote1", css:map-rend-to-class(.))), .)
                        else
                            (: If it is inside a paragraph then it is inline, otherwise it is block level :)
                            fo:block($config, ., css:get-rendition(., ("tei-quote2", css:map-rend-to-class(.))), .)
                    case element(notatedMusic) return
                        fo:figure($config, ., ("tei-notatedMusic", css:map-rend-to-class(.)), (ptr, mei:mdiv), label)
                    case element(seg) return
                        if (@subtype='nicht_ausgeführt') then
                            fo:inline($config, ., ("tei-seg1", "not-executed", css:map-rend-to-class(.)), .)
                        else
                            if (@type='Versumstellung') then
                                fo:inline($config, ., ("tei-seg2", "verse-change", css:map-rend-to-class(.)), .)
                            else
                                if (@type='kleine_Variante') then
                                    (: no special styles :)
                                    fo:inline($config, ., ("tei-seg3", "small-variant", css:map-rend-to-class(.)), .)
                                else
                                    if (@type='singuläre_Lesart') then
                                        (: no special styles :)
                                        fo:inline($config, ., ("tei-seg4", "singular-reading", css:map-rend-to-class(.)), .)
                                    else
                                        if (@type='große_Variante') then
                                            fo:inline($config, ., ("tei-seg5", "large-variant", css:map-rend-to-class(.)), .)
                                        else
                                            if (@subtype='Großinitiale') then
                                                fo:inline($config, ., ("tei-seg6", "capital-initial", css:map-rend-to-class(.)), .)
                                            else
                                                if (@subtype='Majuskel') then
                                                    fo:inline($config, ., ("tei-seg7", "majuscule", css:map-rend-to-class(.)), .)
                                                else
                                                    if (@subtype='Prachtinitiale') then
                                                        fo:inline($config, ., ("tei-seg8", "glory-initial", css:map-rend-to-class(.)), .)
                                                    else
                                                        if (@type='Initiale') then
                                                            fo:inline($config, ., css:get-rendition(., ("tei-seg9", "initial", css:map-rend-to-class(.))), .)
                                                        else
                                                            $config?apply($config, ./node())
                    case element(profileDesc) return
                        fo:omit($config, ., ("tei-profileDesc", css:map-rend-to-class(.)), .)
                    case element(row) return
                        if (@role='label') then
                            fo:row($config, ., ("tei-row1", css:map-rend-to-class(.)), .)
                        else
                            (: Insert table row. :)
                            fo:row($config, ., ("tei-row2", css:map-rend-to-class(.)), .)
                    case element(floatingText) return
                        fo:block($config, ., ("tei-floatingText", css:map-rend-to-class(.)), .)
                    case element(text) return
                        fo:body($config, ., ("tei-text", css:map-rend-to-class(.)), .)
                    case element(byline) return
                        fo:block($config, ., ("tei-byline", css:map-rend-to-class(.)), .)
                    case element(sp) return
                        fo:block($config, ., ("tei-sp", css:map-rend-to-class(.)), .)
                    case element(table) return
                        fo:table($config, ., ("tei-table", css:map-rend-to-class(.)), .)
                    case element(cb) return
                        fo:break($config, ., ("tei-cb", css:map-rend-to-class(.)), ., 'column', @n)
                    case element(group) return
                        fo:block($config, ., ("tei-group", css:map-rend-to-class(.)), .)
                    case element() return
                        if (namespace-uri(.) = 'http://www.tei-c.org/ns/1.0') then
                            $config?apply($config, ./node())
                        else
                            .
                    case text() | xs:anyAtomicType return
                        fo:escapeChars(.)
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
                    fo:escapeChars(.)
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

