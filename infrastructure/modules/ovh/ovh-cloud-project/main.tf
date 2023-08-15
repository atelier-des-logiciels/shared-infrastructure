terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
      version = "0.32.0"
    }
  }
}

provider "ovh" {
}

data "ovh_order_cart" "mycart" {
  ovh_subsidiary = "fr"
}

data "ovh_order_cart_product_plan" "cloud" {
  cart_id        = data.ovh_order_cart.mycart.id
  price_capacity = "renew"
  product        = "cloud"
  plan_code      = var.plan_code
}

resource "ovh_cloud_project" "this" {
  ovh_subsidiary = data.ovh_order_cart.mycart.ovh_subsidiary
  description    = var.cloud_project_description

  plan {
    duration     = data.ovh_order_cart_product_plan.cloud.selected_price[0].duration
    plan_code    = data.ovh_order_cart_product_plan.cloud.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.cloud.selected_price[0].pricing_mode
  }
}