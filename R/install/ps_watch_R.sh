#!/usr/bin/env bash

watch "{  top -b | head -15; echo "_____"; vmstat; echo; \
          free -m | sed -e 's/\([0-9]\)[^0-9]/\1M/g' | sed -e 's/\([0-9]\)$/\1M/g'; \
          echo; iostat | tail -n4; \
          ps --forest -o pid,pcpu,size,stat,wchan,cmd -g `pidof rserver`; }"





