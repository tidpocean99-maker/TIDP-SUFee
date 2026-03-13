/**
 * Gemini API 前端呼叫封裝
 * 透過 Cloudflare Function 後端代理呼叫，不暴露 API Key
 */

const GEMINI_API_PATH = '/api/gemini';

export interface GeminiMessage {
  role?: 'user' | 'model';
  parts: Array<{ text: string }>;
}

export interface GeminiRequest {
  model?: string;
  contents: GeminiMessage[];
  generationConfig?: {
    temperature?: number;
    topK?: number;
    topP?: number;
    maxOutputTokens?: number;
  };
}

export interface GeminiResponse {
  candidates?: Array<{
    content?: { parts?: Array<{ text?: string }> };
    finishReason?: string;
  }>;
  error?: { message?: string };
}

/**
 * 透過後端代理呼叫 Gemini API
 */
export async function callGemini(request: GeminiRequest): Promise<GeminiResponse> {
  const response = await fetch(GEMINI_API_PATH, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      model: request.model || 'gemini-1.5-flash',
      contents: request.contents,
      generationConfig: request.generationConfig,
    }),
  });

  const data = await response.json();

  if (!response.ok) {
    throw new Error(data.error?.message || data.message || 'Gemini API 請求失敗');
  }

  return data;
}

/**
 * 簡化版：傳入文字，取得 AI 回覆
 */
export async function chatWithGemini(prompt: string): Promise<string> {
  const response = await callGemini({
    contents: [{ role: 'user', parts: [{ text: prompt }] }],
  });

  const text = response.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!text) {
    throw new Error(response.error?.message || '無法取得回覆');
  }

  return text;
}
