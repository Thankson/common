###################################################################
# File Name: generate_pillar.py
# Author: deploy
# mail: deploy@lvmama.com
# Created Time: Tue 26 Sep 2017 07:02:37 PM CST
#=============================================================
#!/usr/bin/python

import difflib, sys, yaml
 
a = open('tomcat-quanfangzhen.txt', 'U').readlines()
b = open('tomcat-quanfangzhen.txtbak', 'U').readlines()
d = {}
l = []

f = open('top.sls')
dataMap = yaml.load(f)
f.close()

# int a
for line in difflib.unified_diff(a, b):
    #sys.stdout.write(line) 
    if line.startswith('-'):
        if line.startswith('--'):
            pass
	else:
            v, k = line[1:-1].split(' ')
            dataMap['base'][k] = ['pro_' + k.replace('.', '_')]
            #if not d[k]:
	    #    d[k] = []
            if d.has_key(k):
                pass
            else:
                d[k] = []
	    d[k].append(v)
            print d
	    #print k,v
            #d[k] = v
            #for v, k in line[1:-1].split(' '):
            #    print k, v
	    
# diff = difflib.ndiff(a, b)
# d = difflib.Differ()  
#diff = d.compare(a, b)  
#print '\n'.join(diff) 
# sys.stdout.writelines(diff)

print 'd - >', d
#print dataMap
f = open('newtree.yaml', "w")
yaml.dump(dataMap, f)
f.close()
