# IAM Role Policy Module
Create an IAM Role Policy with the entered policy JSON.</br></br>
**Prerequisite:** You should be passing the role created from the base_role module.

## Input Variables
| Variable | Description | Default Value |
|----------|-------------|---------------|
|policy-name| The name that the policy will have. | - |
|project|The project that this is being used for.| - |
|environment|The environment that this will be deployed to.| - |
|role|The role that this policy will be attached. This should be the role created from the base_role module.| - |
|policy|The policy JSON document that you are creating this policy with.| - |

## Example usage

````hcl
module "iam_role_policy" {
  source = "../../../shared/modules/iam_role_policy"
  project = "myproject"
  environment = "test"
  role = "${module.base_role.iam_role_name}"

  policy = <<EOF
${var.policy}
  EOF

}
````
