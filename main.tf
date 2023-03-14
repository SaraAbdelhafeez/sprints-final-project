module "network" {
  source = "./network"
}

module "EkS" {
    source = "./EKS"
    public1_subnet_id = module.network.public1_subnet_id
    public2_subnet_id = module.network.public2_subnet_id
    vpc_id = module.network.vpc_id
  
}

module "ECR" {
    source = "./ECR"
    

}

module "EC2" {
    source = "./EC2"
    public1_subnet_id = module.network.public1_subnet_id
    vpc_id = module.network.vpc_id
}