opt-shells:
  file.managed:
    - name: /opt/shells.tar.gz
    - source: salt://init/opt_shells/files/shells.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /opt && tar zxf shells.tar.gz && rm -f shells.tar.gz
    - unless: test -d /opt/shells
