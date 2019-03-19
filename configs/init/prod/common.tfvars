#environment details
env_name = "Prod"
env_location = "West US"
env_group = "ITDS"
env_admins = "dadam47,ashin14"

env_prefix_hypon = "itds-prod-wus"
env_prefix_underscore = "itds_prod_wus"
env_prefix_alph_num = "ItdsProdWus"

#VNet details
#CIDR Range	172.21.16.0/20
#Netmask	255.255.240.0
#Widlcard Bits	0.0.15.255
#First IP	172.21.16.0
#Last IP	172.21.31.255
#Total Host	4096
vnet_name = "Abs-ITDS-Prod"
vnet_rg_name = "Abs-ITDS-Prod"
vnet_address_space = "172.21.16.0/20"
vnet_start_ip = "172.21.16.0"
vnet_end_ip = "172.21.31.255"

#Terraform Storage account details
#CIDR Range	172.21.16.0/28
#Netmask	255.255.255.240
#Widlcard Bits	0.0.0.15
#First IP	172.21.16.0
#Last IP	172.21.16.15
#Total Host	16
tf_snet_address_prefix = "172.21.40.0/28"

#CIDR Range	172.21.16.16/28
#Netmask	255.255.255.240
#Widlcard Bits	0.0.0.15
#First IP	172.21.16.16
#Last IP	172.21.16.31
#Total Host	16
edge_snet_addr_pfx = "172.21.40.16/28"


#if value is zero then no lock is created
env_disable_lk = 0


