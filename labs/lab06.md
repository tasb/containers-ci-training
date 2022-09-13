# Lab 06 - Continuous Integration

On this lab you'll add a GitHub workflow to build and push your images as soon as you push any change to your repo

## On this lab

- [Configure GitHub repo](#configure-github-repo)
- [Add your GitHub workflow](#add-your-github-workflow)
- [Run workflow](#run-workflow)

## Configure GitHub repo

To complete this lab you need to create a repo on GitHub.

Login to your GitHub account and create a clean and not initialized repo. You can name your repo as `EchoApp`.

Confirm that you set all settings as defined on following image.

![Create GH Repo](images/lab06/image01.png "Create GH Repo")

After that, you need to configure some secrets on that repo that will be used on your workflows to push your images to Docker Hub.

Navigate to repo `Settings`, clicking on menu on top, like next image.

![GH Repo Settings](images/lab06/image02.png "GH Repo Settings")

Then, navigate to `Secrets` > `Action` and click on `New repository secret`.

![GH Repo Secrets](images/lab06/image03.png "GH Repo Secrets")

Add the following secrets:

- Name: `DOCKER_USER` ; Secret: <YOUR_DOCKER_ID/USERNAME>
- Name: `DOCKER_PASSWORD` ; Secret: <YOUR_DOCKER_PASSWORD>

Now it's time to initiate your repo. You can use the final version of the lab from Module #6 [Unit test my API](lab05.md) or you can find a version with that lab implemented on [this link](https://github.com/theonorg/echo-api-dotnet-mssql/archive/refs/tags/lab05-done.zip).

On the folder where you have the code, run the following commands:

```bash
git init
git add -A
git commit -m "Init repo"
git branch -M main
git remote add origin <URL_FROM_YOUR_REPO>
git push -u origin main
```

Now you are ready to start to create your first workflow. Please open that folder on your preferred code editor.

## Add your GitHub workflow

GitHub workflows must be created on folder `.github/workflows`, so start to create that folder on you root dir.

Next, you will create two similar workflows for each component to enable Continuous Integration on both but with independency between them.

First, create a file named `echo-api.yml` on `.github/workflows` folder with following content.

```yaml
name: Echo API

on:
  push:
    paths:
      - 'echo-api/**'
      - 'echo-api.tests/**'
      - '.github/workflows/echo-api.yml'

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Setup .NET
      uses: actions/setup-dotnet@v2
      with:
        dotnet-version: 6.0.x
    - name: Restore dependencies
      run: |
        dotnet restore echo-api/echo-api.csproj
        dotnet restore echo-api.tests/echo-api.tests.csproj
    
    - name: Build
      run: |
        dotnet build --no-restore echo-api/echo-api.csproj
        dotnet build --no-restore echo-api.tests/echo-api.tests.csproj
    
    - name: Test
      run: dotnet test --no-build echo-api.tests/echo-api.tests.csproj --verbosity normal --logger "trx;LogFileName=test-results.trx"
      
    - name: Test Report
      uses: dorny/test-reporter@v1
      if: always()
      with:
        name: Todo API Tests
        path: '**/TestResults/*.trx'
        reporter: dotnet-trx

  publish:
    if: github.ref == 'refs/heads/main'
    env:
      DOCKER_USER: ${{ secrets.DOCKER_USER }}
      DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
      IMAGE_NAME: ${{ secrets.DOCKER_USER }}/aptiv-echo/api:${{ github.run_id }}

    runs-on: ubuntu-latest
    needs: build

    steps:
      - uses: actions/checkout@v3
      - name: Login to DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ env.DOCKER_USER }}
          password: ${{ env.DOCKER_PASSWORD }}

      - run: |
          docker build -f echo-api/Dockerfile.multi -t ${{ env.IMAGE_NAME}} echo-api
          docker push ${{ env.IMAGE_NAME}}

```

Let's dig on this file to have a better understanding about all content.

You start with the trigger that will make this workflow run.

```yaml
on:
  push:
    paths:
      - 'echo-api/**'
      - 'echo-api.tests/**'
      - '.github/workflows/echo-api.yml'
```

This means that every time a push to the remote repo happens this workflow will be triggered if a change is made on any of the paths defined.

Then if have two stages (or jobs): `build` and `publish`. Both will be execute on a Linux (ubuntu) agent. You define this using the following setting.

```yaml
runs-on: ubuntu-latest
```

On `build` stage you perform 6 tasks:

- Checkout the code
- Setup dotnet version to ensure dotnet 6 is used
- Restore dependencies using nuget
- Build your code
- Run your unit tests
- Publish test reports to be able to access them on GitHub interface

```yaml
steps:
- uses: actions/checkout@v3
- name: Setup .NET
    uses: actions/setup-dotnet@v2
    with:
    dotnet-version: 6.0.x
- name: Restore dependencies
    run: |
    dotnet restore echo-api/echo-api.csproj
    dotnet restore echo-api.tests/echo-api.tests.csproj

- name: Build
    run: |
    dotnet build --no-restore echo-api/echo-api.csproj
    dotnet build --no-restore echo-api.tests/echo-api.tests.csproj

- name: Test
    run: dotnet test --no-build echo-api.tests/echo-api.tests.csproj --verbosity normal --logger "trx;LogFileName=test-results.trx"
    
- name: Test Report
    uses: dorny/test-reporter@v1
    if: always()
    with:
    name: Todo API Tests
    path: '**/TestResults/*.trx'
    reporter: dotnet-trx
```

Then, on `publish` stage your perform 4 tasks:

- Checkout the code
- Login to Docker Hub to push your image
- Run `docker build` to build your image
- Run `docker push` to push your image to your area on Docker Hub

```yaml
steps:
- uses: actions/checkout@v3
- name: Login to DockerHub
uses: docker/login-action@v2
with:
    username: ${{ env.DOCKER_USER }}
    password: ${{ env.DOCKER_PASSWORD }}

- run: |
    docker build -f echo-api/Dockerfile.multi -t ${{ env.IMAGE_NAME}} echo-api
    docker push ${{ env.IMAGE_NAME}}
```

This stage have additional configuration that are crucial for this stage to run properly.

First, you defined 3 variables:

- `DOCKER_USER` with your Docker Hub username that you previously defined on repo secrets
- `DOCKER_PASSWORD` with your Docker Hub password that you previously defined on repo secrets
- `IMAGE_NAME` with your image name, using your Docker Hub username, a name for your repository (on Docker Hub) and using an unique id (`github.run_id`) as tag to have always a new tag each time you run this workflow.

```yaml
env:
  DOCKER_USER: ${{ secrets.DOCKER_USER }}
  DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
  IMAGE_NAME: ${{ secrets.DOCKER_USER }}/aptiv-echo/api:${{ github.run_id }}
```

Then, you define sequence between your stages. With this approach, you only run `publish` stage after `build` stage.

```yaml
needs: build
```

Finally, you make `publish` stage to run conditionally. This stage will only run if the push you made was on `main` branch. If you make a push on any other branch, you only run `build` stage to make you sure your code compiles and runs unit tests successfully and only produces a new image when you reach `main` (stable) branch.

```yaml
if: github.ref == 'refs/heads/main'
```

Now it's time to create the workflow for WebApp component. Create a file named `echo-webapp.yml` on `.github/workflows` folder wth following content.

```yaml
name: Echo WebApp

on:
  push:
    paths:
      - 'echo-webapp/**'
      - '.github/workflows/echo-webapp.yml'

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Setup .NET
      uses: actions/setup-dotnet@v2
      with:
        dotnet-version: 6.0.x
    - name: Restore dependencies
      run: |
        dotnet restore echo-webapp/echo-webapp.csproj
    
    - name: Build
      run: |
        dotnet build --no-restore echo-webapp/echo-webapp.csproj

  publish:
    if: github.ref == 'refs/heads/main'
    env:
      DOCKER_USER: ${{ secrets.DOCKER_USER }}
      DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
      IMAGE_NAME: ${{ secrets.DOCKER_USER }}/aptiv-echo/webapp:${{ github.run_id }}

    runs-on: ubuntu-latest
    needs: build

    steps:
      - uses: actions/checkout@v3
      - name: Login to DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ env.DOCKER_USER }}
          password: ${{ env.DOCKER_PASSWORD }}

      - run: |
          docker build -f Dockerfile -t ${{ env.IMAGE_NAME}} echo-webapp
          docker push ${{ env.IMAGE_NAME}}
```

Take your time to have a look on this file and check how similar they are.

## Run workflow

Now let's run your workflows.

To do that you only need to push your new files to your remote repo using the following commands.

```bash
git add -A
git commit -m "Added github workflows"
git push
```

Now navigate to your repo on GitHub Web Interface and click on `Actions` menu.

![GH Actions Menu](images/lab06/image04.png "GH Actions Menu")

You should get an output similar with this one and you can navigate on several screens to check the result of your workflows.

![GH Actions](images/lab06/image05.png "GH Actions")

Finally let's push on another branch to confirm that `publish` stage only runs when you make changes on `main` branch and workflows run independently.

On you local repo, create a new branch and move to it.

```bash
git checkout -b change-homepage
```

Then open the file `echo-webapp\Pages\Index.cshtml`, go to line 10 and change this:

```html
<h1 class="display-4">Echo WebApp</h1>
```

To this:

```html
<h1 class="display-4">New Echo WebApp</h1>
```

Save the change, commit to your local branch and push it to remote repo.

```bash
git commit -a -m "Changes homepage h1"
git push -u origin change-homepage
```

Now navigate to GitHub Web Interface and check that workflow for `echo-webapp` started and only runs `build` stage.

Congratulations! You now have a CI pipeline that automatically runs as soon as you make changes on your GitHub repo!
