# 使用費徵收案件管理平台

## 快速開始

### 1. 安裝依賴

```bash
npm install
```

### 2. 本地開發

```bash
npm run dev
```

### 3. 建置

```bash
npm run build
```

建置輸出在 `dist/` 目錄。

### 4. 部署到 Cloudflare Pages

**方式 A：Git 連接（推薦）**

1. 將程式碼推送到 GitHub/GitLab
2. [Cloudflare Dashboard](https://dash.cloudflare.com/) → Workers & Pages → Create → Pages → Connect to Git
3. 選擇儲存庫，專案名稱：「TIDP-SUFee」
4. Build command: `npm run build`
5. Build output directory: `dist`
6. 在 Environment variables 新增 `GEMINI_API_KEY`（Encrypt）

**方式 B：Wrangler CLI**

```bash
npm install -g wrangler
wrangler login
npm run build
wrangler pages deploy dist --project-name="TIDP-SUFee"
```

設定 Secret：
```bash
wrangler pages secret put GEMINI_API_KEY
# 依提示輸入你的 Gemini API Key
```

## 專案結構

- `src/` - 前端 React 應用
- `functions/api/` - Cloudflare Functions（Gemini API 後端代理）
- `lib/gemini-api.ts` - 前端 Gemini 呼叫封裝（備用，主要使用 `src/lib/`）
