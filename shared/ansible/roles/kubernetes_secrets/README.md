# kubernetes_secrets

## How to Use
1. Make a variable called `secrets` (either in a vars file or in your site.yml playbook file)
    * Format:
    ```
    ---
    secrets:
      - metadata:
          name: project-secrets
          namespace: wordpress
        data:
          "default.json": '
            {
              "db": {
                "url": "",
                "options": {
                  "server": {
                    "socketOptions": {
                      "keepAlive": 100,
                      "connectTimeoutMS": 30000
                    }
                  }
                }
              }
            }
          '
    ```
    * **NOTE**: data variables can be any string. Here we make a JSON file essentially, but you use any valid string. Each key in data will be made a file in the secrets volume with the value as its file contents.
    * **NOTE**: Also note that these data values must be sent to the cluster base64 encoded. This ansible role will base64 encode all of the values for you at runtime.
2. Make a variable with the location of the kubeconfig.
  * Format:
  ```
  kubeconfig: ./kubeconfig
  ```
3. Add the role to your playbook.
    * **NOTE**: The output of the variables won't be outputted to the ansible log as to not show secrets.
