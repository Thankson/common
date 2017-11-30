/data/:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedir: True
/data/appdatas/:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedir: True
/data/appdatas/cat:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedir: True
/data/applogs/:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedir: True
/data/applogs/cat:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedir: True
/tmp/create_new_client_xml.sh:
  file.managed:
    - source: salt://test/create_new_client_xml.sh
    - mode: 755 
    - user: root
    - group: root
/data/appdatas/cat/client.xml:
  file.managed:
    - source: salt://test/client.xml
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: python /opt/shells/generate_tomcat_info.py /opt
make_client.xml:
  cmd.run:
    - name: sh /tmp/create_new_client_xml.sh
