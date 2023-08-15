output "cicd_user_openstack_rc" {
  value = {
    OS_AUTH_URL = ovh_cloud_project_user.cicd_user.openstack_rc.OS_AUTH_URL
    OS_TENANT_ID = ovh_cloud_project_user.cicd_user.openstack_rc.OS_TENANT_ID
    OS_TENANT_NAME = ovh_cloud_project_user.cicd_user.openstack_rc.OS_TENANT_NAME
    OS_USERNAME = ovh_cloud_project_user.cicd_user.username
  }
  description = "Openstack RC file"
}

output "cicd_user_password" {
  value = ovh_cloud_project_user.cicd_user.password
  description = "Openstack password"
  sensitive = true
}