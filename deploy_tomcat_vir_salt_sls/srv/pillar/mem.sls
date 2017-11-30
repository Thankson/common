{% if grains['mem_total']/1024 > 16 %} 
jdk_mem_size: 8
{% elif grains['mem_total']/1024 <= 16 %} 
jdk_mem_size: 4
{% endif %}
