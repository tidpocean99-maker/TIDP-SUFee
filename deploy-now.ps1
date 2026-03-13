# deploy-now.ps1 - 新增 remote 並推送到 GitHub
# 用法: .\deploy-now.ps1 -Username YOUR_GITHUB_USERNAME

param(
    [Parameter(Mandatory=$false)]
    [string]$Username = ""
)
if (-not $Username) { $Username = Read-Host "GitHub username" }

$ErrorActionPreference = "Stop"
$ProjectRoot = $PSScriptRoot
$GitPath = "C:\Program Files\Git\bin\git.exe"

$RemoteUrl = "https://github.com/$Username/TIDP-SUFee.git"

Write-Host "設定 remote origin: $RemoteUrl"
& $GitPath -C $ProjectRoot remote remove origin 2>$null
& $GitPath -C $ProjectRoot remote add origin $RemoteUrl

Write-Host "推送到 origin main..."
& $GitPath -C $ProjectRoot push -u origin main
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "完成。"