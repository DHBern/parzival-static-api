module namespace pml='http://www.tei-c.org/pm/models/parzival-verse-inline/latex/module';

import module namespace m='http://www.tei-c.org/pm/models/parzival-verse-inline/latex' at 'parzival-verse-inline-latex.xql';

(: Generated library module to be directly imported into code which
 : needs to transform TEI nodes using the ODD this module is based on.
 :)
declare function pml:transform($xml as node()*, $parameters as map(*)?) {

   let $options := map {
    "class": "article",
    "section-numbers": false(),
    "font-size": "11pt",
       "styles": ["transform/parzival-verse-inline.css"],
       "collection": "/db/apps/parzival/transform",
       "parameters": if (exists($parameters)) then $parameters else map {}
   }
   return m:transform($options, $xml)
};