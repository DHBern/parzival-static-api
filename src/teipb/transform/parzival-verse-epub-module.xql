module namespace pml='http://www.tei-c.org/pm/models/parzival-verse/epub/module';

import module namespace m='http://www.tei-c.org/pm/models/parzival-verse/epub' at 'parzival-verse-epub.xql';

(: Generated library module to be directly imported into code which
 : needs to transform TEI nodes using the ODD this module is based on.
 :)
declare function pml:transform($xml as node()*, $parameters as map(*)?) {

   let $options := map {
       "styles": ["transform/parzival-verse.css"],
       "collection": "/db/apps/parzival/transform",
       "parameters": if (exists($parameters)) then $parameters else map {}
   }
   return m:transform($options, $xml)
};