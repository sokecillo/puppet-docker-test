#!/bin/bash

function usage {
    echo "$(basename $0) usage: "
    echo "    -t apptier Example: dev|pro"
    echo "    -p project Example: project_name"
    echo "    -a application Example: app_name"
    echo "    -h hostname Example: fqdn_hostname"
    echo "    -r role Example: appserver"
    echo "    [-c command] Example: /bin/bash"
    echo ""
    exit 1
}

COMMAND="/test.sh"

while [[ $# -gt 1 ]]
do
    key="$1"
    case $key in
        -t)
        APPTIER="$2"
        shift
        ;;
        -p)
        PROJECT="$2"
        shift
        ;;
        -a)
        APPLICATION="$2"
        shift
        ;;
        -h)
        HOST="$2"
        shift
        ;;
        -r)
        ROLE="$2"
        shift
        ;;
        -c)
        COMMAND="$2"
        shift
        ;;
        *)
        usage
        shift
        ;;
    esac
    shift
done

[ ! -z ${APPTIER} ] && \
[ ! -z ${PROJECT} ] && \
[ ! -z ${APPLICATION} ] && \
[ ! -z ${HOST} ] &&
[ ! -z ${ROLE} ] || usage

code=0

docker stop puppet_test
docker rm puppet_test
docker build --build-arg APPTIER=${APPTIER} \
             --build-arg PROJECT=${PROJECT} \
             --build-arg APPLICATION=${APPLICATION} \
             --build-arg ROLE=${ROLE} \
             -t puppet_test .
docker run -it -h ${HOST} --name puppet_test puppet_test:latest ${COMMAND}
if [ $? -ne 0 ]
then
    code=$?
fi

exit ${code}
