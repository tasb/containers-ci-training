# Lab 05 - Unit testing

On this lab you'll add unit testing to a Echo API and generate the reports for code coverage.

## On this lab

- [Add unit tests](#add-unit-tests)
- [Create container to run tests](#create-container-to-run-tests)
- [Run tests](#run-tests)
- [Check reports](#check-reports)

## Add unit tests

To run unit tests you need to create the tests cases to check if your code is correctly implemented (since we didn't followed a TDD approach).

Take a look into `echo-api/Program.cs` and check that your API have 3 methods:

- `GET /echo/{message}` that return the message sent on URL and save the request on a database
- `GET /log` that return all history on database
- `DELETE /log` that deletes all history from database

Regarding this you need at least 3 tests cases to test those methods.

Open `echo-api.tests/EchoAPITests.cs` file and start to add the constructor to get access to your API and make the requests.

```csharp
private readonly EchoApiApplication _app;
    
public EchoAPITests() {
    _app = new EchoApiApplication();
}
```

Let's start to add a test for `GET /echo/{message}` method.

```csharp
[InlineData("teste")]
[InlineData("TESTE")]
[InlineData("aptiv")]
[Theory]
public async Task EchoMessage(string message)
{
    var client = _app.CreateClient();
    var response = await client.GetAsync($"/echo/{message}");
    Assert.Equal(HttpStatusCode.OK, response.StatusCode);

    var responseString = response.Content.ReadFromJsonAsync<string>();
    Assert.Equal(message, responseString.Result);
}
```

This test case will be run 3 times using different messages to check if it's echoed properly. Each message is defined on `InlineData` attributes.

You may chose different messages or even add more tests if you wish.

Then, let's start add a test for `GET /log` method.

```csharp
[Fact]
public async Task GetEchoHistory()
{
    var messages = new List<string> { 
        "message1", 
        "message2", 
        "message3" 
    };

    var expectedLog = new List<string> { 
        "Echoing message: message1", 
        "Echoing message: message2", 
        "Echoing message: message3" 
    };
    var client = _app.CreateClient();
    var response = await client.DeleteAsync($"/log");
    Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    
    response = await client.GetAsync($"/echo/{messages[0]}");
    Assert.Equal(HttpStatusCode.OK, response.StatusCode);

    response = await client.GetAsync($"/echo/{messages[1]}");
    Assert.Equal(HttpStatusCode.OK, response.StatusCode);

    response = await client.GetAsync($"/echo/{messages[2]}");
    Assert.Equal(HttpStatusCode.OK, response.StatusCode);

    response = await client.GetAsync($"/log");
    Assert.Equal(HttpStatusCode.OK, response.StatusCode);

    var logList = response.Content.ReadFromJsonAsync<List<EchoHistory>>().Result;
    Assert.Equal(3, logList!.Count);

    Assert.Equal(expectedLog[0], logList[0].Message);
    Assert.Equal(expectedLog[1], logList[1].Message);
    Assert.Equal(expectedLog[2], logList[2].Message);
}
```

Take a look on this test case and check that 5 operations are made:

- Clear database
- Make 3 new echo requests
- Get history list and check if the returned values are the expected ones

You need to perform all these operations since each test case needs to be independent (not run after another) and cannot expect a specific order (using out-of-the-box settings) when running the test cases.

Finally, let's add a test case for `DELETE /log` message.

```csharp
[Fact]
public async Task ClearEchoHistory()
{
    var messages = new List<string> { 
        "message1", 
        "message2", 
        "message3" 
    };

    var client = _app.CreateClient();
    var response = await client.DeleteAsync($"/log");
    Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    
    response = await client.GetAsync($"/echo/{messages[0]}");
    Assert.Equal(HttpStatusCode.OK, response.StatusCode);

    response = await client.GetAsync($"/echo/{messages[1]}");
    Assert.Equal(HttpStatusCode.OK, response.StatusCode);

    response = await client.GetAsync($"/echo/{messages[2]}");
    Assert.Equal(HttpStatusCode.OK, response.StatusCode);

    response = await client.DeleteAsync($"/log");
    Assert.Equal(HttpStatusCode.OK, response.StatusCode);

    var deletedRecords = response.Content.ReadFromJsonAsync<int>().Result;
    Assert.Equal(3, deletedRecords);
}
```

This test case performs 5 operations too:

- Clear database
- Make 3 new echo requests
- Clear database again and check if the response is correct (this method returns the number of deleted records)

Just to make sure your file was created right, at the end your file should have this content.

```csharp
using System.Collections.Generic;
using System.Net;
using System.Net.Http.Json;
using System.Threading.Tasks;
using echo_api.Models;
using Xunit;

namespace echo_api.tests;

public class EchoAPITests
{
    private readonly EchoApiApplication _app;
    public EchoAPITests() {
        _app = new EchoApiApplication();
    }

    [InlineData("teste")]
    [InlineData("TESTE")]
    [InlineData("aptiv")]
    [Theory]
    public async Task EchoMessage(string message)
    {
        var client = _app.CreateClient();
        var response = await client.GetAsync($"/echo/{message}");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        var responseString = response.Content.ReadFromJsonAsync<string>();
        Assert.Equal(message, responseString.Result);
    }

    [Fact]
    public async Task GetEchoHistory()
    {
        var messages = new List<string> { 
            "message1", 
            "message2", 
            "message3" 
        };

        var expectedLog = new List<string> { 
            "Echoing message: message1", 
            "Echoing message: message2", 
            "Echoing message: message3" 
        };
        var client = _app.CreateClient();
        var response = await client.DeleteAsync($"/log");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        
        response = await client.GetAsync($"/echo/{messages[0]}");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        response = await client.GetAsync($"/echo/{messages[1]}");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        response = await client.GetAsync($"/echo/{messages[2]}");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        response = await client.GetAsync($"/log");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        var logList = response.Content.ReadFromJsonAsync<List<EchoHistory>>().Result;
        Assert.Equal(3, logList!.Count);

        Assert.Equal(expectedLog[0], logList[0].Message);
        Assert.Equal(expectedLog[1], logList[1].Message);
        Assert.Equal(expectedLog[2], logList[2].Message);
    }

    [Fact]
    public async Task ClearEchoHistory()
    {
        var messages = new List<string> { 
            "message1", 
            "message2", 
            "message3" 
        };

        var client = _app.CreateClient();
        var response = await client.DeleteAsync($"/log");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        
        response = await client.GetAsync($"/echo/{messages[0]}");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        response = await client.GetAsync($"/echo/{messages[1]}");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        response = await client.GetAsync($"/echo/{messages[2]}");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        response = await client.DeleteAsync($"/log");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        var deletedRecords = response.Content.ReadFromJsonAsync<int>().Result;
        Assert.Equal(3, deletedRecords);
    }

}
```

If you recall, your API uses a MS SQL Server as database to keep history records but regarding unit testing you should not rely on external resources to run your tests.

On this case, you are using one of the most important patterns on Unit Testing that is Dependency Injection. On this case, you use it to change the MS SQL Server database to a in-memory database to make your unit tests not relying on external resource.

You may check `echo-api.tests/EchoAPIMock.cs` file to see how this is done.

## Create container to run tests

On this lab we'll use a container to run our tests. With this approach you are totally autonomous regarding the machine you use to run the tests, since you have docker (or other container runtime) installed.

First, let's create a shell script to run the tests and generate the HTML report.

On root dir, create a file named `run-tests.sh` with the following content.

```bash
#!/bin/bash

dotnet test --collect "XPlat Code Coverage" -r ./testresults

DATE_WITH_TIME=`date "+%Y%m%d%H%M%S"`
OUTPUT_FOLDER="/testresults/${DATE_WITH_TIME}"

mkdir $OUTPUT_FOLDER

reportgenerator -reports:"./testresults/*/coverage.cobertura.xml" -targetdir:"${OUTPUT_FOLDER}" -reporttypes:Html
```

Let's check what this script does:

- First run `dotnet test` to execute unit tests
- Then you create some variables and a folder to make sure each run generates HTML reports to a different folder (folder name format: YYYYmmddHHMMss)
- Finally runs `reportgenerator` command to create HTML report

Now, to run a container you need an image and to have an image you need a Dockerfile.

Create a file named `Dockerfile.test` on root dir with following content.

```Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build

RUN dotnet tool install --global dotnet-reportgenerator-globaltool --version 5.1.10

ENV PATH="${PATH}:/root/.dotnet/tools"

WORKDIR "/src/echo-api"
COPY ["echo-api/echo-api.csproj", "."]

RUN dotnet restore "echo-api.csproj"
COPY echo-api .
RUN dotnet build "echo-api.csproj" -c Debug -o /app/build

WORKDIR "/src/echo-api.tests"
COPY ["echo-api.tests/echo-api.tests.csproj", "."]

RUN dotnet restore "echo-api.tests.csproj"
COPY echo-api.tests .
RUN dotnet build "echo-api.tests.csproj" -c Debug -o /app/build

COPY run-tests.sh .

RUN chmod +x run-tests.sh

CMD "./run-tests.sh"
```

Let's take a deeper look on those file.

First, the base image is a dotnet SDK with all tools needed to build projects and run tests.

```Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
```

Then, you need to install `reportgenerator` tools and add it to `PATH` to run the command added on shell script previously created.

```Dockerfile
RUN dotnet tool install --global dotnet-reportgenerator-globaltool --version 5.1.10

ENV PATH="${PATH}:/root/.dotnet/tools"
```

Then, your `echo-api` and `echo-api.tests` projects are restored and build to ensure everything is ready to run the tests.

```Dockerfile
WORKDIR "/src/echo-api"
COPY ["echo-api/echo-api.csproj", "."]

RUN dotnet restore "echo-api.csproj"
COPY echo-api .
RUN dotnet build "echo-api.csproj" -c Debug -o /app/build

WORKDIR "/src/echo-api.tests"
COPY ["echo-api.tests/echo-api.tests.csproj", "."]

RUN dotnet restore "echo-api.tests.csproj"
COPY echo-api.tests .
RUN dotnet build "echo-api.tests.csproj" -c Debug -o /app/build
```

Finally you prepare your image to run the tests and generate the reports adding the previously created shell script to your image, change its permissions to allow it to be executed and finally set CMD command on bash mode.

```Dockerfile
COPY run-tests.sh .

RUN chmod +x run-tests.sh

CMD "./run-tests.sh"
```

On this case, CMD was selected instead of ENTRYPOINT to allow you to run a container using this image without running automatically the tests and allowing you to run it manually if you want.

Now that you have your Dockerfile ready, you may build your image.

```bash
docker build -t echo-api:unit-tests -f Dockerfile.test .
```

## Run tests

After your `docker build` command finish successfully, you can run it to check if you pass all unit tests and generate your reports.

But before doing that, you need to create a folder on your machine to be used on a bind mount to allow you to have access to generated reports.

```bash
mkdir /tmp/tests
```

Now let's run the container.

```bash
docker run --mount type=bind,source=/tmp/tests,target=/testresults echo-api:unit-tests
```

Not using `-d` flag allow you to check on your console all the outputs produced when tests are running and success message written by `reportgenerator` tool after successfully generate the reports.

## Check reports

Now, navigate to the folder you created previously using a File Explorer, find the folder with `YYYYmmddHHMMss` format and click on `index.html` file inside it.

Congratulations! You have just finished this lab and using an alternative wa to use containers to be an helper on your development and testing phase!
