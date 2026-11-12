# DOI scripts

* Make the scripts executable
* Run them in `test` or `prod` mode:
    ```
    ./create-doi.sh test myusername mypassword
    
    ./create-doi.sh prod myusername mypassword
    ```
* or using an env var
    ```
    export DATACITE_PASSWORD="mypassword"
    
    ./create-doi.sh test myusername
    ```

            