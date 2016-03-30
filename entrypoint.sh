#!/usr/bin/env bash

/logstash.sh &
/kibana.sh &

gosu elasticsearch elasticsearch "$@"
