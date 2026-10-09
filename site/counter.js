const counter = document.querySelector('.counter-value');
async function updateCounter() {
  if (!counter) return;
  try {
    const response = await fetch('https://mwnbduxsvf3jrrcsakvk2oa7hq0jxfhh.lambda-url.us-east-1.on.aws/', { signal: AbortSignal.timeout(8000) });
    if (!response.ok) throw new Error('Counter request failed');
    const data = await response.json();
    const count = Number(data);
    if ((typeof data !== 'number' && typeof data !== 'string') || data === '' || !Number.isSafeInteger(count) || count < 0) throw new Error('Invalid count');
    counter.textContent = count.toLocaleString();
  } catch {
    counter.textContent = '—';
    counter.parentElement.title = 'Visitor count is temporarily unavailable';
  }
}
updateCounter();
