import module namespace m='http://www.tei-c.org/pm/models/parzival-verse-inline/web' at 'parzival-verse-inline-web.xql';

declare variable $xml external;

declare variable $parameters external;

let $options := map {
    "styles": ["transform/parzival-verse-inline.css"],
    "collection": "/db/apps/parzival/transform",
    "parameters": if (exists($parameters)) then $parameters else map {}
}
return m:transform($options, $xml)