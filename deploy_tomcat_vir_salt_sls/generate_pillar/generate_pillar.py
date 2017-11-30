# -*- encoding:utf-8 -*-

import os, shutil

tqfz_file_path = './tomcat-quanfangzhen.txt'
tqfzi_bak_file_path = '%sbak'%tqfz_file_path

with open (tqfz_file_path) as tq:
    tqs = tq.readlines()

with open (tqfzi_bak_file_path) as tqb:
    tqsb = tqb.readlines()

#result = list(set(tqs) ^ set(tqsb))
#print result


ret = [ i for i in tqs if i not in tqsb ]
ret = [i.split() for i in ret]
tmp = {}
l = []
def foo(a):
    l = []
    l.append(a)
    return l
for v in ret:
    tmp[v[1]] = tmp.get(v[1]) and tmp[v[1]] + (foo(v[0])) or foo(v[0])
ret= [ [k, v] for (k, v) in tmp.items() ]
#print ret

topfile = 'base:\n  '
for val in ret:
    #print val
    filename = 'pro_' + val[0].replace('.', '_')
    topfile += val[0] + ':\n    - ' + filename + '\n    - mem\n  '

    project = 'project:\n'
    for i in val[1]:
        project += '  - ' + i + '\n'
    #print project 
    with open('%s.sls'%filename, 'w') as f:
        f.write(project)

#print topfile
with open('top.sls', 'w') as f:
    f.write(topfile)

os.remove(tqfzi_bak_file_path)
shutil.copy2(tqfz_file_path, tqfzi_bak_file_path)
