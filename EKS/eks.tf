# resource "aws_iam_role" "iam-role-eks-cluster" {
#   name = "terraform-eks-cluster"
#   assume_role_policy = <<POLICY
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#    "Effect": "Allow",
#    "Principal": {
#     "Service": "eks.amazonaws.com"
#    },
#    "Action": "sts:AssumeRole"
#    }
#   ]
#  }
# POLICY
# }

# # Attach the AWS EKS service and AWS EKS cluster policies to the role.

# resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = "${aws_iam_role.iam-role-eks-cluster.name}"
# }

# resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#   role       = "${aws_iam_role.iam-role-eks-cluster.name}"
# }

# # Create security group for AWS EKS.
 
# resource "aws_security_group" "eks-cluster" {
#   name        = "SG-eks-cluster"
# # Use your VPC here
#   vpc_id      = var.vpc_id 
#  # Outbound Rule
#   egress {                
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   # Inbound Rule
#   ingress {                
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
 
# # Creating the AWS EKS cluster
 
# resource "aws_eks_cluster" "eks_cluster" {
#   name     = "terraformEKScluster"
#   role_arn =  "${aws_iam_role.iam-role-eks-cluster.arn}"
#  # Configure EKS with vpc and network settings 
#   vpc_config {            
#    security_group_ids = ["${aws_security_group.eks-cluster.id}"]
# # Configure subnets below
#    subnet_ids         = var.subnet_ids 
#     }
#   depends_on = [
#     "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy",
#     "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy",
#    ]
# }

resource "aws_iam_role" "eks_cluster" {

  name = "eks-cluster"
  
  assume_role_policy = <<POLICY
  {
    
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
POLICY

}

# Attach the AWS EKS service and AWS EKS cluster policies to the role.

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "eks" {
  name = "eks"
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    endpoint_private_access = false
    endpoint_public_access = true
    subnet_ids = [var.public1_subnet_id,var.public2_subnet_id]
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy
  ]
}