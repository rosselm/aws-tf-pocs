# Some proof of concepts

The code assumes you have a VPC (with 3 subnets in 3 AZs) with an IGW attached (dns resolution/hostname enabled) and routing toward IGW.  All the examples are built on top of it.
(In case you are able to connect to your EC2s through SSM private VPC endpoints (ssm + ssm-message) it should also work fine, bottom line - you need a way to get into your VPC :-) )

## EFS (WIP)

Example how to create an EFS mount target, and how to secure it, and use it to rsync to it by using a dedicated EC2 autoscaling group behind a NLB.

TODOs: attach correct instance profiles to the EC2s.
