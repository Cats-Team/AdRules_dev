#!/bin/bash
cd AdGuardRules/src

# Start Download
wget -O i1.txt https://filters.adtidy.org/android/filters/2.txt
wget -O i2.txt https://filters.adtidy.org/android/filters/11.txt
wget -O i3.txt https://filters.adtidy.org/android/filters/3.txt
wget -O i4.txt https://filters.adtidy.org/android/filters/224.txt
wget -O i5.txt https://filters.adtidy.org/android/filters/14.txt
wget -O i6.txt https://filters.adtidy.org/android/filters/5.txt
wget -O i7.txt https://filters.adtidy.org/android/filters/4.txt

# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' > tmpp.txt
sort tmpp.txt | uniq > tmp.txt
sort -n tmp.txt > tmmp.txt


# Start Count Rules
num=`cat tmmp.txt | wc -l`

# Start Add title and date
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmmp.txt > final.txt

mv final.txt ../../adguard.txt
rm *.txt
cd ../../
exit
