#!/bin/bash

i=3
while [[ i -lt 40 ]] ; do
  ./part1.rb input.txt $i > log.txt
  if [[ $? -eq 0 ]] ; then
    echo "attack power: $i"
    tail -3 log.txt
    exit
  fi
  i=$((i+1))
done
