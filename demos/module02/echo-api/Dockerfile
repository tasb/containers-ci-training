FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal

LABEL turma=aptiv

EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80

WORKDIR /app
COPY ./publish .

ENTRYPOINT ["dotnet", "echo-api.dll"]
