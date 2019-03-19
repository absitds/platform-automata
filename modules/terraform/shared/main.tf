terraform {
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "itds_tf_eg_rg" {
  name     = "${var.env_prefix_hypon}-tf-rg"
  location = "${var.env_location}"
}


resource "azurerm_network_security_group" "itds_tf_eg_nsg" {
  name = "${var.env_prefix_hypon}-tf-eg-nsg"
  resource_group_name = "${azurerm_resource_group.itds_tf_eg_rg.name}"
  location = "${azurerm_resource_group.itds_tf_eg_rg.location}"
}

resource "azurerm_network_security_rule" "itds_tf_eg_nsg_ib_rl" {
  name = "${var.env_prefix_underscore}_tf_eg_nsg_ibnd_rl_${var.tf_eg_nsg_ibnd_rl[count.index] == "*" ? "all" : var.tf_eg_nsg_ibnd_rl[count.index]}"
  priority = "${count.index+100}"
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "${var.tf_eg_nsg_ibnd_rl[count.index]}"
  source_address_prefix = "${var.tf_eg_nsg_ibnd_rl_src_pfx[count.index]}"
  destination_address_prefix = "${var.tf_eg_nsg_ibnd_rl_dst_pfx[count.index]}"
  resource_group_name = "${azurerm_resource_group.itds_tf_eg_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.itds_tf_eg_nsg.name}"
  count = "${length(var.tf_eg_nsg_ibnd_rl)}"
}

resource "azurerm_network_security_rule" "itds_tf_eg_nsg_ob_rl" {
  name = "${var.env_prefix_underscore}_tf_eg_nsg_obnd_rl_${var.tf_eg_nsg_obnd_rl[count.index] == "*" ? "all" : var.tf_eg_nsg_obnd_rl[count.index]}"
  priority = "${count.index+100}"
  direction = "Outbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "${var.tf_eg_nsg_obnd_rl[count.index]}"
  source_address_prefix = "${var.tf_eg_nsg_obnd_rl_src_pfx[count.index]}"
  destination_address_prefix = "${var.tf_eg_nsg_obnd_rl_dst_pfx[count.index]}"
  resource_group_name = "${azurerm_resource_group.itds_tf_eg_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.itds_tf_eg_nsg.name}"
  count = "${length(var.tf_eg_nsg_obnd_rl)}"
}

resource "azurerm_subnet" "itds_tf_eg_snet" {
  name = "${var.env_prefix_hypon}-tf-eg-snet"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name = "${var.vnet_rg_name}"
  address_prefix = "${var.tf_eg_snet_addr_pfx}"
}

resource "azurerm_subnet_network_security_group_association" "itds_tf_eg_snet_nsg_asso" {
  subnet_id = "${azurerm_subnet.itds_tf_eg_snet.id}"
  network_security_group_id = "${azurerm_network_security_group.itds_tf_eg_nsg.id}"
}

resource "azurerm_public_ip" "itds_tf_eg_pip" {
  name = "${var.env_prefix_hypon}-tf-eg-pip"
  location = "${azurerm_resource_group.itds_tf_eg_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_tf_eg_rg.name}"
  allocation_method = "Static"
}

resource "azurerm_network_interface" "itds_tf_eg_vm_nic" {
  name = "${var.env_prefix_hypon}-tf-eg-vm-${count.index}-nic"
  location = "${azurerm_resource_group.itds_tf_eg_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_tf_eg_rg.name}"
  ip_configuration {
    name = "${var.env_prefix_hypon}-tf-eg-vm-${count.index}-ipc"
    subnet_id = "${azurerm_subnet.itds_tf_eg_snet.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "${element(var.tf_eg_vm_ip, count.index)}"
  }
  count = "${length(var.tf_eg_vm_ip)}"
}

resource "azurerm_virtual_machine" "itds_tf_eg_vm" {
  name = "${var.env_prefix_hypon}-tf-eg-vm-${count.index}"
  location = "${azurerm_resource_group.itds_tf_eg_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_tf_eg_rg.name}"
  network_interface_ids = [
    "${element(azurerm_network_interface.itds_tf_eg_vm_nic.*.id, count.index)}"]
  vm_size = "${var.tf_eg_vm["vm_size"]}"
  availability_set_id = "${azurerm_availability_set.itds_tf_eg_aset.id}"
  delete_os_disk_on_termination = false
  storage_image_reference {
    publisher = "${var.tf_eg_vm["vm_img_publisher"]}"
    offer = "${var.tf_eg_vm["vm_img_offer"]}"
    sku = "${var.tf_eg_vm["vm_img_sku"]}"
    version = "${var.tf_eg_vm["vm_img_ver"]}"
  }
  storage_os_disk {
    name = "${var.env_prefix_hypon}-tf-eg-vm-${count.index}-os-dsk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name = "${var.env_prefix_hypon}-tf-eg-vm-${count.index}"
    admin_username = "${var.tf_eg_vm_adm}"
    admin_password = "${var.tf_eg_vm_pswd}"
    custom_data = "${data.template_cloudinit_config.itds_tf_eg_cint_conf.rendered}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  count = "${length(var.tf_eg_vm_ip)}"
}

resource "azurerm_managed_disk" "itds_tf_eg_vm_mg_dsk" {
  name = "${var.env_prefix_hypon}-tf-eg-vm-${count.index}-mg-dsk"
  location = "${azurerm_resource_group.itds_tf_eg_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_tf_eg_rg.name}"
  storage_account_type = "${var.tf_eg_vm["vm_mg_dsk_ty"]}"
  create_option = "Empty"
  disk_size_gb = "${var.tf_eg_vm["vm_mg_dsk_sz"]}"
  count = "${length(var.tf_eg_vm_ip)}"
}

resource "azurerm_virtual_machine_data_disk_attachment" "itds_tf_eg_vm_dsk_attch" {
  managed_disk_id = "${element(azurerm_managed_disk.itds_tf_eg_vm_mg_dsk.*.id, count.index)}"
  virtual_machine_id = "${element(azurerm_virtual_machine.itds_tf_eg_vm.*.id, count.index)}"
  lun = "10"
  caching = "ReadWrite"
  count = "${length(var.tf_eg_vm_ip)}"
}

