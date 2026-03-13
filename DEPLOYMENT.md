# Cloudflare 部署指南 - TIDP-SUFee（使用費徵收案件管理平台）

## 專案結構

```
├── src/                 # 前端原始碼
│   ├── lib/gemini-api.ts
│   ├── App.tsx
│   └── main.tsx
├── functions/api/       # Cloudflare Functions（Gemini 後端代理）
│   └── gemini.ts
├── package.json
├── vite.config.ts
└── wrangler.toml
```

## 一、Cloudflare Functions 結構

已建立 Gemini API 後端代理，避免在前端暴露 API Key：

```
functions/
└── api/
    └── gemini.ts    # Gemini API 代理端點
```

**API 端點**：部署後為 `https://<你的網域>/api/gemini`

## 二、設定 GEMINI_API_KEY Secret

1. 登入 [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. 進入 **Workers & Pages** → 選擇專案「使用費徵收案件管理平台」
3. **Settings** → **Environment variables**
4. 新增變數：
   - **Variable name**: `GEMINI_API_KEY`
   - **Value**: 你的 Gemini API Key
   - 勾選 **Encrypt**（加密儲存）

## 三、前端呼叫方式

專案已建立 `lib/gemini-api.ts` 封裝，可直接使用：

```typescript
import { callGemini, chatWithGemini } from '@/lib/gemini-api';  // 或 'lib/gemini-api'

// 方式 1：完整請求
const response = await callGemini({
  model: 'gemini-1.5-flash',
  contents: [{ role: 'user', parts: [{ text: '你好' }] }],
});

// 方式 2：簡化版（傳入文字取得回覆）
const reply = await chatWithGemini('請幫我總結這段文字');
```

**若需手動呼叫：**
```typescript
const response = await fetch('/api/gemini', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    model: 'gemini-1.5-flash',
    contents: [...],
    generationConfig: {...},
  }),
});
```

請將專案中原本直接使用 Gemini API Key 的程式碼改為使用上述方式。

## 四、部署步驟

### 方式 A：透過 Git 連接（推薦）

1. 將程式碼推送到 GitHub/GitLab
2. Cloudflare Dashboard → **Workers & Pages** → **Create** → **Pages** → **Connect to Git**
3. 選擇儲存庫，專案名稱設為「使用費徵收案件管理平台」
4. **Build settings**：
   - Build command: `npm run build`（或 `pnpm build`）
   - Build output directory: `dist`（Vite）或 `build`（CRA）
5. **Environment variables**：新增 `GEMINI_API_KEY`（Encrypt）
6. 部署

### 方式 B：Wrangler CLI 部署

```bash
# 安裝 Wrangler
npm install -g wrangler

# 登入 Cloudflare
wrangler login

# 建置專案
npm run build

# 部署到 Pages
wrangler pages deploy dist --project-name="使用費徵收案件管理平台"
```

## 五、注意事項

- `functions/` 目錄會隨專案一併部署，無需額外設定
- 若建置輸出目錄不是 `dist`，請修改 `wrangler.toml` 中的 `pages_build_output_dir`
- 部署後請確認 `/api/gemini` 可正常回應
