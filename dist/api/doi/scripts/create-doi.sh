#!/bin/bash

set -u

# Check parameters
if [[ $# -lt 2 || $# -gt 3 ]]; then
    echo "Usage: $0 <test|prod> <username> [password]"
    echo "Alternatively, supply the password via DATACITE_PASSWORD."
    exit 1
fi

MODE="$1"
USERNAME="$2"
PASSWORD="${3:-${DATACITE_PASSWORD:-}}"

# Check password
if [[ -z "$PASSWORD" ]]; then
    echo "Error: No password supplied."
    exit 1
fi

# Select API endpoint
case "$MODE" in
    test)
        API_URL="https://api.test.datacite.org/dois"
        ;;
    prod)
        API_URL="https://api.datacite.org/dois"
        ;;
    *)
        echo "Error: Mode must be 'test' or 'prod'."
        exit 1
        ;;
esac

# Create authentication header
AUTH_HEADER=$(printf '%s' "$USERNAME:$PASSWORD" | base64 | tr -d '\n')

CONTENT_TYPE_HEADER="Content-Type: application/vnd.api+json"

# Process files
while IFS= read -r file || [[ -n "$file" ]]; do

    # Skip empty lines and comments
    [[ -z "$file" || "$file" == \#* ]] && continue

    if [[ -f "$file" ]]; then
        printf "\nProcessing file: %s\n" "$file"

        curl --fail-with-body -sS -X POST \
            -H "$CONTENT_TYPE_HEADER" \
            -H "Authorization: Basic $AUTH_HEADER" \
            -d @"$file" \
            "$API_URL"

        echo
    else
        echo "File not found: $file"
    fi

done < file-list.txt