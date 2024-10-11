# Static backend for Parzival app(s)

## Principle

Data is generated using `src/generate.xsl` and served under `dist`.

In addition to this, the script also serves to fetch export files from the working environment (parzDB database). As fetching the nearly 900 files takes a while, it is recommended to execute the function only when needed (e.g. after significant data updates).

Lastly, the repository also contains a template for a TEIPublisher application (`src/teipb`) serving as a base for a `xar` file created during the CI procedures. This file is deployed at `https://dhbern.github.io/parzival-static-api/parzival-*.xar` and fetched by the pop-up publisher instance (see https://github.com/DHBern/presentation_parzival for more context).

## Usage

* Execute the wrapper script with one of two options:
  * `./parzival-static-api.sh --generate` to generate outputs for `dist/api`
  * `./parzival-static-api.sh --fetch-exports` to collect export files to `dist/api/export`

* Alternatively:
  * Move to `src` directory
  * Run `generate.xsl` with an XSLT processor (≥ 3.0).
    * (Optionally) supply tasks to be executed using the `do` parameter (multiple tasks may be given space separated within quotation marks).
    * (Optionally) set `verbose=true` to track the execution of the pipeline.
    * To run all tasks use `all=true` instead of `do`.
    * Example command: `java -jar $path-to-saxon/saxon-he-12.5.jar -s:generate.xsl -xsl:generate.xsl do='pass-through-originals contiguous-ranges`.

## Future options

* Consider CI using Github actions with Node.js and [`SaxonJS`](https://www.npmjs.com/package/saxon-js).
* Consider some degree of "dynamisation" using `SaxonJS`.
* Discern sensible and clear-cut border between static backend and TEIPublisher; how far can we push the border?
