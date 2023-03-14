# resource "aws_iam_role" "nodes" {
#   name = "eks-node-group-nodes"

#     assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.nodes.name
# }

# resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.nodes.name
# }

# resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.nodes.name
# }



# resource "aws_eks_node_group" "private-nodes" {
#   cluster_name    = aws_eks_cluster.eks_cluster.name
#   node_group_name = "private-nodes"
#   node_role_arn   = aws_iam_role.nodes.arn
  
#   subnet_ids = var.subnet_ids
  
#   capacity_type  = "ON_DEMAND"
#   instance_types = ["t2.micro"]

#   scaling_config {
#     desired_size = 1
#     max_size     = 3
#     min_size     = 1
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   labels = {
#     role = "general"
#   }


#   depends_on = [
#     aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }


resource "aws_iam_role" "nodes_general" {

  name = "eks-node-group-general"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.nodes_general.name
}
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.nodes_general.name
}
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.nodes_general.name
}

resource "aws_eks_node_group" "nodes_general" {
  cluster_name = aws_eks_cluster.eks.name
  node_group_name = "nodes-general"
  node_role_arn = aws_iam_role.nodes_general.arn
  subnet_ids = [ var.public1_subnet_id, var.public2_subnet_id ]
  scaling_config {
    desired_size = 1
    max_size = 1
    min_size = 1
  }

  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  instance_types = [ "t3.small" ]
  labels = {
    "role" = "nodes-general"
  }
  depends_on = [
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general
  ]
}