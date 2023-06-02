# L300 Challenge Lab Scripts for App Mod
These scripts are provided to solve the Challenge Lab for AppMod L300

**NOTE:** *You can find the Challenge Lab [here.](https://partner.cloudskillsboost.google/focuses/18952?parent=catalog)* 

This README will help you get set up to run through the Challenge Lab in your Argolis environment as a dry run before attempting the real thing inside of QwikLabs using these scripts.

## Getting the Bank of Anthos application
In addition to this repository, you'll need the Bank of Anthos (BoA) repository and its files to run everything.

1. Clone [this repository](https://github.com/GoogleCloudPlatform/bank-of-anthos) from GitHub.
1. Copy files from that repository on top of this repository to overlay them.

**Note:** The only overlap in these two repositories is the `kubernetes-manifests` directory. Make sure files from both repositories are present.

## Prerequisite Setup in Argolis
**Note:** If you are running the scripts in this repository inside of the QwikLabs environment, you can skip ahead to the [Running through the Lab](#running-through-the-lab-task-by-task) section.

Because we are running in Argolis, we need to set up some artifacts that will already exist in the QwikLab when you start it.

**Note:** These scripts all start with an underscore character to make them distinctive from the rest.

### Create a New Project
First thing is to create a new project within Argolis.

Once you have the new project, you'll want to do some stuff to make it "useable", namely:

1. Enable the most common needed APIs
2. Remove restrictive Org Policies
3. Create a `default` network
4. Create firewall rules for SSH and HTTP(S)

**Note:** You can find scripts to do these 4 things in [this repository](https://github.com/gfilicetti/gcp-scripts)

### Deploy Prerequisite Infrastructure
We need to deploy a few things to get ourselves to the base line needed to run through the lab.

Namely we'll be:
* Enabling some needed APIs
* Deploying the old monolithic BoA application
* Creating a GKE cluster to hold the migrated application
* Deploying the container based BoA application

**Note:** You must remember to inspect every script before running it and looking at the variables at the top to modify any that need to be changed due to your specific environment. It is also necessary to read comments in the scripts and look for any warnings.

#### Enabling needed APIs
Run this script:

```shell
./_enable-apis.sh
```

This will enable the following services:
* Compute
* Container
* Cloud Resource Manager
* Monitoring

#### Deploying the Monolithic application
Run this script:

```shell
./_deploy-1-monolith.sh
```

This will deploy the single VM based version of the BoA app. 

It will use the install script inside of the BoA repository. Make sure you cloned the BoA repository as instructed above.

#### Deploying a fresh GKE cluster
Run this script:

```shell
./_deploy-2-cluster.sh
```

This will create a new GKE cluster named `cymbal-monolith-cluster` in us-central1-a

#### Deploying the container based application
Run this script:

```shell
./_deploy-3-app-to-cluster.sh
```

This will run all the kubernetes deployments in the BoA repository to deploy the container based version of BoA to the new cluster.

## Running Through the Lab Task by Task

At this point you'll be running each of the `task-nn.sh` scripts one by one to achieve each of the tasks in the QwikLab.

Generally you'll want to keep these things in mind as you run these:
* **ALWAYS** read the code inside the script and understand what it is doing
* This includes the comments, some of which contain warnings and alternate code
* Some of the variables defined at the top of the script will need to be changed to match your environment.
* Some of the scripts will copy our template files on top of existing files in the BoA structure, be aware of this.
* There will be some git operations done in various tasks. These are used against a Google Source Repository, not GitHuc.
* Once again, if you don't understand what the scripts do and are not able to diagnose and debug any problems, you might have trouble with this. This is why doing dry runs in Argolis are highly suggested.

