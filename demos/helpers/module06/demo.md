# Module 06 - Demo Script

## 1. Unit Testing

1) Create repo `XXXX-calclib` with template calc-lib
2) Clone repo
3) `dotnet new xunit -o CalcLib.Tests`
4) `cd CalcLib.Tests`
5) `dotnet add reference ../CalcLib/CalcLib.csproj`
6) Add CalcTests_Add.cs class
7) Create method `Add_FixNumbers`
8) `dotnet build`
9) `dotnet test`
10) Create additional methods
11) `dotnet build`
12) `dotnet test`
13) `dotnet test --collect "XPlat Code Coverage" -r ./testresults`
14) `reportgenerator -reports:"./testresults/XXXX/coverage.cobertura.xml" -targetdir:"./testresults/coveragereport" -reporttypes:Html`
15) LiveServer to see html
16) dotnet test --filter CalcTests_Add
17) dotnet test --filter Add_PositiveNumbers

## 2. TDD

1) Create file CalcTests_Prime.cs
2) Add Facts methods
3) `dotnet test`
4) Create IsPrime method with exception
5) `dotnet test`
6) Add code to IsPrime method
7) `dotnet test`
8) Add Theory methods
9) `dotnet test`
10) `dotnet test --filter CalcTests_Prime --collect "XPlat Code Coverage" -r ./testresults`
11) `reportgenerator -reports:"./testresults/XXXX/coverage.cobertura.xml" -targetdir:"./testresults/coveragereport_prime" -reporttypes:Html`

## 3. Test Automation

1) Create Action directly on GitHub Website
2) Run to see tests running
3) Add TestReport
4) Check that workflow ran automatically
5) Check Test Report
