#!/bin/bash
port=22
user=ubuntu
echo
echo "Please enter the cmd you want execute"
read cmd
echo
for i in $(echo $1 | sed "s/,/ /g")
do
echo "Output after executing the cmd on $i"
ssh -p $port $user@$i $cmd
echo
done
