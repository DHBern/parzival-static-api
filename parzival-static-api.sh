#!/bin/bash
#
# parzival-static-api
# ===================
#
# This is a simple wrapper script for the java command that generates the output files.
# Start this script with an option and the required parameters from within the command line.
#
# With parzival-static-api you can do the following:
#
# Generate output files
# ---------------------
#
# Set option `--generate` / `-g`
#
# and argument `do=` with one of:
#
#   pass-through-originals	: Copies all original TEI files (as received from editors) to dist.
#   flatten-originals		:
#   contiguous-ranges		: Generate information on contiguously extant Dreissiger by document.
#   metadata-ms-page		: Generate information on manuscript pages.
#   extract-fragment-metadata	: Extract naming information from files.
#
# or argument `all=` with value
#
#   true			: Run all these actions.
#
# Fetch export files
# ------------------
#
# Set option `--fetch-exports` / `-f` (without parameters)
#
# In addition to the generation of the output files, the script also serves to fetch export files
# from the working environment (parzDB database). As fetching the nearly 900 files takes a while,
# it is recommended to execute the function only when needed (e.g. after significant data updates).
#
# Summary:
# -----------------------
# * execute `parzival-static-api.sh --generate` to generate outputs to the `dist` directory
# * execute `parzival-static-api.sh --fetch-exports` to collect all export files (pdf/tex/tustep/txt)
#


# Supply path to Saxon executable.
SAXON='/opt/Saxonica/SaxonHE12-5/saxon-he-12.5.jar'

# functions
function generate {
  echo "Generating static API files to 'dist' directory."
  echo "Using Saxon at ${SAXON}."
  exec java -jar $SAXON -s:src/generate.xsl -xsl:src/generate.xsl do='' verbose=false "$@"
}

function fetchExports {

  # Last file to be fetched (set "827" for all files)
  UNTIL=827

  echo "Fetching export files."
  echo && echo "PDF…"
  curl --limit-rate 50k "https://parzival.unibe.ch/parzdb/parzival.php?page=pdf&dreissiger=[1-${UNTIL}]" \
    --output dist/api/export/pdf/fass-#1.pdf --create-dirs
  echo && echo "LaTeX…"
  curl --limit-rate 50k "https://parzival.unibe.ch/parzdb/parzival.php?page=latex&dreissiger=[1-${UNTIL}]" \
    --output dist/api/export/latex/fass-#1.tex --create-dirs
  echo && echo "Tustep…"
  curl --limit-rate 50k "https://parzival.unibe.ch/parzdb/parzival.php?page=tustep&dreissiger=[1-${UNTIL}]" \
    --output dist/api/export/tustep/syn#1_4f.tustep --create-dirs

  echo && echo "Text exports…"

  declare -a fass=("D" "m" "G" "T")

  for i in "${fass[@]}"
  do
    echo && echo "  Fassung $i"
    payload=$(echo "vc=Fassung:+*$i+[*$i]")
    curl --data "$payload" "https://parzival.unibe.ch/parzdb/parzival.php?page=txtexport" \
      --output dist/api/export/text/Fass__$i.txt --create-dirs
  done

  declare -a hss=("D+[D]" "m+[mk]" "n+[nk]" "o+[ok]" "G+[G]" "I+[I]" "L+[L]" "M+[M]" "O+[O]" "Q+[Q]" "R+[R]" \
    "T+[T]" "U+[U]" "V+[V]" "V'+[VV]" "W+[W]" "Z+[Z]" "T¹+[T1]")

  # add 72 fragments to the hss array
  for i in $(seq 1 72);
  do
    hss+=("Fr$i+[Fr$i]")
  done

  for i in "${hss[@]}"
  do
    echo && echo "  Handschrift $i"
    payload=$(echo "vc=Handschrift:+*$i")
    isubst=$(echo $i| cut -d "[" -f2 | cut -d "]" -f1)
    curl --data "$payload" "https://parzival.unibe.ch/parzdb/parzival.php?page=txtexport" \
      --output dist/api/export/text/hs_$isubst.txt --create-dirs
  done

  echo "Done fetching."
}

### Argument parsing / conditional function calls

case "$1" in
  -g | --generate )
    shift # do not pass the first argument ("generate")
    generate "$@" 2>&1 | tee -a logfile.log
    ;;
  -f | --fetch-exports )
    fetchExports 2>&1 | tee -a logfile.log
    ;;
  *)
    echo "Argument missing (supply --generate or --fetch-exports)."
    ;;
esac
