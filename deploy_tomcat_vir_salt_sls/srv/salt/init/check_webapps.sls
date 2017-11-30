
/var/www/:
  file.directory:
    - user: nobody
    - group: nobody
    - mode: 755
    - makedir: True
    - recurse:
      - user
      - group
      - mode

/var/www/webapps:
  file.directory:
    - user: nobody
    - group: nobody
    - mode: 755
    - makedir: True
    - recurse:
      - user
      - group
      - mode

/opt/:
  file.directory:
    - user: nobody
    - group: nobody
