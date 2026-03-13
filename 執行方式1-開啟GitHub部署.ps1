# 執行方式 1：透過 GitHub Actions 部署
# 此腳本會開啟 GitHub Actions 頁面，請手動點擊 Run workflow

Write-Host "=== 執行方式 1：GitHub Actions 部署 ===" -ForegroundColor Cyan
Write-Host ""

# 請將下方改為你的 GitHub 儲存庫網址（例如：https://github.com/username/TIDP-SUFee）
$RepoUrl = "https://github.com"  # 改為你的儲存庫，例如 "https://github.com/你的帳號/TIDP-SUFee"
$ActionsUrl = if ($RepoUrl -match "github\.com/[^/]+/[^/]+") { "$RepoUrl/actions" } else { "https://github.com" }

Write-Host "步驟 1：確認專案已推送到 GitHub" -ForegroundColor Yellow
Write-Host "  若尚未推送，請先執行：" -ForegroundColor Gray
Write-Host "  git init" -ForegroundColor White
Write-Host "  git add ." -ForegroundColor White
Write-Host "  git commit -m `"Initial commit`"" -ForegroundColor White
Write-Host "  git remote add origin $RepoUrl" -ForegroundColor White
Write-Host "  git push -u origin main" -ForegroundColor White
Write-Host ""

Write-Host "步驟 2：確認已設定 GitHub Secrets" -ForegroundColor Yellow
Write-Host "  CLOUDFLARE_API_TOKEN" -ForegroundColor White
Write-Host "  CLOUDFLARE_ACCOUNT_ID" -ForegroundColor White
Write-Host ""

Write-Host "步驟 3：開啟 GitHub Actions 並執行部署" -ForegroundColor Yellow
Write-Host "  即將開啟瀏覽器..." -ForegroundColor Gray

# 開啟 Actions 頁面
Start-Process $ActionsUrl

Write-Host ""
Write-Host "在開啟的頁面中：" -ForegroundColor Cyan
Write-Host "  1. 點選左側 'Deploy to Cloudflare Pages'" -ForegroundColor White
Write-Host "  2. 點選右側 'Run workflow' 按鈕" -ForegroundColor White
Write-Host "  3. 再點 'Run workflow' 確認" -ForegroundColor White
Write-Host ""
Write-Host "完成！" -ForegroundColor Green
