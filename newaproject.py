# /usr/bin/env python 
# -*- encoding:utf-8 -*-

import os, sys 
import time
import inspect
import yaml
import logging


stream = file('lvmama.yaml', 'r')
lvmama = yaml.load(stream)
if lvmama['slag'] == 'A':
    ALL_project = lvmama['plugins'] if len(sys.argv) == 1 else sys.argv[1:]
elif lvmama['slag'] == 'N':
    ALL_project = ['tomcat', 'nginx'] 
else:
    ALL_project = ['tomcat'] 
ip_project = lvmama['ip_project']

log_file = 'install.log'
if not os.path.exists(log_file):
    os.mknod(log_file)
logging.basicConfig(
                        level = logging.DEBUG,
                        format = '%(asctime)s - %(levelname)s - %(message)s',
                        filename = log_file,
                        filemode = 'a',
                        )

def clean_status(args):
    l = []
    for status in args:
        if status.endswith('\n'):
            l.append(status.rstrip('\n'))
    l2 = [x for x in l if x != '']
    l2.sort()
    return l2

def record(func):
    def wrapper(*args, **kw):
        print('start installing %s' % func.__name__[8:])
        logging.info('start installing %s' % func.__name__[8:])
        func(*args, **kw)
        install_status_file = ip + name
        with open(install_status_file, 'a') as f:
            f.write(func.__name__[8:] + '\n')
        print('installing %s finished' % func.__name__[8:])
        logging.info('installing %s finished' % func.__name__[8:])
    return wrapper


class Project(object):
    def __init__(self, ip, name):
        self.ip = ip
        self.name = name
        self.should_install = []

    def check_status(self):
        self.install_status_file = self.ip + self.name
        if os.path.isfile(self.install_status_file):
            with open(self.install_status_file) as status_open:
                status = status_open.readlines()
            already_install = clean_status(status)
            # self.should_install = list(set(ALL_project)^set(already_install))
            self.should_install = [x for x in ALL_project if x not in already_install]
            ALL_project.sort()
            if already_install == ALL_project:
                print('All has installed, please check .')
                logging.info('All has installed, please check .')
            else:
                projects = ', '.join(self.should_install)
                print('Those {projects} has not installed yet . '.format(projects=projects))
                logging.info('Those {projects} has not installed yet . '.format(projects=projects))
        else:
            pass

    @record
    def install_tomcat(self):
        print('installing tomcat. ')
        # ret = os.cmd('/usr/bin/bash install_tomcat.sh')
        ret = 0
        if not ret:
            print('install tomcat success')

    @record
    def install_hosts(self):
        print('installing hosts. ')
        # ret = os.cmd('/usr/bin/bash install_hosts.sh')
        ret = 0
        if not ret:
            print('install hosts success')

    @record
    def install_iptables(self):
        print('installing iptables')
        # ret = os.cmd('/usr/bin/bash install_iptables.sh')
        ret = 0
        if not ret:
            print('install iptales success')

    def start(self):
        self.check_status()
        for func in inspect.getmembers(self, predicate=inspect.ismethod):
            if func[0][:7] == 'install':
                if func[0][8:] in self.should_install:
                    func[1]()
        return


if __name__ == '__main__':
    print(ip_project)
    for ip, name in ip_project.items():
        install_status_file_tag = ip + name
        if not os.path.exists(install_status_file_tag):
            os.mknod(install_status_file_tag)
        print(ip + ' ====> ' + name)
        logging.info(ip + '==>' + name)
        project = Project(ip, name)
        print('==start==')
        project.start()
        print('==end==')
        print('\n\n==========================\n\n')



