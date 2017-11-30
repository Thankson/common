crontab-install:
  pkg.installed:
    - names:
      - ntpdate
      - crontabs

clean_cron:
  cmd.run:
    - name: echo '' > /var/spool/cron/root

/root/scripts/:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedir: True
    - recurse:
      - user
      - group
      - mode

/root/scripts/cut_log.sh:
  file.managed:
    - source: salt://test/cut_log.sh
    - mode: 644
    - user: root
    - group: root

/root/scripts/delete_tomcat_logs_files.py:
  file.managed:
    - source: salt://test/delete_tomcat_logs_files.py
    - mode: 644
    - user: root
    - group: root

/root/scripts/lock_classes_single.sh :
  file.managed:
    - source: salt://test/lock_classes_single.sh 
    - mode: 644
    - user: root
    - group: root

ntp_cron:
  cron.present:
    - name: /usr/sbin/ntpdate 192.168.0.7 > /dev/null
    - user: root
    - hour: '*/4'

cut_log_cron:
  cron.present:
    - name: /bin/sh /root/scripts/cut_log.sh > /dev/null
    - user: root
    - hour: '00'
    - minute: '01'

dele_log_cron:
  cron.present:
    - name: /usr/bin/python /root/scripts/delete_tomcat_logs_files.py Yes >/dev/null 2>&1
    - user: root
    - hour: '01'
    - minute: '01'

lock_classes_cron:
  cron.present:
    - name: /bin/sh /var/www/webapps/lock_classes_single.sh > /dev/null
    - user: root
    - hour: '*/4'
