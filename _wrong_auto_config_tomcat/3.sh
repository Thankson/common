###################################################################
# File Name: 3.sh
# Author: deploy
# mail: deploy@lvmama.com
# Created Time: Thu 24 Aug 2017 01:09:52 PM CST
#=============================================================
#!/bin/bash

sed -i 's/\(port="\).*\(" shutdown="SHUTDOWN"\)/\1'$1'\2/g' ./tmp/$2/*/conf/server.xml
sed -i 's/\(port="\).*\(" protocol="HTTP\/1.1"\)/\1'$3'\2/g' ./tmp/$2/*/conf/server.xml								       

sed -i 's/\(jmxremote.port=\).*\(" -Dcom.sun.management\)/\1'$4'\2/g' ./tmp/$2/*/bin/catalina.sh								       
sed -i 's/\(-Xmx\).*\( -Xms\)/\1'2G'\2/g' ./tmp/$2/*/bin/catalina.sh								       
sed -i 's/\(-Xms\).*\( -Xss\)/\1'2G'\2/g' ./tmp/$2/*/bin/catalina.sh								       
