#!/bin/bash

PILLAR_PATH=.

#project=`grep -vwf tomcat-quanfangzhen.txtbak tomcat-quanfangzhen.txt`
#project=`diff tomcat-quanfangzhen.txt tomcat-quanfangzhen.txtbak`
project=`grep -F -v -f tomcat-quanfangzhen.txtbak  tomcat-quanfangzhen.txt | sort | uniq`
#ips=`echo $project | awk '{cnt="";for(i=1;i<=NF;i+=2){cnt=cnt$i" "$(i+1)":";} print cnt}'`
#ips=`echo $project | awk '{cnt="";for(i=1;i<=NF;i+=2){cnt=$i" "$(i+1)};printf("%s,aaa\n"),$cnt}'`
echo $project
echo $project | awk '{for(i=1;i<=NF;i+=2){cnt=" ";cnt=$i"eee"$(i+1);printf("%s,\n"),$cnt}}'
#p_i=`echo $ips | awk -F ":"`
#echo $p_i
#echo -e $ips
#echo $project
