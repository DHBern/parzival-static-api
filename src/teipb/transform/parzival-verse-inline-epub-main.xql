import module namespace m='http://www.tei-c.org/pm/models/parzival-verse-inline/epub' at 'parzival-verse-inline-epub.xql';

declare variable $xml external;

declare variable $parameters external;

let $options := map {
    "styles": ["transform/parzival-verse-inline.css"],
    "collection": "/db/apps/parzival/transform",
    "parameters": if (exists($parameters)) then $parameters else map {}
}
return m:transform($options, $xml)