# Monopsis (einzeltextedition.pdf)

This directory contains the workflow for generating the merged monopsis PDF (`einzeltextedition.pdf`) from locally stored source PDFs.

The input PDFs are not publicly accessible and must be present in `src/data/pdf/`.

The script is invoked from `parzival-static-api.sh --generate`.

## Installation steps

The monopsis PDF workflow requires Python and a small set of external dependencies.

1. Ensure Python 3 is available.

2. Install Ghostscript (system dependency):
  
  ```
  sudo apt install ghostscript
  ```

3. Create and activate a virtual environment (recommended):
  
  ```
  python3 -m venv .venv
  source .venv/bin/activate
  ```

4. Install Python dependencies:
  
  ```
  pip install -r requirements.txt
  ```

The workflow can then be executed via the wrapper script:
  
  ```
  ./parzival-static-api.sh --generate-monopsis
  ```
