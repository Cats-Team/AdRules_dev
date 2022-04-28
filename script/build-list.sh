#!/bin/bash

#source /etc/profile

#cd $(cd "$(dirname "$0")";pwd)
chmod -x ./*/prepare-upstream.sh
bash ./*/prepare-upstream.sh
cd script
php make-addr.php
echo "!Title: anti-AD for AdGuard" > ../anti-ad-adguard.txt
echo "!Version: $(date "+%Y%m%d%H%M%S%N")" >> ../anti-ad-adguard.txt
echo "!Homepage: https://anti-ad.net/" >> ../anti-ad-adguard.txt
echo "!!!note! If you are using \"AdGuard Home\", please load https://anti-ad.net/easylist.txt" >> ../anti-ad-adguard.txt
echo "!Total lines: 00000" >> ../anti-ad-adguard.txt
grep -v '^!' ../anti-ad-easylist.txt >> ../anti-ad-adguard.txt
#php ./adguard-extend.php ../anti-ad-adguard.txt
php ./easylist-extend.php ../anti-ad-easylist.txt
