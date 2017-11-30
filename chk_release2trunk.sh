#!/bin/bash
branches(){
release_end=`svn info http://10.200.3.7/svn/$1/release/trunk |grep Revision |awk '{print $2}'`		//5385
release_start=`svn log -v  --stop-on-copy  http://10.200.3.7/svn/$1/release/trunk | grep \| | awk '{print $1}' |cut -b 2- |tail -n 1`	//5044
date=`date  -d"tomorrow" +"%F"`			//2017-01-23
date_start=`svn log -v  --stop-on-copy  http://10.200.3.7/svn/$1/release/trunk | grep \| | awk '{print $5}' |tail -n 1`		//2016-12-19
release_ID=`svn log  -r "$release_start":"$release_end" http://10.200.3.7/svn/$1/release/trunk/ | grep \| |awk  '{print $1}' |cut -b 2-|grep -v $release_start`	
trunk_ID=`svn log -r {"$date_start"}:{"$date"}  http://10.200.3.7/svn/$1/trunk | grep release\/trunk | awk '{print $4}'`
iFlag=0
for i in $release_ID
do
xx="$1/release分支 版本:$i 未合并"
 echo $trunk_ID |grep "http"  >/dev/null
  if [ $? == 0 ];then
    trunk_ID=`svn log -r {"$date_start"}:{"$date"}  http://10.200.3.7/svn/$1/trunk | grep release\/trunk | awk '{print $4}' | grep -v "http"`
    release=`svn log  -r "$release_start":"$release_end" http://10.200.3.7/svn/$1/release/trunk/ |grep  trunk -B3|sed -n '2p' | awk '{print $1}' |cut -b 2- `
    trunk=`svn log -r {"$date_start"}:{"$date"}  http://10.200.3.7/svn/$1/trunk | grep release\/trunk| grep @ |awk -F@ '{print $3}'`
    ID="$release":"$trunk"
  fi
  for o in $trunk_ID $ID
   do
     echo $o |grep ":"  >/dev/null
     if [ $? == 0 ];then
        a=`echo "$o" |awk -F: '{print $1}'`
        b=`echo "$o" |awk -F: '{print $2}'`
          if [ "$i" -ge  "$a" ] && [ "$i" -le "$b" ];then 
             xx="$1/release分支 版本:$i 已合并"
             iFlag=1
          fi
     elif [ "$i" == "$o" ] ;then 
             xx="$1/release分支 版本:$i 已合并"
             iFlag=1
     fi
   done
   if [ $iFlag == 0 ];then
      echo -e  "  $xx +++++++++ 请注意"
   else
     echo -e  "  $xx..."
   fi
   iFlag=0
done     
}

for i in versatile focus super channel cmt o2o prodcal dest seo
do
branches $i
done

svn log  -r 5044:5385 http://10.200.3.7/svn/o2o/branches/o2o_ship | grep \| |awk  '{print 'o2o'}' |cut -b 2-|grep -v 5044
