terraform {
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "itds_shrd_srv_isftp_rg" {
  name = "${var.env_prefix_hypon}-shrd-srv-isftp-rg"
  location = "${var.env_location}"
}

resource "azurerm_management_lock" "itds_rg_lk" {
  name = "${var.env_prefix_hypon}-shrd-rg-lk"
  scope = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.id}"
  lock_level = "CanNotDelete"
  notes = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name} resource group can not be deleted"
  count = "${var.env_disable_lk}"
}

data "template_file" "itds_shrd_srv_isftp_cint_scpt" {
  template = "${file("${path.module}/cloud-init.yml")}"
  vars = {
    service_name = "isftp"
    docker_registry_admin = "${var.itds_shrd_srv_acr_admn}"
    docker_registry_admin_password = "${var.itds_shrd_srv_acr_admn_pswd}"
    docker_registry_server = "${var.itds_shrd_srv_acr_srvr}"
    docker_repository = "${var.itds_shrd_srv_acr_repo}"
    docker_repository_tag = "${var.itds_shrd_srv_acr_repo_tg}"
  }
}

data "template_cloudinit_config" "itds_shrd_srv_isftp_cint_conf" {
  part {
    content_type = "text/cloud-config"
    content = "${data.template_file.itds_shrd_srv_isftp_cint_scpt.rendered}"
  }
}

resource "azurerm_network_security_group" "itds_shrd_srv_isftp_nsg" {
  name = "${var.env_prefix_hypon}-shrd-srv-isftp-nsg"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"
  location = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.location}"
}

resource "azurerm_network_security_rule" "itds_shrd_srv_isftp_nsg_ib_rl" {
  name = "${var.env_prefix_underscore}_shrd_srv_isftp_nsg_ibnd_rl_${var.shrd_srv_isftp_nsg_ibnd_rl[count.index] == "*" ? "all" : var.shrd_srv_isftp_nsg_ibnd_rl[count.index]}"
  priority = "${count.index+100}"
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "${var.shrd_srv_isftp_nsg_ibnd_rl[count.index]}"
  source_address_prefix = "${var.shrd_srv_isftp_nsg_ibnd_rl_src_pfx[count.index]}"
  destination_address_prefix = "${var.shrd_srv_isftp_nsg_ibnd_rl_dst_pfx[count.index]}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.itds_shrd_srv_isftp_nsg.name}"
  count = "${length(var.shrd_srv_isftp_nsg_ibnd_rl)}"
}

resource "azurerm_network_security_rule" "itds_shrd_srv_isftp_nsg_ob_rl" {
  name = "${var.env_prefix_underscore}_shrd_srv_isftp_nsg_obnd_rl_${var.shrd_srv_isftp_nsg_obnd_rl[count.index] == "*" ? "all" : var.shrd_srv_isftp_nsg_obnd_rl[count.index]}"
  priority = "${count.index+100}"
  direction = "Outbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "${var.shrd_srv_isftp_nsg_obnd_rl[count.index]}"
  source_address_prefix = "${var.shrd_srv_isftp_nsg_obnd_rl_src_pfx[count.index]}"
  destination_address_prefix = "${var.shrd_srv_isftp_nsg_obnd_rl_dst_pfx[count.index]}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.itds_shrd_srv_isftp_nsg.name}"
  count = "${length(var.shrd_srv_isftp_nsg_obnd_rl)}"
}

resource "azurerm_subnet" "itds_shrd_srv_isftp_snet" {
  name = "${var.env_prefix_hypon}-shrd-srv-isftp-snet"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name = "${var.vnet_rg_name}"
  address_prefix = "${var.shrd_srv_isftp_snet_addr_pfx}"
}

resource "azurerm_subnet_network_security_group_association" "itds_shrd_srv_isftp_snet_nsg_asso" {
  subnet_id = "${azurerm_subnet.itds_shrd_srv_isftp_snet.id}"
  network_security_group_id = "${azurerm_network_security_group.itds_shrd_srv_isftp_nsg.id}"
}

resource "azurerm_public_ip" "itds_shrd_srv_isftp_pip" {
  name = "${var.env_prefix_hypon}-shrd-srv-isftp-pip"
  location = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"
  allocation_method = "Static"
}

resource "azurerm_lb" "itds_shrd_srv_isftp_lb" {
  name = "${var.env_prefix_hypon}-shrd-srv-isftp-lb"
  location = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"

  frontend_ip_configuration {
    name = "${var.env_prefix_hypon}-shrd-srv-isftp-lb-fic"
    private_ip_address = "${var.shrd_srv_isftp_lb_istat_ip}"
    subnet_id = "${azurerm_subnet.itds_shrd_srv_isftp_snet.id}"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "itds_shrd_srv_isftp_lb_addr_pl" {
  name = "${var.env_prefix_hypon}-shrd-srv-isftp-lb-addr-pl"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"
  loadbalancer_id = "${azurerm_lb.itds_shrd_srv_isftp_lb.id}"
}

resource "azurerm_availability_set" "itds_shrd_srv_isftp_aset" {
  name = "${var.env_prefix_hypon}-shrd-srv-isftp-aset"
  location = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"
  managed = "true"
}

resource "azurerm_lb_probe" "itds_shrd_srv_isftp_lb_prb" {
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"
  loadbalancer_id = "${azurerm_lb.itds_shrd_srv_isftp_lb.id}"
  name = "shrd-srv-isftp-lb-prb-prt-${var.shrd_srv_isftp_lb_prb_prt[count.index]}"
  port = "${var.shrd_srv_isftp_lb_prb_prt[count.index]}"
  count = "${length(var.shrd_srv_isftp_lb_prb_prt)}"
}

resource "azurerm_lb_rule" "itds_shrd_srv_isftp_lb_rl" {
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"
  loadbalancer_id = "${azurerm_lb.itds_shrd_srv_isftp_lb.id}"
  name = "${var.env_prefix_hypon}-shrd-srv-isftp-lb-rl-${var.shrd_srv_isftp_lb_fnt_prt[count.index] == "*" ? "all" : var.shrd_srv_isftp_lb_fnt_prt[count.index]}"
  protocol = "Tcp"
  frontend_port = "${var.shrd_srv_isftp_lb_fnt_prt[count.index]}"
  backend_port = "${var.shrd_srv_isftp_lb_bck_prt[count.index]}"
  frontend_ip_configuration_name = "${var.env_prefix_hypon}-shrd-srv-isftp-lb-fic"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.itds_shrd_srv_isftp_lb_addr_pl.id}"
  probe_id = "${element(azurerm_lb_probe.itds_shrd_srv_isftp_lb_prb.*.id, count.index)}"
  count = "${length(var.shrd_srv_isftp_lb_fnt_prt)}"
}


resource "azurerm_network_interface" "itds_shrd_srv_isftp_vm_nic" {
  name = "${var.env_prefix_hypon}-shrd-srv-isftp-vm-${count.index}-nic"
  location = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"
  ip_configuration {
    name = "${var.env_prefix_hypon}-shrd-srv-isftp-vm-${count.index}-ipc"
    subnet_id = "${azurerm_subnet.itds_shrd_srv_isftp_snet.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "${element(var.shrd_srv_isftp_vm_ip, count.index)}"
  }
  count = "${length(var.shrd_srv_isftp_vm_ip)}"
}

resource "azurerm_network_interface_backend_address_pool_association" "itds_shrd_srv_isftp_vm_nic_lb_addr_pl_asso" {
  ip_configuration_name = "${var.env_prefix_hypon}-shrd-srv-isftp-vm-${count.index}-ipc"
  network_interface_id = "${element(azurerm_network_interface.itds_shrd_srv_isftp_vm_nic.*.id, count.index)}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.itds_shrd_srv_isftp_lb_addr_pl.id}"
  count = "${length(var.shrd_srv_isftp_vm_ip)}"
}

resource "azurerm_virtual_machine" "itds_shrd_srv_isftp_vm" {
  name = "${var.shrd_srv_isftp_vm_nm[count.index]}"
  location = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"
  network_interface_ids = [
    "${element(azurerm_network_interface.itds_shrd_srv_isftp_vm_nic.*.id, count.index)}"]
  vm_size = "${var.shrd_srv_isftp_vm["vm_size"]}"
  availability_set_id = "${azurerm_availability_set.itds_shrd_srv_isftp_aset.id}"
  delete_os_disk_on_termination = false
  storage_image_reference {
    publisher = "${var.shrd_srv_isftp_vm["vm_img_publisher"]}"
    offer = "${var.shrd_srv_isftp_vm["vm_img_offer"]}"
    sku = "${var.shrd_srv_isftp_vm["vm_img_sku"]}"
    version = "${var.shrd_srv_isftp_vm["vm_img_ver"]}"
  }
  storage_os_disk {
    name = "${var.env_prefix_hypon}-shrd-srv-isftp-vm-${count.index}-os-dsk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name = "${var.shrd_srv_isftp_vm_hst_nm[count.index]}"
    admin_username = "${var.shrd_srv_isftp_vm_adm}"
    admin_password = "${var.shrd_srv_isftp_vm_pswd}"
    custom_data = "${data.template_cloudinit_config.itds_shrd_srv_isftp_cint_conf.rendered}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  count = "${length(var.shrd_srv_isftp_vm_ip)}"
}

resource "azurerm_managed_disk" "itds_shrd_srv_isftp_vm_mg_dsk" {
  name = "${var.env_prefix_hypon}-shrd-srv-isftp-vm-${count.index}-mg-dsk"
  location = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_isftp_rg.name}"
  storage_account_type = "${var.shrd_srv_isftp_vm["vm_mg_dsk_ty"]}"
  create_option = "Empty"
  disk_size_gb = "${var.shrd_srv_isftp_vm["vm_mg_dsk_sz"]}"
  count = "${length(var.shrd_srv_isftp_vm_ip)}"
}

resource "azurerm_virtual_machine_data_disk_attachment" "itds_shrd_srv_isftp_vm_dsk_attch" {
  managed_disk_id = "${element(azurerm_managed_disk.itds_shrd_srv_isftp_vm_mg_dsk.*.id, count.index)}"
  virtual_machine_id = "${element(azurerm_virtual_machine.itds_shrd_srv_isftp_vm.*.id, count.index)}"
  lun = "10"
  caching = "ReadWrite"
  count = "${length(var.shrd_srv_isftp_vm_ip)}"
}