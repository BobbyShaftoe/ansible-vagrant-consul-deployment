#!/usr/bin/env bash

SERVER="$1"

[ -z "$SERVER" ] && { echo 127; exit 127; }

curl "http://${SERVER}" &>/dev/null && { echo 0; exit 0; }

{ echo 1; exit 1; } 

