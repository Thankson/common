/usr/java:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedir: True

/usr/java/jdk-7u80-linux-x64.tar.gz:
  file.managed:
    - source: salt://test/jdk-7u80-linux-x64.tar.gz
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: tar -xvf /usr/java/jdk-7u80-linux-x64.tar.gz -C /usr/java/
    - unless: test -d /usr/java/jdk1.7.0_80

/usr/java/jdk1.7.0_80:
   file.directory:
    - user: root
    - group: root

jdk_profile:
  file.append:
    - name: /etc/profile
    - text:
      - JAVA_HOME=/usr/java/jdk1.7.0_80
      - PATH=$JAVA_HOME/bin:$PATH
      - CLASSPATH=$JAVA_HOME/lib
      - export JAVA_HOME PATH CLASSPATH
