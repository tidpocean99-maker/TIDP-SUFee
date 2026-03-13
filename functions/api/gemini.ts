/**
 * Cloudflare Function: Gemini API 後端代理
 * 將 Gemini API 呼叫移至後端，避免在前端暴露 API Key
 * API Key 請在 Cloudflare Dashboard 的 Secrets 中設定為 GEMINI_API_KEY
 */

interface Env {
  GEMINI_API_KEY: string;
}

export const onRequestPost = async (
  context: { request: Request; env: Env }
) => {
  const { request, env } = context;

  // 從 Cloudflare Secrets 取得 API Key
  const apiKey = env.GEMINI_API_KEY;
  if (!apiKey) {
    return new Response(
      JSON.stringify({ error: 'GEMINI_API_KEY 未設定，請在 Cloudflare Secrets 中設定' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }

  try {
    // 取得前端傳來的請求內容
    const body = await request.json() as {
      contents?: Array<{ role?: string; parts?: Array<{ text?: string }> }>;
      generationConfig?: Record<string, unknown>;
      model?: string;
    };

    const model = body.model || 'gemini-1.5-flash';
    const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`;

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        contents: body.contents,
        generationConfig: body.generationConfig,
      }),
    });

    const data = await response.json();

    if (!response.ok) {
      return new Response(JSON.stringify(data), {
        status: response.status,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    return new Response(JSON.stringify(data), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
    });
  } catch (error) {
    console.error('Gemini API 錯誤:', error);
    return new Response(
      JSON.stringify({
        error: 'Gemini API 請求失敗',
        message: error instanceof Error ? error.message : 'Unknown error',
      }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
};

// 處理 CORS preflight
export const onRequestOptions = async () => {
  return new Response(null, {
    status: 204,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
      'Access-Control-Max-Age': '86400',
    },
  });
};
