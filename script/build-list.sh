#!/bin/bash

#source /etc/profile

#cd $(cd "$(dirname "$0")";pwd)
chmod -x ./*/prepare-upstream.sh
bash ./*/prepare-upstream.sh
cd script
php make-addr.php
#php ./adguard-extend.php ../anti-ad-adguard.txt
php ./adguard-extend.php tmp/base-src-easylist.txt
php ./easylist-extend.php tmp/base-src-easylist.txt
