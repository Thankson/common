/etc/hosts:
  file.managed:
    - source: salt://init/hosts/files/hosts
    - user: root
    - group: root
    - mode: 622
    - template: jinja
    - defaults:
      IP: {{ salt['grains.get']('fqdn_ip4')[0] }}
      HOSTNAME: {{ salt['grains.get']('host') }}
