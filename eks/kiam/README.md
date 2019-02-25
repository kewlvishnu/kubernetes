# kiam

Chart to deploy kiam. The kiam project allows you to give IAM roles to kubernetes pods.

Note that `agent.args.host.iptables` is defaulted to false, but most of the time you probably want to put that at true. It's defaulted as false so you don't have magic behavior without specifying.

See more info about uswitch's kiam project @ [https://github.com/uswitch/kiam](https://github.com/uswitch/kiam)


## Configuration
|         Parameter                      |       Description                                         |          Default                            |
|----------------------------------------|-----------------------------------------------------------|---------------------------------------------|
| `replicaCount`                         | Amount of pods to create                                  | `1`                                         |
| `image.repository`                     | Container image                                           | `quay.io/uswitch/kiam`                      |
| `image.tag`                            | Container tag                                             | `v3-release`                                |
| `image.pullPolicy`                     | Container pull policy                                     | `IfNotPresent`                              |
| `rbac.create`                          | Whether to create RBAC resources or not                   | `true`                                      |
| `agent.args.host.iptables`             | Rewrite iptables on the nodes automatically               | `false`                                     |
| `agent.args.host.port`                 | Port that the server is running on                        | `8181`                                      |
| `agent.args.host.interface`            | Which interfaces to edit the iptables for if iptables=true| `!en0`                                      |
| `agent.args.log.jsonOutput`            | Output the logs in json format                            | `true`                                      |
| `agent.args.log.level`                 | Level to output the logs at                               | `info`                                      |
| `agent.args.prometheus.scrape`         | Scrape prometheus metrics                                 | `false`                                     |
| `agent.args.prometheus.port`           | Prometheus port                                           | `9620`                                      |
| `agent.args.prometheus.syncInterval`   | Prometheus sync interval                                  | `5s`                                        |
| `agent.args.gatewayTimeoutCreation`    | Timeout when creating the kiam gateway                    | `1s`                                        |
| `agent.tlsSecretName`                  | Name of the secret of K8s holding the TLS certs           | `nil`                                       |
| `agent.tlsCertNames.cert`              | The key of the cert in the secret                         | `agent.pem`                                 |
| `agent.tlsCertNames.key`               | The key of the key in the secret                          | `agent-key.pem`                             |
| `agent.tlsCertNames.ca`                | The key of the ca in the secret                           | `ca.pem`                                    |
| `server.args.log.jsonOutput`           | Output the logs in json format                            | `true`                                      |
| `server.args.log.level`                | Level to output the logs at                               | `info`                                      |
| `server.args.prometheus.scrape`        | Scrape prometheus metrics                                 | `false`                                     |
| `server.args.prometheus.port`          | Prometheus port                                           | `9620`                                      |
| `server.args.prometheus.syncInterval`  | Prometheus sync interval                                  | `5s`                                        |
| `server.args.roleBaseArn`              | Base ARN for IAM roles                                    | `nil`                                       |
| `server.args.cache.syncInterval`       | Pod cache settings                                        | `1m`                                        |
| `server.args.assumeRoleArn`            | IAM role for the server to assume                         | `nil`                                       |
| `server.args.sessionDuration`          | Session duration for STS tokens                           | `15m`                                       |
| `server.args.gatewayTimeoutCreation`   | Timeout when creating the kiam gateway                    | `1s`                                        |
| `server.tlsSecretName`                 | Name of the secret of K8s holding the TLS certs           | `nil`                                       |
| `server.tlsCertNames.cert`             | The key of the cert in the secret                         | `agent.pem`                                 |
| `server.tlsCertNames.key`              | The key of the key in the secret                          | `agent-key.pem`                             |
| `server.tlsCertNames.ca`               | The key of the ca in the secret                           | `ca.pem`                                    |
| `server.probes.serverAddress`          | The address to probe for the health check                 | `127.0.0.1`                                 |
| `server.service.port`                  | The port to run the service on                            | `443`                                       |
| `server.service.targetPort`            | The port that the container is running on                 | `443`                                       |
| `resources.requests.memory`            | Initial memory request                                    | `nil`                                       |
| `resources.requests.cpu`               | Initial cpu request                                       | `nil`                                       |
| `resources.limits.memory`              | Memory limit                                              | `nil`                                       |
| `resources.limits.cpu`                 | cpu limit                                                 | `nil`                                       |
