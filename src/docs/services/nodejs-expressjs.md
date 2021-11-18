# Service: NodeJS with ExpressJS

- **Path:** [./src/services/nodejs/expressjs/webapi/](https://github.com/ericis/hello-cloud/tree/main/src/services/nodejs/expressjs/webapi)
- **Runtime:** [NodeJS](https://nodejs.org/) 🔗
- **Language:** [JavaScript](https://javascript.info/) 🔗
- **Framework:** [ExpressJS](https://expressjs.com/) 🔗

## Getting started

The [contributor guide](../contribute.md) has the steps necessary to run this project locally.

Run this service with any Open Container Initiative (OCI) compatible runtime, like `docker` or `podman` (e.g.
`docker run --name=our-hello-nodejs-expressjs-webapi --detach --publish=3000:3000 ghcr.io/ericis/hello-cloud/our-hello-nodejs-expressjs-webapi:latest` and then browse to http://localhost:3000/).

## DevOps

- **Tasks:** [`make`](../contribute.md)
- **Pipeline:** ["./.github/workflows/nodejs_expressjs_webapi.yml"](https://github.com/ericis/hello-cloud/blob/main/.github/workflows/nodejs_expressjs_webapi.yml)
- **Source:** ["./src/services/nodejs/expressjs/webapi"](https://github.com/ericis/hello-cloud/tree/main/src/services/nodejs/expressjs/webapi/)
- **Deployment(s):** ["hello-cloud/our-hello-nodejs-expressjs-webapi"](https://github.com/ericis/hello-cloud/pkgs/container/hello-cloud%2Four-hello-nodejs-expressjs-webapi) docker container, Amazon Web Services Elastic Beanstalk, Microsoft Azure App Service, Google Cloud App Engine, Salesforce Heroku

## Deployments

### Docker

The ["hello-cloud/our-hello-nodejs-expressjs-webapi"](https://github.com/ericis/hello-cloud/pkgs/container/hello-cloud%2Four-hello-nodejs-expressjs-webapi) docker image is simply the packaged and runnable version of the web service.

Using the standard developer `make` tasks, the service can be containerized and executed with `docker`, `docker-compose` or `podman`. The DevOps pipeline for Continuous Integration (CI) and Deployment (CD) uses the `make deploy` task to build and deploy the service as a container (_`make deploy` only supports "dev_tool=docker" or "dev_tool=podman"_). The GitHub Actions workflow "./.github/workflows/nodejs_expressjs_webapi.yml" authenticates to the GitHub Container Registry for this repository and pushes (publishes) [the "hello-cloud/our-hello-nodejs-expressjs-webapi" image](https://github.com/ericis/hello-cloud/pkgs/container/hello-cloud%2Four-hello-nodejs-expressjs-webapi).

### Multi-cloud

While each cloud provider below has unique prerequisites and important notes, all of the tasks to deploy to each provider have been abstracted with the following automation tasks. Simply specify the provider as the argument (e.g. `make cloud-init cloud=aws`)

- Initialize with the command `make cloud-init cloud=aws|azure|gcloud|heroku`
- Install (deploy) with the command `make cloud-install cloud=aws|azure|gcloud|heroku`
- Get the applicaiton logs with the command `make cloud-logs cloud=aws|azure|gcloud|heroku`
- Uninstall (delete/destroy) with the command `make cloud-uninstall cloud=aws|azure|gcloud|heroku`

### Amazon Web Services (AWS)

#### Prerequisites

- An [AWS account](https://aws.amazon.com/free/) _\*this project worked with free infrastructure at the time of its creation_
- [`eb` CLI](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html)

#### Steps to deploy

1. Open a terminal and navigate to the service project directory (e.g. `cd ./src/services/nodejs/expressjs/webapi`)
2. Run the command `make aws-init` to create the AWS Elastic Beanstalk Environment. This command may take a few minutes. The `eb` CLI will prompt you for access credentials. Create a new access key by visiting ["Your Security Credentials"](https://console.aws.amazon.com/iam/home#/security_credentials), expanding "Access keys" and creating a new key.
3. Install the application with the command `make aws-install`. This command may take several seconds.
4. Check the application logs with the command `make aws-logs`
5. Uninstall and clean up the application deployment with the command `make aws-uninstall`. This command may take several seconds.

### Microsoft Azure

#### Prerequisites

- An [Azure account](https://azure.microsoft.com/en-us/free/) _\*this project worked with free infrastructure at the time of its creation_
- [`az` CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

#### Steps to deploy

1. Open a terminal and navigate to the service project directory (e.g. `cd ./src/services/nodejs/expressjs/webapi`)
2. Login to your Azure account with the CLI using the command `az login`
3. If you have more than one subscription, first [set the default subscription](https://docs.microsoft.com/en-us/azure/developer/javascript/tutorial/tutorial-vscode-azure-cli-node/tutorial-vscode-azure-cli-node-03#set-your-default-subscription)
4. Run the command `make azure-init` to create the Azure Resource Group
5. Install the application with the command `make azure-install`
6. Check the application logs with the command `make azure-logs`
7. Uninstall and clean up the application deployment with the command `make azure-uninstall`

### Google Cloud

#### Prerequisites

- An [Google Cloud account](https://cloud.google.com/free) _\*this project worked with free infrastructure at the time of its creation_
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/quickstart)
- Google Cloud [Billing Account](https://console.cloud.google.com/billing)
- Enable [Google Cloud Build](https://cloud.google.com/build) with the command `gcloud services enable cloudbuild.googleapis.com`

#### Steps to deploy

Every attempt is made to automate the deployment. However, some timing issues have been observed as well as having to manually enable "Code Build" and manually associating dynamically created projects with a billing account. [Contributions are welcome!](../contribute.md)

1. Open a terminal and navigate to the service project directory (e.g. `cd ./src/services/nodejs/expressjs/webapi`)
2. Login to your Google Cloud account with the CLI using the command `gcloud auth login`
3. Run the command `make gcloud-init gcloud_project_name_suffix=001` to create the Google Cloud project
4. Install the application with the command `make gcloud-install`
5. If the output indicates that billing must be enabled, login to the [projects list](https://console.cloud.google.com/billing/projects) and associate the newly created project with the appropriate billing account (even if you are using free resources)
6. Check the application logs with the command `make gcloud-logs`
7. Uninstall and clean up the application deployment with the command `make gcloud-uninstall gcloud_project_name_suffix=001`

_\*Update the "gcloud_project_name_suffix" argument value for `gcloud-init` and `gcloud-uninstall` by incrementing the number to ensure a unique project name, or specify a custom unique name by using the argument "gcloud_project_unique_name" instead. By default, Google Cloud retains deleted projects for several days, so it is not possible to recreate the same project multiple times within a short period. A future [contribution to this project](../contribute.md) could simply restore a deleted project if it was recently deleted and use the same name._

### SalesForce Heroku

#### Prerequisites

- A [Heroku account](https://signup.heroku.com/) _\*this project worked with free infrastructure at the time of its creation_
- [`heroku` CLI](https://devcenter.heroku.com/articles/heroku-cli#uninstalling-the-heroku-cli)

#### Steps to deploy

1. Open a terminal and navigate to the service project directory (e.g. `cd ./src/services/nodejs/expressjs/webapi`)
2. Login to your Heroku account with the CLI using the command `heroku login`
3. Run the command `make heroku-init` to create and configure the cloud app including assigning the [community monorepo buildpack](https://github.com/lstoll/heroku-buildpack-monorepo#readme) as well as the [node.js buildpack](https://elements.heroku.com/buildpacks/heroku/heroku-buildpack-nodejs)
4. Install the application with the command `make heroku-install`
5. Check the application logs with the command `make heroku-logs`
6. Uninstall and clean up the application deployment with the command `make heroku-uninstall`

## Roadmap

- ✅ Local "hello-cloud" service (`yarn` or `npm`)
- ✅ Build and run as container (`docker`, `docker-compose`, or `podman`)
- ✅ Deploy container to GitHub Container Registry as GitHub Package
- ✅ GitHub Action workflow to build and deploy container to GitHub Container Registry as GitHub Package
- Deploy to cloud Platform-as-a-Service (PaaS)
  - ✅ "aws"
  - ✅ "azure"
  - ✅ "gcloud"
  - ✅ "heroku"
- Deploy to cloud Managed Containers _\*prefer "run as container" deployment over full-blown Managed Kubernetes deployment_
  - ⬜ "aws"
  - ⬜ "azure"
  - ⬜ "gcloud"
  - ⬜ "heroku"
- ⬜ GitHub Actions workflow to deploy this service to multiple clouds (automation of infrastructure setup and tear-down)
- ⬜ Service contracts and auto-generated documentation integrated with MkDocs documentation site
- ⬜ Ping / Health endpoint
