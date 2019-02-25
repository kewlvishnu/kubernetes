# fluxcloud

Chart to deploy fluxcloud. The fluxcloud project takes in flux events and sends slack messages with them.

See more info about justinbarrick's fluxcloud project @ [https://github.com/justinbarrick/fluxcloud](https://github.com/justinbarrick/fluxcloud)


## Configuration
|         Parameter           |       Description                                         |          Default                            |
|-----------------------------|-----------------------------------------------------------|---------------------------------------------|
| `image.repository`          | Container image                                           | `justinbarrick/fluxcloud`                   |
| `image.tag`                 | Container tag                                             | `v0.3.0`                                    |
| `image.pullPolicy`          | Container pull policy                                     | `IfNotPresent`                              |
| `service.port`              | Sealed Secrets service port                               | `8080`                                      |
| `exporterType`              | "slack" or "webhook"                                      | `slack`                                     |
| `slack.URLSecretName`       | name of a secret with the slack webhook                   | `nil`                                       |
| `slack.URLSecretKey`        | key from the secret that holds the webhook                | `nil`                                       |
| `slack.channel`             | which channel to send the message to                      | `nil`                                       |
| `slack.username`            | username to send the message as (optional)                | `""`                                        |
| `slack.iconEmoji`           | emoji to use the icon as (optional)                       | `""`                                        |
| `slack.githubURL`           | URL to use as the link for the message (optional)         | `""`                                        |
| `webhook.URL`               | URL of the webhook to send to                             | `nil`                                       |
| `resources.requests.memory` | Initial memory request                                    | `nil`                                       |
| `resources.requests.cpu`    | Initial cpu request                                       | `nil`                                       |
| `resources.limits.memory`   | Memory limit                                              | `nil`                                       |
| `resources.limits.cpu`      | cpu limit                                                 | `nil`                                       |
