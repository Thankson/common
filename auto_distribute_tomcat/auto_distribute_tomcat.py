#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import re, shutil, os, logging, datetime, sys, time

# 还要去除 new_tomcat-quanfangzhen.txt 中的重复行
# 需要把 tomcat模板apache-tomcat-PROJECT restart_tomcat.sh stop.sh  放在 /srv/salt/fangzhen/tomcat 目录下


new_map = []
ips = []

log_path = './logs'
if not os.path.exists(log_path):
    os.makedirs(log_path)
logfilename = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
logging_file = os.path.join('./logs/%s.log'%logfilename)
logging.basicConfig(
                        level = logging.DEBUG,
                        format = '%(asctime)s - %(levelname)s - %(message)s',
                        filename = logging_file,
                        filemode = 'a',
                        )


initTomcatFile = lambda pro, cou, server_xml_file, catalina_sh_file:os.system(r'sed -i "/<\/Host>/i \        <Context\ displayName=\"%s\"\ docBase=\"\/var\/www\/webapps\/%s\"\ path=\"\/%s\"\ reloadable=\"false\">\n\        </Context>" %s'%(pro, pro, pro, server_xml_file))

def foo(ss):
    pattern = re.compile(r'\d+.\d+.\d+.\d+')
    match = pattern.search(ss)
    return match

def salt_run(tgt, cmd, arg=()):
    import salt.client as sc
    local = sc.LocalClient()  
    ret = local.cmd(tgt, cmd, arg)
    return ret

def initParam():
    # 要保证文本的最后一行为回车\n，否则会有点问题
    with open("new_tomcat-quanfangzhen.txt") as f:
        lines = f.readlines()
    for line in lines:
        ip_pre = foo(line)
        if ip_pre:
            ip = ip_pre.group()
            if ip in ips:
                new_map.append(line + str(ips.count(ip)))
                ips.append(ip)
            else:
                new_map.append(line + '0')
                ips.append(ip)
    print new_map
    return new_map

def startInstall(Info):
    for info in Info:
        qw = re.split('\s|\n|\t', info)
        pro, ip, cou = [x for x in qw if x]
        new_tomcat_na = 'apache-tomcat-' + pro.replace('_', '-')
        logging.info('>>>Starting cp tomcat %s......'%pro)

        if not os.path.exists('installed_project'):
            os.mknod('installed_project')
        with open('installed_project') as f:
            lines = f.readlines()
        al = pro + ip + '\n'
        if al in lines:
            continue

        ip_status = salt_run(ip, 'test.ping')
        if not ip_status:
            logging.info('>>>salt can not connect to %s, fail......'%ip)
            continue

        new_tomcat_name = '/srv/salt/fangzhen/tomcat/' + new_tomcat_na
        print 'new_tomcat_name', new_tomcat_name
        #if os.path.exists(new_tomcat_name):
        #    logging.info('>>>tomcat %s already exist, fail......'%pro)
        #    continue
        shutil.copytree("/srv/salt/fangzhen/tomcat/apache-tomcat-PROJECT", new_tomcat_name)
        #try:
        #    shutil.copytree("/srv/salt/fangzhen/tomcat/apache-tomcat-PROJECT", new_tomcat_name)
        #    logging.info('>>>cp tomcat %s ok......'%pro)
        #except OSError, e:
        #    logging.info('>>>no tomcat model exist, please prepare apache-tomcat-PROJECT, cp tomcat %s fail......'%pro)

        os.system('sync')
        os.system('sync')
        time.sleep(10)
        print os.listdir('/srv/salt/fangzhen/tomcat/')
            
        server_xml_file = new_tomcat_name + '/conf' + '/server.xml'
        catalina_sh_file = new_tomcat_name + '/bin' + '/catalina.sh'
        # 修改server.xml Context
        if '_' in pro:
            p = pro.split('-')
            for project in p:
                project = project
                initTomcatFile(project, cou, server_xml_file, catalina_sh_file)
        else:
            project = pro
            initTomcatFile(project, cou, server_xml_file, catalina_sh_file)
            #initTomcatFile()

        # 修改server.xml port
        ret = os.system(r'sed -i "22s/PORT1/%s/" %s'%(str(9080 + int(cou)), server_xml_file))
        if not ret:
            logging.info('>>>change tomcat %s PORT1 ok......'%server_xml_file)
        else:
            logging.info('>>>change tomcat %s PORT1 fail......'%server_xml_file)
            

        ret = os.system(r'sed -i "70s/PORT2/%s/" %s'%(str(8080 + int(cou)), server_xml_file))
        if not ret:
            logging.info('>>>change tomcat %s PORT2 ok......'%server_xml_file)
            logging.info('>>>This %s tomcat at %s port is %s......'%(pro, ip, str(8080 + int(cou))))
        else:
            logging.info('>>>change tomcat %s PORT2 fail......'%server_xml_file)
            

        # 修改 catalina_sh port
        ret = os.system(r'sed -i "42s/PORT3/%s/" %s'%(str(12345 + int(cou)), catalina_sh_file))
        if not ret:
            logging.info('>>>change tomcat %s PORT3 ok......'%catalina_sh_file)
        else:
            logging.info('>>>change tomcat %s PORT3 fail......'%catalina_sh_file)
            
        # 修改 catalina.sh free_conf
        sys_free = salt_run(ip, 'grains.item', ['mem_total'])
        sf = sys_free[ip]['mem_total']
        sf = sf / 1024 + 1
        if sf > 16:
            catalina_x = '8'
        else:
            catalina_x = '4'
        ret = os.system(r'sed -i "112s/Xmx8G/Xmx"%s"G/" %s'%(catalina_x, catalina_sh_file))
        if not ret:
            logging.info('>>>change tomcat %s Xmx ok......'%catalina_sh_file)
        else:
            logging.info('>>>change tomcat %s Xmx fail......'%catalina_sh_file)
            
        ret = os.system(r'sed -i "112s/Xms8G/Xms"%s"G/" %s'%(catalina_x, catalina_sh_file))
        if not ret:
            logging.info('>>>change tomcat %s Xms ok......'%catalina_sh_file)
        else:
            logging.info('>>>change tomcat %s Xms fail......'%catalina_sh_file)

        # 修改 catalina.sh hostname
        local_ip = salt_run(ip, 'grains.item', ['fqdn_ip4'])
        local_ip = local_ip[ip]['fqdn_ip4'][0]
	print local_ip
        ret = os.system(r'sed -i "42s/IP/%s/" %s'%(local_ip, catalina_sh_file))
        if not ret:
            logging.info('>>>change tomcat %s catalina.sh_hostname ok......'%catalina_sh_file)
        else:
            logging.info('>>>change tomcat %s catalina.sh_hostname fail......'%catalina_sh_file)
            
        
        ret = os.system(r'rsync -vzrtopgl --progress --password-file=/etc/rsyncd.passwd %s  lvmama_web@%s::opt/'%(new_tomcat_name, ip))
        if not ret:
            logging.info('>>>deploy tomcat %s%s ok......'%(pro, ip))
        else:
            logging.info('>>>deploy tomcat %s%s fail......'%(pro, ip))
            continue
        '''
        source_dir = 'salt://fangzhen/tomcat/%s/'%new_tomcat_na
        dest_dir = '/opt/'
        print source_dir, dest_dir
        cp_tomcat = salt_run(ip, 'cp.get_dir', [source_dir, dest_dir]) 
        if cp_tomcat[ip]:
            logging.info('>>>deploy tomcat okzeng...... %s%s'%(pro, ip))
        else:
            logging.info('>>>deploy tomcat failqing...... %s%s'%(pro, ip))
        
        os.system('sync')
        os.system('sync')
        time.sleep(5)
        
        cp_restart_tomcat = salt_run(ip, 'cp.get_file', ['salt://fangzhen/tomcat/restart_tomcat.sh', '/opt/restart_tomcat.sh']) 
        if cp_restart_tomcat[ip]:
            logging.info('>>>deploy restart_tomcat_script %s ok......'%pro)
        else:
            logging.info('>>>deploy restart_tomcat_script %s %s fail......'%(pro))

        cp_stop_tomcat = salt_run(ip, 'cp.get_file', ['salt://fangzhen/tomcat/stop_tomcat.sh', '/opt/stop_tomcat.sh']) 
        if cp_stop_tomcat[ip]:
            logging.info('>>>deploy stop_tomcat_script %s ok......'%pro)
        else:
            logging.info('>>>deploy stop_tomcat_script %s fail......'%pro)
        '''
        try:
            ret = shutil.rmtree(new_tomcat_name)
            logging.info('>>>FINISH INSTALL %s,delete tomcat %s ok......'%(pro, new_tomcat_name))
        except OSError,e:
            logging.info('>>>FINISH INSTALL %s,delete tomcat %s fail......'%(pro, new_tomcat_name))
            
        installed = open('installed_project', 'a')
        print >> installed, pro + ip
        installed.close()

        logging.info('----------------------seprate line----------------------------')

if __name__ == '__main__':
    logging.info('Starting install tomcat......')
    logging.info('##########################')
    par = initParam()
    startInstall(par)
    logging.info('##########################')
    logging.info('Finish install all tomcat......')
