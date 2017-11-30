#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import socket
import os, sys, time, re
import fileinput
from multiprocessing import Pool

'''测试环境在 10.200.4.210 机器上的 /root/jen 目录下
需要收集各个工程在各自机器上所占用的端口号，供 # while not port_check(ip, 8020): 这行使用
配合的 jenkinsjob http://192.168.0.72/jenkins/view/%E5%88%86%E9%94%80--%E5%91%A8%E4%B8%80/job/test_fzrestart/
'''

def server_start(ip, project, arg=()):
    import salt.client as sc
    local = sc.LocalClient()
    cmdstart = 'bash /opt/deploy_update_tomcat.sh %s'%project
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


if __name__=='__main__':
    p = Pool()
    alljobs = [x.strip('"') for x in sys.argv][1:]
    for i in alljobs:
        p.apply_async(start_queue, args=(i,))
    print 'Start starting all chosed project...'
    p.close()
    p.join()
    print 'All projects started.'