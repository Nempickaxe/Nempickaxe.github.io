(() => {
  const root = document.documentElement;
  const themeBtn = document.getElementById('theme-btn');

  // Theme: saved choice, else system preference.
  const saved = localStorage.getItem('cv-theme');
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  root.dataset.theme = saved || (prefersDark ? 'dark' : 'light');

  themeBtn.addEventListener('click', () => {
    const next = root.dataset.theme === 'dark' ? 'light' : 'dark';
    root.dataset.theme = next;
    localStorage.setItem('cv-theme', next);
  });
})();
