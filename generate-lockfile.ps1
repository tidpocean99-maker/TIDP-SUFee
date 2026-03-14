# Generate package-lock.json and push
# Run after installing Node.js: npm install
# Usage: .\generate-lockfile.ps1

$ErrorActionPreference = "Stop"

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "Node.js/npm not found. Install from https://nodejs.org/"
    exit 1
}

Write-Host "Running npm install..."
npm install

if (-not (Test-Path package-lock.json)) {
    Write-Host "package-lock.json was not created."
    exit 1
}

Write-Host "Adding and committing package-lock.json..."
& "C:\Program Files\Git\bin\git.exe" add package-lock.json
& "C:\Program Files\Git\bin\git.exe" commit -m "chore: add package-lock.json"
& "C:\Program Files\Git\bin\git.exe" push origin main

Write-Host "Done. You can now add cache: 'npm' back to the workflow for faster builds."
