# puppet-docker-test
Docker Testing for puppet control repo

Drop both sh and Dockerfile on your puppet-control-repo root folder.

For running tests:
```
./runtest.sh -t dev|prod -p project_name -a application_name -h fqdn_hostname -r role [-c /bin/bash|other_command]
```
