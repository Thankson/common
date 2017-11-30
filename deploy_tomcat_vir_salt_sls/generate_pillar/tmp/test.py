###################################################################
# File Name: test.py
# Author: deploy
# mail: deploy@lvmama.com
# Created Time: Tue 26 Sep 2017 07:40:22 PM CST
#=============================================================
#!/usr/bin/python

# coding:utf-8
import sys

reload(sys)
sys.setdefaultencoding('utf8')

import yaml

f = open('top.sls')
dataMap = yaml.load(f)
f.close()
print dataMap
dataMap['base']['aaa'] = 'bbb'
print dataMap

'''
dataMap = {'base': {'10.201.1.134': ['a', 'b'], '10.201.1.134': ['a', 'b']}}
#dataMap = {'treeroot': {'branch2': {'branch2-1': {'name': 'Node 2-1'}, 'name': 'Node 2'}, 'branch1': {'branch1-1': {'name': 'Node 1-1'}, 'name': 'Node 1'}}}

f = open('newtree.yaml', "w")
yaml.dump(dataMap, f)
f.close()
'''
