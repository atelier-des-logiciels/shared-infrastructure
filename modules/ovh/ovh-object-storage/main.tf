terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.52.1"
    }
    ovh = {
      source = "ovh/ovh"
      version = "0.33.0"
    }    
  }
}

provider "openstack" {
  domain_name = "default"
  region = var.region
}

data "openstack_objectstorage_container_v1" "this" {
  name   = var.container_name
  region = var.region 
}

resource "ovh_cloud_project_user_s3_credential" "this" {
  service_name = var.service_name
  user_id      = var.user_id
}

resource "ovh_cloud_project_user_s3_policy" "this" {
  service_name = var.service_name
  user_id      = var.user_id
  policy       = jsonencode({
    "Statement":[{
      "Sid": "RWContainer",
      "Effect": "Allow",
      "Action":["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket", "s3:ListMultipartUploadParts", "s3:ListBucketMultipartUploads", "s3:AbortMultipartUpload", "s3:GetBucketLocation"],
      "Resource":["arn:aws:s3:::hp-bucket", "arn:aws:s3:::hp-bucket/*"]
    }]
  })
}