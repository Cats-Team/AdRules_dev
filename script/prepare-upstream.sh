#!/bin/bash

#source /etc/profile

#cd $(cd "$(dirname "$0")";pwd)
mkdir -p ./tmp/
cd tmp
easylist=(
  "https://easylist-downloads.adblockplus.org/easylist.txt"
  "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
  "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt"
  "https://easylist.to/easylist/fanboy-annoyance.txt"
  "https://easylist.to/easylist/easyprivacy.txt"
  "https://raw.githubusercontent.com/reek/anti-adblock-killer/master/anti-adblock-killer-filters.txt"
  "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt"
  "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjxlist.txt"
  "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
  "https://easylist-downloads.adblockplus.org/easyprivacy.txt"
  "https://cats-team.coding.net/p/adguard/d/AdRules/git/raw/main/adblock.txt"
  "https://cats-team.coding.net/p/adguard/d/AdRules/git/raw/main/dns.txt"
)

hosts=(
  "https://raw.githubusercontent.com/neoFelhz/neohosts/gh-pages/full/hosts.txt"
  "https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts"
  "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
)

strict_hosts=(
  "https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt"
  "https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser"
)

dead_hosts=(
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/domains.dead.txt"
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/hostnames.dead.txt"
)

curl --connect-timeout 60 -s -o - https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanProgramAD.list \
 | grep -F 'DOMAIN-SUFFIX,' | sed 's/DOMAIN-SUFFIX,/127.0.0.1 /g' >./hosts999.txt
curl --connect-timeout 60 -s -o - https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanAD.list \
 | grep -F 'DOMAIN-SUFFIX,' | sed 's/DOMAIN-SUFFIX,/127.0.0.1 /g' >./hosts998.txt


for i in "${!easylist[@]}"
do
  echo "开始下载 easylist${i}..."
  curl -k -o "easylist${i}.txt" --connect-timeout 60 -s "${easylist[$i]}" &
  # shellcheck disable=SC2181
  if [ $? -ne 0 ];then
    echo '下载失败，请重试'
    exit 1
  fi
done
wait
for i in "${!hosts[@]}"
do
  echo "开始下载 hosts${i}..."
  curl -k -o "hosts${i}.txt" --connect-timeout 60 -s "${hosts[$i]}" &
  # shellcheck disable=SC2181
  if [ $? -ne 0 ];then
    echo '下载失败，请重试'
    exit 1
  fi
done
wait
for i in "${!strict_hosts[@]}"
do
  echo "开始下载 strict-hosts${i}..."
  curl -k -o "strict-hosts${i}.txt" --connect-timeout 60 -s "${strict_hosts[$i]}" &
  # shellcheck disable=SC2181
  if [ $? -ne 0 ];then
    echo '下载失败，请重试'
    exit 1
  fi
done
wait
for i in "${!dead_hosts[@]}"
do
  echo "开始下载 dead-hosts${i}..."
  curl -k -o "dead-hosts${i}.txt" --connect-timeout 60 -s "${dead_hosts[$i]}" &
  # shellcheck disable=SC2181
  if [ $? -ne 0 ];then
    echo '下载失败，请重试'
    exit 1
  fi
done
wait

cat hosts*.txt | grep -v -E "^((#.*)|(\s*))$" \
 | grep -v -E "^[0-9\.:]+\s+(ip6\-)?(localhost|loopback)$" \
 | sed s/0.0.0.0/127.0.0.1/g | sed s/::/127.0.0.1/g | sort \
 | uniq >base-src-hosts.txt

cat strict-hosts*.txt | grep -v -E "^((#.*)|(\s*))$" \
 | grep -v -E "^[0-9\.:]+\s+(ip6\-)?(localhost|loopback)$" \
 | sed s/0.0.0.0/127.0.0.1/g | sed s/::/127.0.0.1/g | sort \
 | uniq >base-src-strict-hosts.txt

cat dead-hosts*.txt | grep -v -E "^(#|\!)" \
 | sort \
 | uniq >base-dead-hosts.txt


cat easylist*.txt | grep -E "^\|\|[^\/\^]+\^" | sort | uniq >base-src-easylist.txt
cat easylist*.txt | grep -E "^\|\|?([^\^=\/:]+)?\*([^\^=\/:]+)?\^" | sort | uniq >wildcard-src-easylist.txt
cat easylist*.txt | grep -E "^@@\|\|?[^\^=\/:]+?\^([^\/=\*]+)?$" | sort | uniq >whiterule-src-easylist.txt

cd ../
