output "lb-dns-name" {
  description = "Domain name of the ALB"
  value = module.alb.this_lb_dns_name
}