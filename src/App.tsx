import { useState } from 'react';
import { chatWithGemini } from '@/lib/gemini-api';

function App() {
  const [prompt, setPrompt] = useState('');
  const [reply, setReply] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!prompt.trim()) return;

    setLoading(true);
    setError('');
    setReply('');

    try {
      const result = await chatWithGemini(prompt);
      setReply(result);
    } catch (err) {
      setError(err instanceof Error ? err.message : '請求失敗');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ maxWidth: 600, margin: '2rem auto', padding: '0 1rem' }}>
      <h1 style={{ marginBottom: '1rem', fontSize: '1.5rem' }}>
        使用費徵收案件管理平台
      </h1>
      <form onSubmit={handleSubmit} style={{ marginBottom: '1rem' }}>
        <textarea
          value={prompt}
          onChange={(e) => setPrompt(e.target.value)}
          placeholder="輸入問題，使用 Gemini AI 協助..."
          rows={3}
          style={{
            width: '100%',
            padding: '0.5rem',
            marginBottom: '0.5rem',
            resize: 'vertical',
          }}
          disabled={loading}
        />
        <button
          type="submit"
          disabled={loading}
          style={{
            padding: '0.5rem 1rem',
            cursor: loading ? 'not-allowed' : 'pointer',
          }}
        >
          {loading ? '處理中...' : '送出'}
        </button>
      </form>
      {error && (
        <div style={{ color: '#c00', marginBottom: '1rem' }}>{error}</div>
      )}
      {reply && (
        <div
          style={{
            padding: '1rem',
            background: '#f5f5f5',
            borderRadius: 4,
            whiteSpace: 'pre-wrap',
          }}
        >
          {reply}
        </div>
      )}
    </div>
  );
}

export default App;
