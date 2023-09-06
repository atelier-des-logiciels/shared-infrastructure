output "kubeconfig" {
  description = "The kubeconfig file for the cluster"
  value = ovh_cloud_project_kube.this.kubeconfig
  sensitive = true
}