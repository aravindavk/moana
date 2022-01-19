# Kadalu Storage Management - Moana
# Introduction

Moana is a frontend for the Kadalu Storage. Moana provides tools for setting up and managing the Kadalu cluster. Which includes:

    * Creating storage pool and adding nodes to the pool
    * Creating and managing storage volume
among other things.

This README is structured for quickly getting started with the project (from the released binaries). If you want to develop, and contribute to the project, check our [Developer Documentation](./docs/devel/README.adoc)

## Install Moana (Server, Node agent and CLI)

Download and install the latest release with the command

```
curl -fsSL https://github.com/kadalu/moana/releases/latest/download/install.sh | sudo bash -x
```

## Usage:

Start the Kadalu Management Server in all the Storage nodes

```
# systemctl enable kadalu-mgr
# systemctl start kadalu-mgr
```

Refer [docs](./docs) for more details.
