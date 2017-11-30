clean_limit:
  cmd.run: 
    - name: 'rm -rf /tmp/restart_time*'

restart:
  cmd.run:
    - name: 'sh /opt/deploy_update_tomcat.sh ALL'
