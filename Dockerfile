# 1. Gebruik de .NET 9 SDK om de code te bouwen
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Kopieer alle bestanden uit je repository naar de container
COPY . .

# Bouw het opstartproject (Rise.Server) in Release-modus
RUN dotnet publish "src/Rise.Server/Rise.Server.csproj" -c Release -o /app/publish /p:UseAppHost=false

# 2. Gebruik de lichtere .NET 9 runtime om de app daadwerkelijk te draaien
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
EXPOSE 8080

# Kopieer de afgewerkte build uit de vorige stap
COPY --from=build /app/publish .

# Vertel de container hoe de applicatie gestart moet worden
ENTRYPOINT ["dotnet", "Rise.Server.dll"]