#!/bin/bash

for var in "$@"
do
    if [ "$IS_HOST" == "true" ]; then
        HOST=$var
    fi

    if [ "$var" == "--host" ]; then
        IS_HOST=true
    else
        IS_HOST=false
    fi
done

COUNTER=0
echo -n "waiting for $HOST to start up..."
trap 'exit' INT
while [  $COUNTER -lt ${CHECK_ATTEMPTS} ]; do
    let COUNTER=COUNTER+1
    if `curl -s $HOST | grep -q 'Welcome to Kong'`; then
        echo "started"
        sleep ${POST_START_DELAY}
        break
    else
        echo -n "."
    fi
    sleep ${BETWEEN_START_DELAY}
done

kongfig "$@"
