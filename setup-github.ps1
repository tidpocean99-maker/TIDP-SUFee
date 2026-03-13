# 一鍵設定 GitHub：建立儲存庫、推送、設定 Secrets
# 需要：GitHub Personal Access Token (需 repo 權限)
# 執行前請設定環境變數：$env:GITHUB_TOKEN = "你的token"

param(
    [string]$GitHubUser = "",
    [string]$RepoName = "TIDP-SUFee",
    [string]$CloudflareToken = "",
    [string]$CloudflareAccountId = ""
)

$ErrorActionPreference = "Stop"

# 檢查 Token
$token = $env:GITHUB_TOKEN
if (-not $token) {
    Write-Host "請先設定 GITHUB_TOKEN 環境變數：" -ForegroundColor Yellow
    Write-Host '  $env:GITHUB_TOKEN = "ghp_xxxxxxxx"' -ForegroundColor White
    Write-Host ""
    $token = Read-Host "或在此輸入 GitHub Token（Enter 跳過）"
}
if (-not $token) {
    Write-Host "未提供 Token，僅顯示手動步驟。" -ForegroundColor Yellow
}

# 取得 GitHub 使用者名稱
if (-not $GitHubUser) {
    try {
        $headers = @{ Authorization = "token $token" }
        $user = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers
        $GitHubUser = $user.login
        Write-Host "GitHub 使用者: $GitHubUser" -ForegroundColor Green
    } catch {
        $GitHubUser = Read-Host "請輸入 GitHub 使用者名稱"
    }
}

$repoUrl = "https://github.com/$GitHubUser/$RepoName"

# 步驟 1：建立儲存庫
Write-Host "`n=== 步驟 1：建立儲存庫 ===" -ForegroundColor Cyan
if ($token) {
    try {
        $body = @{
            name = $RepoName
            description = "使用費徵收案件管理平台"
            private = $false
        } | ConvertTo-Json
        $headers = @{
            Authorization = "Bearer $token"
            "Content-Type" = "application/json"
        }
        Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Body $body -Headers $headers
        Write-Host "已建立儲存庫: $repoUrl" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response.StatusCode -eq 422) {
            Write-Host "儲存庫已存在: $repoUrl" -ForegroundColor Yellow
        } else {
            Write-Host "建立失敗: $_" -ForegroundColor Red
        }
    }
} else {
    Write-Host "請手動建立: $repoUrl" -ForegroundColor Yellow
    Start-Process "https://github.com/new?name=$RepoName&description=使用費徵收案件管理平台"
}

# 步驟 2：推送程式碼
Write-Host "`n=== 步驟 2：推送程式碼 ===" -ForegroundColor Cyan
if (Get-Command git -ErrorAction SilentlyContinue) {
    if (-not (Test-Path .git)) {
        git init
        git add .
        git commit -m "Initial commit"
        git branch -M main
        git remote add origin "https://github.com/$GitHubUser/$RepoName.git"
        git push -u origin main
        Write-Host "推送完成" -ForegroundColor Green
    } else {
        git add .
        git status
        git commit -m "Update" 2>$null
        git push origin main
        Write-Host "推送完成" -ForegroundColor Green
    }
} else {
    Write-Host "未安裝 Git，請手動執行：" -ForegroundColor Red
    Write-Host "  git init" -ForegroundColor White
    Write-Host "  git add ." -ForegroundColor White
    Write-Host "  git commit -m `"Initial commit`"" -ForegroundColor White
    Write-Host "  git remote add origin $repoUrl.git" -ForegroundColor White
    Write-Host "  git push -u origin main" -ForegroundColor White
}

# 步驟 3：設定 Secrets
Write-Host "`n=== 步驟 3：設定 Secrets ===" -ForegroundColor Cyan
if (Get-Command gh -ErrorAction SilentlyContinue) {
    if ($CloudflareToken) { gh secret set CLOUDFLARE_API_TOKEN --body $CloudflareToken }
    if ($CloudflareAccountId) { gh secret set CLOUDFLARE_ACCOUNT_ID --body $CloudflareAccountId }
    if ($CloudflareToken -or $CloudflareAccountId) {
        Write-Host "Secrets 已設定" -ForegroundColor Green
    } else {
        Write-Host "請執行以下指令設定 Secrets：" -ForegroundColor Yellow
        Write-Host "  gh secret set CLOUDFLARE_API_TOKEN" -ForegroundColor White
        Write-Host "  gh secret set CLOUDFLARE_ACCOUNT_ID" -ForegroundColor White
    }
} else {
    Write-Host "未安裝 GitHub CLI，請手動設定：" -ForegroundColor Yellow
    Write-Host "  開啟: $repoUrl/settings/secrets/actions" -ForegroundColor White
    Start-Process "$repoUrl/settings/secrets/actions"
}

Write-Host "`n完成！前往 Actions 執行部署：$repoUrl/actions" -ForegroundColor Green
Start-Process "$repoUrl/actions"
