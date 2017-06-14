# puppet-docker-test
Docker Testing for puppet control repo

Drop all files on your puppet-control-repo root folder.

You need to follow the hierarchy defined on hiera.yaml

For running tests:
```
./runtest.sh -t dev|prod -p project_name -a application_name -h fqdn_hostname -r role [-c /bin/bash|other_command]
```
