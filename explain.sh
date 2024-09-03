#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: explain <command>"
  exit 1
fi

output_f=$RANDOM

{ "$@" 2>&1 ; } > "/tmp/output_$output_f" &

wait $!

sed -i ':a;N;$!ba;s/\n/ /g' /tmp/output_$output_f 
output=$(<"/tmp/output_$output_f")

/usr/bin/curl -s -H 'Content-Type: application/json' -X POST -d '{"model":"dolphin-mixtral:8x7b-v2.5-q3_K_M","prompt":"'"${output}"'","stream":false}' http://10.0.0.225:11434/api/generate | jq -r '.response'

rm "/tmp/output_$output_f"
