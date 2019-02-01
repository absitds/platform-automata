#environment details
env_name = "DevOps"
env_location = "West US"
env_group = "ITDS"
env_admins = "dadam47,ashin14"
env_prefix_hypon = "itds-dops-wus"
env_prefix_underscore = "itds_dops_wus"
env_prefix_alph_num = "ItdsDopsWus"

#vnet details
vnet_name = "Abs-ITDS-DevOps"
vnet_rg_name = "Abs-ITDS-DevOps"
vnet_address_space = "172.21.40.0/23"
vnet_start_ip = "172.21.40.0"
vnet_end_ip = "172.21.41.255"

#storage account details
shsrv_sa = "absitdsdopswus001"

#terraform details
#Subnet address	- 172.21.40.0/28
#Netmask - 255.255.255.240	
#Range of addresses - 172.21.40.0 - 172.21.40.15
#Useable IPs - 172.21.40.5 - 172.21.40.14
#Hosts - 14
tf_snet_address_prefix = "172.21.40.0/28"

#edge nodes details
#Subnet address	- 172.21.40.16/28	
#Netmask - 255.255.255.240	
#Range of addresses - 172.21.40.16 - 172.21.40.31	
#Useable IPs - 172.21.40.20 - 172.21.40.30	
#Hosts - 14
shrd_srv_edge_snet_addr_pfx = "172.21.40.16/28"

#artifactory details
#Subnet address	- 172.21.40.32/27	
#Netmask - 255.255.255.224	
#Range of addresses - 172.21.40.32 - 172.21.40.63	
#Useable IPs - 172.21.40.36 - 172.21.40.62	
#Hosts - 30
shrd_srv_artif_snet_addr_pfx = "172.21.40.32/27"

#jenkins details
#Subnet address	- 172.21.40.64/27	
#Netmask - 255.255.255.224	
#Range of addresses - 172.21.40.64 - 172.21.40.95	
#Useable IPs - 172.21.40.68 - 172.21.40.94	
#Hosts - 30
shrd_srv_jnkns_snet_addr_pfx = "172.21.40.64/27"


shsrv_acr = "absitdsdopsacr001"



