module "mon_module" {
    source = "../example_module"
    v1 = "value of v1"
}

output "result_module_mon_module" {
  value = module.mon_module.resut_v1
}