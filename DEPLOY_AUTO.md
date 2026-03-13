# 自動部署設定指南

## 方式一：GitHub Actions（推送即部署）

已建立 `.github/workflows/deploy.yml`，將程式碼推送到 GitHub 後會自動部署。

### 設定步驟

1. **將專案推送到 GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/你的帳號/你的儲存庫.git
   git push -u origin main
   ```

2. **取得 Cloudflare API Token**
   - 登入 [Cloudflare Dashboard](https://dash.cloudflare.com/)
   - 右側 **My Profile** → **API Tokens** → **Create Token**
   - 選擇 **Edit Cloudflare Workers** 範本，或自訂權限：
     - Account - Cloudflare Pages: Edit
     - Account - Account Settings: Read
   - 建立後複製 Token

3. **取得 Account ID**
   - Cloudflare Dashboard 右側欄 → **Workers & Pages** 下方可看到 Account ID

4. **在 GitHub 設定 Secrets**
   - 儲存庫 → **Settings** → **Secrets and variables** → **Actions**
   - 新增：
     - `CLOUDFLARE_API_TOKEN`：你的 API Token
     - `CLOUDFLARE_ACCOUNT_ID`：你的 Account ID

5. **推送觸發部署**
   ```bash
   git push
   ```
   每次推送到 `main` 或 `master` 分支會自動部署。

---

## 方式二：本機手動部署

若已安裝 Node.js，在本機執行：

```powershell
.\deploy.ps1
```

或：

```powershell
npm install
npm run build
npx wrangler login
npx wrangler pages deploy dist --project-name="TIDP-SUFee"
```

---

## 部署後：設定 GEMINI_API_KEY

在 Cloudflare Dashboard：
1. **Workers & Pages** → **TIDP-SUFee** → **Settings**
2. **Environment variables** → **Add**
3. 變數名稱：`GEMINI_API_KEY`
4. 值：你的 Gemini API Key
5. 勾選 **Encrypt**
