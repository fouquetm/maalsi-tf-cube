locals {
  tags = {
    project_name = var.project_name
    project_owner = var.project_owner
  }

  project_name_without_special = replace(var.project_name, "-", "")
}