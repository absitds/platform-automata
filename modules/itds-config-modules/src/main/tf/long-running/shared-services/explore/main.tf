terraform {
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "itds_shrd_srv_explr_rg" {
  name = "${var.env_prefix_hypon}-shrd-srv-explr-rg"
  location = "${var.env_location}"
}

resource "azurerm_management_lock" "itds_rg_lk" {
  name = "${var.env_prefix_hypon}-shrd-rg-lk"
  scope = "${azurerm_resource_group.itds_shrd_srv_explr_rg.id}"
  lock_level = "CanNotDelete"
  notes = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name} resource group can not be deleted"
}


data "template_file" "itds_shrd_srv_explr_cint_scpt" {
  template = "${file("${path.module}/cloud-init.yml")}"
}

data "template_cloudinit_config" "itds_shrd_srv_explr_cint_conf" {
  part {
    content_type = "text/cloud-config"
    content = "${data.template_file.itds_shrd_srv_explr_cint_scpt.rendered}"
  }
}

resource "azurerm_network_security_group" "itds_shrd_srv_explr_nsg" {
  name = "${var.env_prefix_hypon}-shrd-srv-explr-nsg"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"
  location = "${azurerm_resource_group.itds_shrd_srv_explr_rg.location}"
}

resource "azurerm_network_security_rule" "itds_shrd_srv_explr_nsg_ib_rl" {
  name = "${var.env_prefix_underscore}_shrd_srv_explr_nsg_ibnd_rl_${var.shrd_srv_explr_nsg_ibnd_rl[count.index] == "*" ? "all" : var.shrd_srv_explr_nsg_ibnd_rl[count.index]}"
  priority = "${count.index+100}"
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "${var.shrd_srv_explr_nsg_ibnd_rl[count.index]}"
  source_address_prefix = "${var.shrd_srv_explr_nsg_ibnd_rl_src_pfx[count.index]}"
  destination_address_prefix = "${var.shrd_srv_explr_nsg_ibnd_rl_dst_pfx[count.index]}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.itds_shrd_srv_explr_nsg.name}"
  count = "${length(var.shrd_srv_explr_nsg_ibnd_rl)}"
}

resource "azurerm_network_security_rule" "itds_shrd_srv_explr_nsg_ob_rl" {
  name = "${var.env_prefix_underscore}_shrd_srv_explr_nsg_obnd_rl_${var.shrd_srv_explr_nsg_obnd_rl[count.index] == "*" ? "all" : var.shrd_srv_explr_nsg_obnd_rl[count.index]}"
  priority = "${count.index+100}"
  direction = "Outbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "${var.shrd_srv_explr_nsg_obnd_rl[count.index]}"
  source_address_prefix = "${var.shrd_srv_explr_nsg_obnd_rl_src_pfx[count.index]}"
  destination_address_prefix = "${var.shrd_srv_explr_nsg_obnd_rl_dst_pfx[count.index]}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.itds_shrd_srv_explr_nsg.name}"
  count = "${length(var.shrd_srv_explr_nsg_obnd_rl)}"
}

resource "azurerm_subnet" "itds_shrd_srv_explr_snet" {
  name = "${var.env_prefix_hypon}-shrd-srv-explr-snet"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name = "${var.vnet_rg_name}"
  address_prefix = "${var.shrd_srv_explr_snet_addr_pfx}"
}

resource "azurerm_subnet_network_security_group_association" "itds_shrd_srv_explr_snet_nsg_asso" {
  subnet_id = "${azurerm_subnet.itds_shrd_srv_explr_snet.id}"
  network_security_group_id = "${azurerm_network_security_group.itds_shrd_srv_explr_nsg.id}"
}

resource "azurerm_public_ip" "itds_shrd_srv_explr_pip" {
  name = "${var.env_prefix_hypon}-shrd-srv-explr-pip"
  location = "${azurerm_resource_group.itds_shrd_srv_explr_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"
  allocation_method = "Static"
}

resource "azurerm_lb" "itds_shrd_srv_explr_lb" {
  name = "${var.env_prefix_hypon}-shrd-srv-explr-lb"
  location = "${azurerm_resource_group.itds_shrd_srv_explr_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"

  frontend_ip_configuration {
    name = "${var.env_prefix_hypon}-shrd-srv-explr-lb-fic"
    public_ip_address_id = "${azurerm_public_ip.itds_shrd_srv_explr_pip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "itds_shrd_srv_explr_lb_addr_pl" {
  name = "${var.env_prefix_hypon}-shrd-srv-explr-lb-addr-pl"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"
  loadbalancer_id = "${azurerm_lb.itds_shrd_srv_explr_lb.id}"
}

resource "azurerm_availability_set" "itds_shrd_srv_explr_aset" {
  name = "${var.env_prefix_hypon}-shrd-srv-explr-aset"
  location = "${azurerm_resource_group.itds_shrd_srv_explr_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"
  managed = "true"
}

resource "azurerm_lb_probe" "itds_shrd_srv_explr_lb_prb" {
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"
  loadbalancer_id = "${azurerm_lb.itds_shrd_srv_explr_lb.id}"
  name = "shrd-srv-explr-lb-prb-prt-${var.shrd_srv_explr_lb_prb_prt[count.index]}"
  port = "${var.shrd_srv_explr_lb_prb_prt[count.index]}"
  count = "${length(var.shrd_srv_explr_lb_prb_prt)}"
}

resource "azurerm_lb_rule" "itds_shrd_srv_explr_lb_rl" {
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"
  loadbalancer_id = "${azurerm_lb.itds_shrd_srv_explr_lb.id}"
  name = "${var.env_prefix_hypon}-shrd-srv-explr-lb-rl-${var.shrd_srv_explr_lb_fnt_prt[count.index] == "*" ? "all" : var.shrd_srv_explr_lb_fnt_prt[count.index]}"
  protocol = "Tcp"
  frontend_port = "${var.shrd_srv_explr_lb_fnt_prt[count.index]}"
  backend_port = "${var.shrd_srv_explr_lb_bck_prt[count.index]}"
  frontend_ip_configuration_name = "${var.env_prefix_hypon}-shrd-srv-explr-lb-fic"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.itds_shrd_srv_explr_lb_addr_pl.id}"
  probe_id = "${element(azurerm_lb_probe.itds_shrd_srv_explr_lb_prb.*.id, count.index)}"
  count = "${length(var.shrd_srv_explr_lb_fnt_prt)}"
}


resource "azurerm_network_interface" "itds_shrd_srv_explr_vm_nic" {
  name = "${var.env_prefix_hypon}-shrd-srv-explr-vm-${count.index}-nic"
  location = "${azurerm_resource_group.itds_shrd_srv_explr_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"
  ip_configuration {
    name = "${var.env_prefix_hypon}-shrd-srv-explr-vm-${count.index}-ipc"
    subnet_id = "${azurerm_subnet.itds_shrd_srv_explr_snet.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "${element(var.shrd_srv_explr_vm_ip, count.index)}"
  }
  count = "${length(var.shrd_srv_explr_vm_ip)}"
}

resource "azurerm_network_interface_backend_address_pool_association" "itds_shrd_srv_explr_vm_nic_lb_addr_pl_asso" {
  ip_configuration_name = "${var.env_prefix_hypon}-shrd-srv-explr-vm-${count.index}-ipc"
  network_interface_id = "${element(azurerm_network_interface.itds_shrd_srv_explr_vm_nic.*.id, count.index)}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.itds_shrd_srv_explr_lb_addr_pl.id}"
  count = "${length(var.shrd_srv_explr_vm_ip)}"
}

resource "azurerm_virtual_machine" "itds_shrd_srv_explr_vm" {
  name = "${var.env_prefix_hypon}-shrd-srv-explr-vm-${count.index}"
  location = "${azurerm_resource_group.itds_shrd_srv_explr_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"
  network_interface_ids = [
    "${element(azurerm_network_interface.itds_shrd_srv_explr_vm_nic.*.id, count.index)}"]
  vm_size = "${var.shrd_srv_explr_vm["vm_size"]}"
  availability_set_id = "${azurerm_availability_set.itds_shrd_srv_explr_aset.id}"
  delete_os_disk_on_termination = false
  storage_image_reference {
    publisher = "${var.shrd_srv_explr_vm["vm_img_publisher"]}"
    offer = "${var.shrd_srv_explr_vm["vm_img_offer"]}"
    sku = "${var.shrd_srv_explr_vm["vm_img_sku"]}"
    version = "${var.shrd_srv_explr_vm["vm_img_ver"]}"
  }
  storage_os_disk {
    name = "${var.env_prefix_hypon}-shrd-srv-explr-vm-${count.index}-os-dsk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name = "${var.env_prefix_hypon}-shrd-srv-explr-vm-${count.index}"
    admin_username = "${var.shrd_srv_explr_vm_adm}"
    admin_password = "${var.shrd_srv_explr_vm_pswd}"
    custom_data = "${data.template_cloudinit_config.itds_shrd_srv_explr_cint_conf.rendered}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  count = "${length(var.shrd_srv_explr_vm_ip)}"
}

resource "azurerm_managed_disk" "itds_shrd_srv_explr_vm_mg_dsk" {
  name = "${var.env_prefix_hypon}-shrd-srv-explr-vm-${count.index}-mg-dsk"
  location = "${azurerm_resource_group.itds_shrd_srv_explr_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_explr_rg.name}"
  storage_account_type = "${var.shrd_srv_explr_vm["vm_mg_dsk_ty"]}"
  create_option = "Empty"
  disk_size_gb = "${var.shrd_srv_explr_vm["vm_mg_dsk_sz"]}"
  count = "${length(var.shrd_srv_explr_vm_ip)}"
}

resource "azurerm_virtual_machine_data_disk_attachment" "itds_shrd_srv_explr_vm_dsk_attch" {
  managed_disk_id = "${element(azurerm_managed_disk.itds_shrd_srv_explr_vm_mg_dsk.*.id, count.index)}"
  virtual_machine_id = "${element(azurerm_virtual_machine.itds_shrd_srv_explr_vm.*.id, count.index)}"
  lun = "10"
  caching = "ReadWrite"
  count = "${length(var.shrd_srv_explr_vm_ip)}"
}