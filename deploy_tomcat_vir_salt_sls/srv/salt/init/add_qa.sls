add_qa:
  cmd.run:
    - name: useradd qa &&  echo 111111 |passwd qa --stdin 
    - unless: cat /etc/passwd | grep qa >/dev/nul

add_qa_sudoers:
  file.append:
    - name: /etc/sudoers
    - text:
      - 'Cmnd_Alias DEVP = /opt/apache-tomcat-*/logs/'
      - 'qa   ALL=(ALL) NOPASSWD: DEVP, !/bin/*,!/usr/*,!/etc/*,/usr/bin/tail'
