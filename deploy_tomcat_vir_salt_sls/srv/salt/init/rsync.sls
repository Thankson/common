/etc/rsyncd.conf:
  file.managed:
    - source: salt://test/rsync/rsyncd.conf
    - mode: 644
    - user: root
    - group: root

/etc/rsyncd.passwd:
  file.managed:
    - source: salt://test/rsync/rsyncd.passwd
    - mode: 600
    - user: root
    - group: root

/etc/rsyncd.secrets:
  file.managed:
    - source: salt://test/rsync/rsyncd.secrets
    - mode: 600
    - user: root
    - group: root

rsync-install:
  pkg.installed:
    - names:
      - rsync
      - lrzsz
  cmd.run:
    - name: rm -rf /var/run/rsyncd.pid && rsync --daemon
    - unless: netstat -anp |grep 873
