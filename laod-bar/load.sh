#!/bin/sh

count=0
bar="["
while [ $count -lt 10 ]; do
  sleep .1
  count=$((count + 1))
  bar="$bar"$"|"
done
bar="$bar ]"    
printf "%s\n" "$bar"
echo

