add_ptest:
  cmd.run:
    - name: useradd ptest &&  echo lmm7QrY63U= |passwd ptest --stdin 
    - unless: cat /etc/passwd | grep ptest >/dev/nul

add_ptest_sudoers:
  file.append:
    - name: /etc/sudoers
    - text:
      - 'ptest   ALL=(ALL) NOPASSWD: DEVP, !/bin/*,!/usr/*,!/etc/*,/usr/java/jdk1.7.0_80/bin/*,/usr/local/nmon,/bin/kill,/usr/bin/sz,/usr/bin/jstack'
