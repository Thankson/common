{% for pro in pillar['project'] %} 
/opt/apache-tomcat-{{ pro }}:   
  file.recurse:  
    - source: salt://init/tomcat/files/apache-tomcat-PROJECT
    - user: root
    - group: root
    - file_mode: 644  
    - dir_mode: 755  
    - include_empty: Ture 
    - unless: test -d /opt/apache-tomcat-{{ pro }}

update_server_xml{{ pro }}:
  file.managed:
    - name: /opt/apache-tomcat-{{ pro }}/conf/server.xml
    - source: salt://init/tomcat/files/server.xml
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - PORT1: {{ 9079+loop.index }}
    - PORT2: {{ 8079+loop.index }}
    - PROJECT_NAME: {{ pro }}
    - require:
      - file: /opt/apache-tomcat-{{ pro }}

update_catalina_sh{{ pro }}:
  file.managed:
    - name: /opt/apache-tomcat-{{ pro }}/bin/catalina.sh
    - source: salt://init/tomcat/files/catalina.sh
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - IP: {{ grains['fqdn_ip4'][0] }}
    - SIZE1: {{ pillar['jdk_mem_size'] }}
    - SIZE2: {{ pillar['jdk_mem_size'] }}
    - PORT3: {{ 12344+loop.index }}
    - require:
      - file: /opt/apache-tomcat-{{ pro }}
{% endfor %}
