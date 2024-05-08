# Static backend for Parzival app(s)

## Principle

Data is generated using `src/generate.xsl` and served under `dist`.

## Usage

* Move to `src` directory
* Run `generate.xsl` with an XSLT processor (≥ 3.0).
  * (Optionally) supply tasks to be executed using the `do` parameter (multiple tasks may be given space separated within quotation marks).
  * (Optionally) set `verbose=true` to track the execution of the pipeline.
  * To run all tasks use `all=true` instead of `do`.
  * Example command: `java -jar $path-to-saxon/saxon-he-12.2.jar -s:generate.xsl -xsl:generate.xsl do='pass-through-originals contiguous-ranges`.
  
## Future options

* Consider CI using Github actions with Node.js and [`SaxonJS`](https://www.npmjs.com/package/saxon-js).
* Consider some degree of "dynamisation" using `SaxonJS`.
* Discern sensible and clear-cut border between static backend and TEIPublisher; how far can we push the border?
