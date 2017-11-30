###################################################################
# File Name: 2.sh
# Author: deploy
# mail: deploy@lvmama.com
# Created Time: Thu 24 Aug 2017 11:18:39 AM CST
#=============================================================
#!/bin/bash


all_project=`awk '{print $1}' tomcat-quanfangzhen.txt | uniq`

for i in ${all_project[@]}
do
  p=`grep $i tomcat-quanfangzhen.txt | sed -n '1p'`
  echo $p >> 2.txt
done
