# TIDP-SUFee 部署腳本
# 部署到 Cloudflare Pages

$ProjectName = "TIDP-SUFee"

Write-Host "=== TIDP-SUFee 部署到 Cloudflare Pages ===" -ForegroundColor Cyan

# 檢查 Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "錯誤：未找到 Node.js，請先安裝 Node.js (https://nodejs.org/)" -ForegroundColor Red
    exit 1
}

# 安裝依賴
Write-Host "`n1. 安裝依賴..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -ne 0) { exit 1 }

# 建置
Write-Host "`n2. 建置專案..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) { exit 1 }

# 檢查 dist 是否存在
if (-not (Test-Path dist)) {
    Write-Host "錯誤：建置失敗，dist 目錄不存在" -ForegroundColor Red
    exit 1
}

# 部署
Write-Host "`n3. 部署到 Cloudflare Pages..." -ForegroundColor Yellow
npx wrangler pages deploy dist --project-name=$ProjectName
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "`n部署完成！" -ForegroundColor Green
Write-Host "請在 Cloudflare Dashboard 設定 GEMINI_API_KEY Secret" -ForegroundColor Cyan
