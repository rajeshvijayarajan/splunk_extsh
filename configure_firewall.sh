# Open VxLAN port. Must be placed before all DROP/REJECT rules.
iptables -I INPUT -p udp -m udp --dport 8472 -m comment --comment "VxLAN tunnel port" -j ACCEPT 

