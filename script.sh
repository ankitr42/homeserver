#!/bin/bash

a=1
for i in *.*; do
  new=$(printf "%02d" "$a")
  new="$new - $(echo $i | cut -c 5-)"
  echo "$i -> S${1}E${new}"
  let a=a+1
done

echo "Do operation? [y/n] "
read confirm

if [ "$confirm" = "y" ]; then
  a=1
  for i in *.*; do
    new=$(printf "%02d" "$a")
    new="$new - $(echo $i | cut -c 5-)"
    mv -v "$i" "S${1}E${new}"
    let a=a+1
  done
  echo "done"
else
    echo "cancelled"
fi
