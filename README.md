# Training on Containers and Continuous Integration

On this repo you can find all contents, from labs to slides, that allow you to gradually have an hands-on experience on containers using Docker, unit testing and Continuous Integration (CI) using Github Actions.

Navigate to <https://theonorg.github.io/containers-ci-training/> to have access aGitHub Pages version of these instructions.

## On this page

- [Prerequisites](README.md#prerequisites)
  - [Windows](#windows)
  - [Ubuntu](#ubuntu)
  - [macOS](#macos)
- [Labs](README.md#labs)
- [ToDo App project](README.md#todo-app-project)
- [Slides](README.md#slides)
- [Feedback](README.md#feedback)

## Prerequisites

To perform the labs on this repo you need to have the following software installed on your machine.

### Windows

1. Windows 10+ (Windows 11 is recommended)
2. [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab)
3. [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install)
4. [Docker Desktop](https://www.docker.com/products/docker-desktop)
5. Configure WSL integration with Docker Desktop. More [here](https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers#install-docker-desktop)
6. Install [Visual Studio Code](https://code.visualstudio.com/) (or other code editor of your preference)
7. (Optional) Some VS Code extension helpful for Docker and Kubernetes integration

    - [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
    - [Docker compose](https://marketplace.visualstudio.com/items?itemName=p1c2u.docker-compose)
    - [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)

### Ubuntu

1. Ubuntu 20.04
2. Docker. [How to install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
3. Install [Visual Studio Code](https://code.visualstudio.com/docs/setup/linux) (or other code editor of your preference)
4. (Optional) Some VS Code extension helpful for Docker and Kubernetes integration

    - [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
    - [Docker compose](https://marketplace.visualstudio.com/items?itemName=p1c2u.docker-compose)
    - [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)

This setup works on top of [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install).

### macOS

1. Docker. [Install Docker Desktop on Mac](https://docs.docker.com/desktop/install/mac-install/)
2. Install [Visual Studio Code](https://code.visualstudio.com/docs/setup/mac) (or other code editor of your preference)
3. (Optional) Some VS Code extension helpful for Docker and Kubernetes integration

    - [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
    - [Docker compose](https://marketplace.visualstudio.com/items?itemName=p1c2u.docker-compose)
    - [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)

## Labs

On next links you may find the hands-on exercises to give you more experience on this topics.

You may navigate for each one individually or you may follow the sequence starting on first one and proceed to the next using the navigation links at the end of each lab.

1. [Introduction to containers](labs/lab01.md)
2. [How to create my own container](labs/lab02.md)
3. [Persistence in containers](labs/lab03.md)
4. [Let's compose your containers](labs/lab04.md)

## ToDo App project

With this simple ToDo App you have the hands-on experience to create all needed artifacts to deploy an app on Kubernetes.

- Step #1 [Create images and run using docker compose](project/step01.md)
- Step #2 [Create GitHub Actions for CI](project/step02.md)

## Slides

Get access to the content used to share Kubernetes concepts during sessions.

1. [Introduction to containers](slides/Module01.pdf)
2. [Dockerfile and Tags](slides/Module02.pdf)
3. [Persistence in containers](slides/Module03.pdf)
4. [Docker compose](slides/Module04.pdf)

## Feedback

For any feedback open up an issue describing what have you found and I'll return to you!

[Back to top…](README.md#on-this-page)
