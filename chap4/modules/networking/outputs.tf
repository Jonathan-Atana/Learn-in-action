output "vpc" {
  description = "Expose the entire module as output"
  value = module.vpc
}

output "sg" {
  description = "Create an object containing an ID list of all the security groups"
  value = {
    lb = module.lb_sg.security_group.id
    db = module.db_sg.security_group.id
    websvr = module.websvr_sg.security_group.id
  }
}