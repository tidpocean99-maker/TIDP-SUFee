# 直接部署到 Cloudflare Pages（不使用 GitHub）
# 需要：Node.js、Cloudflare API Token、Account ID
# 用法：.\deploy-direct.ps1
# 或設定環境變數後執行：$env:CLOUDFLARE_API_TOKEN="xxx"; $env:CLOUDFLARE_ACCOUNT_ID="xxx"; .\deploy-direct.ps1

$ErrorActionPreference = "Stop"

# 檢查 Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "錯誤：未找到 Node.js，請從 https://nodejs.org/ 安裝" -ForegroundColor Red
    exit 1
}

# 取得憑證
$token = $env:CLOUDFLARE_API_TOKEN
$accountId = $env:CLOUDFLARE_ACCOUNT_ID
if (-not $token) { $token = Read-Host "請輸入 CLOUDFLARE_API_TOKEN" }
if (-not $accountId) { $accountId = Read-Host "請輸入 CLOUDFLARE_ACCOUNT_ID" }

Write-Host "`n=== 直接部署到 Cloudflare Pages ===" -ForegroundColor Cyan

Write-Host "`n1. 安裝依賴..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "`n2. 建置專案..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) { exit 1 }

if (-not (Test-Path dist)) {
    Write-Host "錯誤：dist 目錄不存在" -ForegroundColor Red
    exit 1
}

Write-Host "`n3. 部署到 Cloudflare Pages..." -ForegroundColor Yellow
$env:CLOUDFLARE_API_TOKEN = $token
$env:CLOUDFLARE_ACCOUNT_ID = $accountId
npx wrangler pages deploy dist --project-name=TIDP-SUFee
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "`n部署完成！" -ForegroundColor Green
