[![Build Status](https://travis-ci.org/eapugo/Ansible-firewalld.svg?branch=master)](https://travis-ci.org/eapugo/Ansible-firewalld)

Ansible-Firewalld
=========
supports firewalld 0.4.0 and backward compatible for old ipset direct configuration
Allows firewalld rules to be added includes option for rich rules and ipset for optimization


Requirements
------------
Tested on RHEL 7.

Ansible =>1.5 

Role Variables
--------------
```
set_name:
set_name_list: serbianbots
```
```
default_zone:

fw_service:
   ssh: 
    state: enabled

fw_ports:
  8301:
    protocol: tcp
  5061:
    protocol: udp
#use {fw_port} when defining the same port for different protocols
fw_port:
  - port: 3000
    protocol: tcp
    state: enabled
  - port: 3000
    protocol: udp
    zone: internal
#family is default to ipv4
fw_richrule:
  - source: "192.168.0.0/24"
    service: "http"
    log_prefix: "rmtcmd"
    level: "info"
    rule: "reject"
    limit: "1/m"
    
#define an extended rich rule with a specific port or protocol
rich_rules:
  - rich_rule: 'rule family="ipv4" source address="192.168.2.4" drop'
    state: enabled
    permanent: true
```

Dependencies
------------

None

Example Playbook
----------------

Flags for permanent can be added with the 'persist' flag if not included it is persistent by default, this is also true for 'state'. 
```
    - hosts: servers
      roles:
         -  role: ansible-firewalld,
		   fw_services:
			https:
			  persist: true 
		        mysql:
			  zone: internal
		   fw_port:
                      - port: 8445
                        state: enabled
                        default_zone: app_vpn
```

To define a rich rule, use the 'rule' flag fw\_richrule for preset service rules and rich\_rules for custom rules . additional tips here [rich_rules](https://fedoraproject.org/wiki/Features/FirewalldRichLanguage)


To include an ipset or a file with a list of **ips** this can also be used to create a mangle for DSCP markings.
####dscp addon 
defaults are inet:ipv4,priority:0,chain:Output,target:DSCP; only requires "dscp\_hex or dscp\_class" to be defined. 
dscp_hex will take integers or hex
```
    direct_dscp:
        - dscp_class: "CS2"
          priority: 1
        - dscp_hex: "0x14"
          inet: "ipv6"
          destination: "2001:0558:502a::/40"
        - dscp_hex: "0x14"
          inet: ipv6
        - dscp_class: "AF32"
```
mandatory field here is `match_set`
####ipset addon
```
  direct_rule:
        - inet: ipv6
          chain: input
          priority: 1
          match_set: serbianbots
          direction: src
```


License
-------

BSD

Author Information
------------------
Emeka Apugo @cao5028@gmail.com
