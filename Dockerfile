FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY ["RaceDay.Web/RaceDay.Web.csproj", "RaceDay.Web/"]
COPY ["RaceDayAPI/RaceDayAPI.csproj", "RaceDayAPI/"]
RUN dotnet restore "RaceDay.Web/RaceDay.Web.csproj"
COPY . .
WORKDIR "/src/RaceDay.Web"
RUN dotnet build "RaceDay.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RaceDay.Web.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RaceDay.Web.dll"]