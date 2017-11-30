#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import socket
import os, sys, time, re
import fileinput
from multiprocessing import Pool

def server_start(ip, project, arg=()):
    import salt.client as sc
    local = sc.LocalClient()
    #cmdstart = 'bash /opt/deploy_update_tomcat.sh'
    cmdstart = 'bash /opt/apache-tomcat-tnt-front/bin/startup.sh'
    ret = local.cmd(ip, 'cmd.run', [cmdstart])
    print ret

def port_check(ip, port):
    sk = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sk.settimeout(1)
    try:
        sk.connect((ip,port))
        print 'Server port %s OK!'%port
        ret = True
    except Exception:
        print 'Server port %s not connect!'%port
        ret = False
    sk.close()
    return ret

def start_queue(project):
    ips = []
    pattern = "^%s$"%project
    for line in fileinput.input('tomcat-quanfangzhen.txt', inplace=False, mode='r'):
    	if re.search(pattern, line.split()[1]):
    		ip = line.split()[0]
    		ips.append(ip)
    print "Begin to start %s ..."%project
    for ip in ips:
        print ip
        server_start(ip, project)
        while not port_check(ip, 8020):
            time.sleep(2)
            print 'waiting...'

#def foo2(name):
#    print "Begin to start %s ..."%name

if __name__=='__main__':
    p = Pool()
    alljobs = ["tnt_front", "tnt_front2"]
    for i in alljobs:
#        func = start_queue(i) 
        p.apply_async(start_queue, args=(i,))
    print 'Start starting all chosed project...'
    p.close()
    p.join()
    print 'All projects started.'

#a = start_queue("tnt_front")
#a()
#server_start('10.200.4.183','aa')
