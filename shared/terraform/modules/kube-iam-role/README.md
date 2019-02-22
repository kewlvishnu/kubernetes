# Kubernetes IAM Role Module
Create an IAM Role to use with [kiam](https://github.com/uswitch/kiam). This setups up the role with the permissions to be assumed by the node instances.</br></br>
You must attach your own policies to this role.

### Why do I need this instead of just making a role?
This module basically just creates an IAM role and gives you outputs to use it. The important distinction between making a standard role and what this module does is the `assume_role_policy` that it has.

Usually for making roles that EC2 instances will assume, this policy looks like:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
```

This allows it to be assumed by an EC2 instance by you. However, it cannot be assumed by another role. This module adds another statement to the list above that looks like this:
```json
{
  "Sid": "",
  "Effect": "Allow",
  "Principal": {
    "AWS": "${var.eks-node-role-arn}"
  },
  "Action": "sts:AssumeRole"
}
```

This allows the eks nodes role to assume this new role that you are creating with this module. This coincides with how kiam works. 

You can read more about this in [kiam's docs about IAM](https://github.com/uswitch/kiam/blob/master/docs/IAM.md).

## Input Variables
| Variable               | Description                  | Default Value |
|------------------------|------------------------------|---------------|
| name                   | full name of the iam role.   | -             |
| eks-node-role-arn      | arn of the eks-node-role-arn | -             |

## Output Variables
| Variable | Description                                                             |
|----------|-------------------------------------------------------------------------|
| arn      | The arn of the IAM role created. Used in the annotation of a deployment |
| name     | The name of the IAM role. Useful to attach more policies.               |

## Example usage

````hcl
# Use a data source for safety. If the cluster is remade, it will be pick up the new arn.
data "aws_iam_role" "node-role" {
  name = "${var.cluster-name}-node-role"
}

module "my_role" {
  source = "../../../shared/modules/kube-iam-role"
  name = "${var.project}-${var.environment}-rds"
  eks-node-role-arn = "${data.aws_iam_role.node-role.arn}"
}
````
