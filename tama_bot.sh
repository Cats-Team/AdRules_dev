#!/bin/bash

TOKEN=${{ secrets.TOKEN }}

CHAT_ID=${{ secrets.CHAT_ID }}

num_a=`cat adguard.txt | wc -l`
num_al=`cat allow.txt | wc -l`
num_A=`cat AdKillRules.txt | wc -l`
num_D=`cat DNS.txt | wc -l`
num=8
declare -i count_a=$num_a-$num
declare -i count_al=$num_al-$num
declare -i count_A=$num_A-$num
declare -i count_D=$num_D-$num
Time=`date +"%Y-%m-%d %H:%M:%S"`

FILE_a="adguard.txt"
FILE_A="AdKillRules.txt"
FILE_al="allow.txt"
FILE_D="DNS.txt"

MESSAGE="Newest Rules
allow 共计 $count_al 条,
DNS 共计 $count_D 条,
adguard 共计 $count_a 条,
AdKillRules 共计 $count_A 条,
Update at $Time."

URL="https://api.telegram.org/bot$TOKEN/sendMessage"

# URI="https://api.telegram.org/bot$TOKEN/snedDocument"

curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$MESSAGE"

# curl -s -X POST $URI -F chat_id=$CHAT_ID -F document=@"$FILE_a" > /dev/null
