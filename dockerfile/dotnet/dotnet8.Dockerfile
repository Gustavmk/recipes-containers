##See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
#
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app
EXPOSE 8080

# Install cultures (same approach as Alpine SDK image)
RUN apk add --no-cache icu-libs

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG VSTS_FEED='https://pkgs.dev.azure.com/killsh/_packaging/drylabs/nuget/v3/index.json'

WORKDIR /src
COPY . .

# Disable the invariant mode (set in base image)
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# nuget restore
# Install Credential Provider and set env variables to enable Nuget restore with auth
#ARG PAT
ENV NUGET_CREDENTIALPROVIDER_SESSIONTOKENCACHE_ENABLED true
ENV VSS_NUGET_EXTERNAL_FEED_ENDPOINTS "{\"endpointCredentials\": [{\"endpoint\":\"https://pkgs.dev.azure.com/killsh/_packaging/drylabs/nuget/v3/index.json\",  \"password\":\"PAT\"}]}"
RUN wget -qO- https://raw.githubusercontent.com/Microsoft/artifacts-credprovider/master/helpers/installcredprovider.sh | bash

RUN dotnet restore -s ${VSTS_FEED} -s 'https://api.nuget.org/v3/index.json' "/src/Solution.sln"  

WORKDIR "/src/Project.ConsoleApp"

RUN dotnet build "Project.ConsoleApp.csproj" -c Release --no-restore -o /app/build -v minimal

FROM build AS publish
RUN dotnet publish "Project.ConsoleApp.csproj" -c Release -o /app/publish


FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Project.ConsolApp.dll"]
