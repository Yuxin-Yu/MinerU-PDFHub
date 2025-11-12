##[
  Embedded UI assets for the OpenContext7 Inspector
]##

const inspectorLoginHtml* = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>OpenContext7 Sign In</title>
  <style>
    :root {
      font-family: "Inter", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      /* 主题颜色变量系统 - 深色主题作为默认 */
      --primary-color: #3b82f6;
      --primary-hover: #2563eb;
      --background-primary: #0f172a;
      --background-secondary: #1e293b;
      --background-tertiary: #334155;
      --text-primary: #f8fafc;
      --text-secondary: #cbd5e1;
      --text-tertiary: #94a3b8;
      --border-color: #475569;
      --success-color: #10b981;
      --error-color: #ef4444;
      --card-bg: rgba(30, 41, 59, 0.85);
      --shadow-color: rgba(0, 0, 0, 0.3);
    }
    * {
      box-sizing: border-box;
    }
    body {
      margin: 0;
      min-height: 100vh;
      background: var(--background-primary);
      color: var(--text-primary);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 32px 16px;
    }
    a {
      color: var(--primary-color);
      text-decoration: none;
    }
    a:hover {
      color: var(--primary-hover);
      text-decoration: underline;
    }
    .auth-shell {
      width: min(420px, 100%);
    }
    .auth-card {
      background: var(--card-bg);
      border: 1px solid var(--border-color);
      border-radius: 24px;
      padding: 36px;
      box-shadow: 0 30px 70px -42px var(--shadow-color);
    }
    h1 {
      margin: 0 0 6px;
      font-size: 28px;
      font-weight: 650;
    }
    p.subtitle {
      margin: 0 0 24px;
      color: var(--text-tertiary);
      font-size: 14px;
    }
    form {
      display: flex;
      flex-direction: column;
      gap: 18px;
    }
    label {
      font-size: 13px;
      color: var(--text-secondary);
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    input {
      border-radius: 14px;
      border: 1px solid var(--border-color);
      background: var(--background-secondary);
      color: var(--text-primary);
      padding: 12px;
      font-size: 15px;
      transition: border-color 0.2s ease;
    }
    button {
      border: none;
      border-radius: 14px;
      padding: 12px 18px;
      font-size: 15px;
      font-weight: 600;
      background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
      color: #fff;
      cursor: pointer;
      margin-top: 8px;
      transition: opacity 0.2s ease;
    }
    button:disabled {
      opacity: 0.6;
      cursor: not-allowed;
    }
    .status {
      margin-top: 16px;
      font-size: 13px;
      color: var(--text-tertiary);
    }
    .status.error {
      color: var(--error-color);
    }
    .links {
      margin-top: 18px;
      font-size: 13px;
      color: var(--text-secondary);
      text-align: center;
    }
    body.loading button {
      opacity: 0.7;
      pointer-events: none;
    }
    body.light-theme {
      /* 浅色主题颜色变量 */
      --primary-color: #2563eb;
      --primary-hover: #1d4ed8;
      --background-primary: #f8fafc;
      --background-secondary: #f1f5f9;
      --background-tertiary: #e2e8f0;
      --text-primary: #0f172a;
      --text-secondary: #334155;
      --text-tertiary: #64748b;
      --border-color: #cbd5e1;
      --success-color: #059669;
      --error-color: #dc2626;
      --card-bg: rgba(255, 255, 255, 0.95);
      --shadow-color: rgba(0, 0, 0, 0.1);
      color-scheme: light;
      background: var(--background-primary);
      color: var(--text-primary);
    }
    /* 浅色主题特定调整（大部分样式已通过CSS变量处理） */
    body.light-theme input::placeholder {
      color: var(--text-tertiary);
    }
  </style>
</head>
<body class="dark-theme">
  <div class="auth-shell">
    <section class="auth-card">
      <h1>OpenContext7</h1>
      <p class="subtitle">Sign in to access the local MCP console.</p>
      <form id="loginForm">
        <label>
          Username
          <input id="loginUsername" type="text" autocomplete="username" placeholder="you">
        </label>
        <label>
          Password
          <input id="loginPassword" type="password" autocomplete="current-password" placeholder="••••••••">
        </label>
        <button id="loginSubmit" type="submit">Sign In</button>
        <p class="status" id="loginStatus">Enter your account credentials to continue.</p>
      </form>
      <p class="links">
        Need an account?
        <a href="/ui/register">Create one here</a>
      </p>
    </section>
  </div>
  <script>
    const tokenStorageKey = "opencontext7.authToken";
    const themeStorageKey = "opencontext7.theme";
    const form = document.getElementById("loginForm");
    const usernameField = document.getElementById("loginUsername");
    const passwordField = document.getElementById("loginPassword");
    const statusEl = document.getElementById("loginStatus");

    function toggleAdminSettings() {}
    function setAdminFeaturesEnabled() {}
    function applyThemePreference(theme, persist = true) {
      const normalized = theme === "light" ? "light" : "dark";
      document.body.classList.remove("light-theme", "dark-theme");
      document.body.classList.add(normalized === "light" ? "light-theme" : "dark-theme");
      document.documentElement.style.setProperty("color-scheme", normalized === "light" ? "light" : "dark");
      if (persist) {
        localStorage.setItem(themeStorageKey, normalized);
      }
    }

    toggleAdminSettings(false);
    setAdminFeaturesEnabled(false);

    const storedTheme = localStorage.getItem(themeStorageKey) || "dark";
    applyThemePreference(storedTheme, false);

    const existingToken = sessionStorage.getItem(tokenStorageKey);
    if (existingToken && existingToken.trim().length > 0) {
      window.location.replace("/ui/app");
    }
    
    function setStatus(message, isError = false) {
      statusEl.textContent = message;
      statusEl.classList.toggle("error", isError);
    }

    async function readErrorMessage(response) {
      const text = await response.text();
      try {
        const parsed = JSON.parse(text);
        if (parsed && typeof parsed === "object") {
          return parsed.error || parsed.message || text || response.statusText;
        }
      } catch (_) {
        /* ignore */
      }
      return text || response.statusText;
    }

    async function handleLogin(event) {
      event.preventDefault();
      const username = usernameField.value.trim();
      const password = passwordField.value;
      if (!username || !password) {
        setStatus("Username and password are required.", true);
        return;
      }
      document.body.classList.add("loading");
      try {
        const response = await fetch("/ui/auth/login", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ username, password })
        });
        if (!response.ok) {
          const message = await readErrorMessage(response);
          throw new Error(message);
        }
        const data = await response.json();
        if (data && data.token) {
          sessionStorage.setItem(tokenStorageKey, data.token);
        }
        setStatus(data.message || "Sign in successful. Redirecting…");
        window.location.replace("/ui/app");
      } catch (error) {
        setStatus(error.message || "Sign in failed.", true);
      } finally {
        document.body.classList.remove("loading");
        passwordField.value = "";
      }
    }

    form.addEventListener("submit", handleLogin);
  </script>
</body>
</html>
"""

const inspectorRegisterHtml* = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>OpenContext7 Register</title>
  <style>
    :root {
      font-family: "Inter", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }
    * {
      box-sizing: border-box;
    }
    body {
      margin: 0;
      min-height: 100vh;
      background: radial-gradient(circle at top, #1b2447 0%, #0a1026 55%, #040711 100%);
      color: #f3f6ff;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 32px 16px;
    }
    a {
      color: var(--primary-color);
      text-decoration: none;
    }
    a:hover {
      color: var(--primary-hover);
      text-decoration: underline;
    }
    .auth-shell {
      width: min(420px, 100%);
    }
    .auth-card {
      background: rgba(10, 15, 32, 0.92);
      border: 1px solid rgba(94, 138, 255, 0.25);
      border-radius: 24px;
      padding: 36px;
      box-shadow: 0 30px 70px -42px rgba(32, 78, 210, 0.58);
    }
    h1 {
      margin: 0 0 6px;
      font-size: 28px;
      font-weight: 650;
    }
    p.subtitle {
      margin: 0 0 24px;
      color: #a3b1e3;
      font-size: 14px;
    }
    form {
      display: flex;
      flex-direction: column;
      gap: 18px;
    }
    label {
      font-size: 13px;
      color: #c3d0ff;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    input {
      border-radius: 14px;
      border: 1px solid rgba(126, 168, 255, 0.35);
      background: rgba(18, 25, 52, 0.9);
      color: #f3f6ff;
      padding: 12px;
      font-size: 15px;
    }
    button {
      border: none;
      border-radius: 14px;
      padding: 12px 18px;
      font-size: 15px;
      font-weight: 600;
      background: linear-gradient(135deg, #5f8cff, #4e6fe3);
      color: #fff;
      cursor: pointer;
      margin-top: 8px;
    }
    button:disabled {
      opacity: 0.6;
      cursor: not-allowed;
    }
    .status {
      margin-top: 16px;
      font-size: 13px;
      color: #a3b1e3;
    }
    .status.error {
      color: #ffa6b0;
    }
    .links {
      margin-top: 18px;
      font-size: 13px;
      color: #b7c6ff;
      text-align: center;
    }
    body.loading button {
      opacity: 0.7;
      pointer-events: none;
    }
    body.light-theme {
      color-scheme: light;
      background: radial-gradient(circle at top, #f9fbff 0%, #e8edff 55%, #dde5ff 100%);
      color: #1f2436;
    }
    body.light-theme .auth-card {
      background: rgba(255, 255, 255, 0.95);
      border: 1px solid rgba(145, 165, 255, 0.35);
      box-shadow: 0 24px 60px -38px rgba(120, 150, 255, 0.35);
    }
    body.light-theme p.subtitle {
      color: #5c6a8b;
    }
    body.light-theme label {
      color: #2f3d66;
    }
    body.light-theme input {
      background: #f6f8ff;
      border: 1px solid rgba(145, 165, 255, 0.45);
      color: #1f2436;
    }
    body.light-theme input::placeholder {
      color: #93a3d8;
    }
    body.light-theme a {
      color: #2d4ccb;
    }
    body.light-theme a:hover {
      color: #22379f;
    }
    body.light-theme .links {
      color: #3d4f85;
    }
    body.light-theme .status {
      color: #4b5a7e;
    }
    body.light-theme button {
      background: linear-gradient(135deg, #4e6fe3, #7d94ff);
      color: #fff;
    }
  </style>
</head>
<body class="dark-theme">
  <div class="auth-shell">
    <section class="auth-card">
      <h1>Create Account</h1>
      <p class="subtitle">The first account becomes an administrator. Additional accounts require assigned roles.</p>
      <form id="registerForm">
        <label>
          Username
          <input id="registerUsername" type="text" autocomplete="username" placeholder="admin">
        </label>
        <label>
          Password
          <input id="registerPassword" type="password" autocomplete="new-password" placeholder="Create a strong password">
        </label>
        <label>
          Confirm password
          <input id="registerConfirm" type="password" autocomplete="new-password" placeholder="Repeat password">
        </label>
        <button id="registerSubmit" type="submit">Register Account</button>
        <p class="status" id="registerStatus">You will be signed in automatically after registration.</p>
      </form>
      <p class="links">
        Already have an account?
        <a href="/ui/login">Return to sign in</a>
      </p>
    </section>
  </div>
  <script>
    const tokenStorageKey = "opencontext7.authToken";
    const themeStorageKey = "opencontext7.theme";
    const form = document.getElementById("registerForm");
    const usernameField = document.getElementById("registerUsername");
    const passwordField = document.getElementById("registerPassword");
    const confirmField = document.getElementById("registerConfirm");
    const statusEl = document.getElementById("registerStatus");
    const storedTheme = localStorage.getItem(themeStorageKey);
    document.body.classList.remove("dark-theme", "light-theme");
    document.body.classList.add(storedTheme === "light" ? "light-theme" : "dark-theme");
    document.documentElement.style.setProperty("color-scheme", storedTheme === "light" ? "light" : "dark");

    const existingToken = sessionStorage.getItem(tokenStorageKey);
    if (existingToken && existingToken.trim().length > 0) {
      window.location.replace("/ui/app");
    }

    function setStatus(message, isError = false) {
      statusEl.textContent = message;
      statusEl.classList.toggle("error", isError);
    }

    async function readErrorMessage(response) {
      const text = await response.text();
      try {
        const parsed = JSON.parse(text);
        if (parsed && typeof parsed === "object") {
          return parsed.error || parsed.message || text || response.statusText;
        }
      } catch (_) {
        /* ignore */
      }
      return text || response.statusText;
    }

    async function handleRegister(event) {
      event.preventDefault();
      const username = usernameField.value.trim();
      const password = passwordField.value;
      const confirm = confirmField.value;
      if (!username || !password) {
        setStatus("Username and password are required.", true);
        return;
      }
      if (password !== confirm) {
        setStatus("Passwords do not match.", true);
        return;
      }
      document.body.classList.add("loading");
      try {
        const response = await fetch("/ui/auth/register", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ username, password })
        });
        if (!response.ok) {
          const message = await readErrorMessage(response);
          throw new Error(message);
        }
        const data = await response.json();
        if (data && data.token) {
          sessionStorage.setItem(tokenStorageKey, data.token);
        }
        setStatus(data.message || "Registration successful. Redirecting…");
        window.location.replace("/ui/app");
      } catch (error) {
        setStatus(error.message || "Registration failed.", true);
      } finally {
        document.body.classList.remove("loading");
        passwordField.value = "";
        confirmField.value = "";
      }
    }

    form.addEventListener("submit", handleRegister);
  </script>
</body>
</html>
"""

const inspectorUiHtml* = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>OpenContext7 Inspector</title>
  <style>
    :root {
      color-scheme: dark;
      font-family: "Inter", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      /* 主题颜色变量系统 - 深色主题作为默认 */
      --primary-color: #3b82f6;
      --primary-hover: #2563eb;
      --background-primary: #0f172a;
      --background-secondary: #1e293b;
      --background-tertiary: #334155;
      --text-primary: #f8fafc;
      --text-secondary: #cbd5e1;
      --text-tertiary: #94a3b8;
      --border-color: #475569;
      --success-color: #10b981;
      --error-color: #ef4444;
      --card-bg: rgba(30, 41, 59, 0.85);
      --shadow-color: rgba(0, 0, 0, 0.3);
    }
    * {
      box-sizing: border-box;
    }
    body {
      margin: 0;
      min-height: 100vh;
      background: var(--background-primary);
      color: var(--text-primary);
    }
    a {
      color: #9fc6ff;
      text-decoration: none;
    }
    a:hover {
      color: #cfe0ff;
      text-decoration: underline;
    }
    .layout {
      width: min(1400px, 100%);
      margin: 0 auto;
      padding: 32px 24px 48px;
      display: grid;
      grid-template-columns: 280px minmax(0, 1fr) 340px;
      grid-template-areas: "sidebar main results";
      gap: 28px;
      align-items: start;
    }
    .panel {
      background: var(--card-bg);
      border: 1px solid var(--border-color);
      border-radius: 24px;
      padding: 28px 30px;
      box-shadow: 0 32px 75px -45px var(--shadow-color);
      transition: all 0.3s ease;
    }
    .panel:hover {
      box-shadow: 0 35px 80px -40px var(--shadow-color);
      transform: translateY(-2px);
    }
    .sidebar {
      grid-area: sidebar;
      display: flex;
      flex-direction: column;
      gap: 22px;
      position: sticky;
      top: 32px;
      align-self: start;
    }
    .brand-card {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }
    .brand-card h1 {
      margin: 0;
      font-size: 28px;
      font-weight: 700;
      letter-spacing: -0.3px;
      color: var(--text-primary);
    }
    .brand-card p {
      margin: 0;
      font-size: 14px;
      color: var(--text-tertiary);
      line-height: 1.6;
    }
    .badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 6px 14px;
      border-radius: 999px;
      border: 1px solid var(--border-color);
      background: var(--background-tertiary);
      font-size: 12px;
      letter-spacing: 0.3px;
      color: var(--text-secondary);
      width: fit-content;
    }
    .connection-chip {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 10px 16px;
      border-radius: 14px;
      border: 1px solid var(--border-color);
      background: var(--background-secondary);
      font-size: 13px;
      color: var(--text-secondary);
    }
    .connection-dot {
      width: 9px;
      height: 9px;
      border-radius: 50%;
      background: var(--success-color);
      box-shadow: 0 0 10px rgba(16, 185, 129, 0.7);
    }
    .session-card h2,
    .links-card h2 {
      margin: 0;
      font-size: 17px;
      font-weight: 620;
      color: var(--text-primary);
    }
    .session-card p,
    .links-card p {
      margin: 6px 0 0;
      font-size: 13px;
      color: var(--text-tertiary);
      line-height: 1.5;
    }
    .quick-links {
      list-style: none;
      padding: 0;
      margin: 16px 0 0;
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .quick-links a {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px 16px;
      border-radius: 16px;
      background: var(--background-tertiary);
      border: 1px solid var(--border-color);
      font-size: 14px;
      font-weight: 500;
      color: var(--text-secondary);
      transition: all 0.2s ease;
      position: relative;
      overflow: hidden;
    }
    .quick-links a:hover {
      border-color: var(--primary-color);
      background: var(--background-secondary);
      color: var(--primary-color);
      transform: translateX(4px);
    }
    .quick-links a::before {
      content: '';
      position: absolute;
      left: -100%;
      top: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
      transition: left 0.3s ease;
    }
    .quick-links a:hover::before {
      left: 100%;
    }
    .main {
      grid-area: main;
      display: flex;
      flex-direction: column;
      gap: 28px;
    }
    .results-panel {
      grid-area: results;
      display: flex;
      flex-direction: column;
      gap: 18px;
      position: sticky;
      top: 32px;
      height: calc(100vh - 64px);
      max-height: calc(100vh - 64px);
    }
    .results-panel .panel-body {
      display: flex;
      flex-direction: column;
      gap: 16px;
      flex: 1;
      min-height: 0;
    }
    .hero-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 16px;
      position: relative;
    }
    .settings-wrapper {
      position: relative;
      display: inline-flex;
      flex-direction: column;
      align-items: flex-end;
    }
    .icon-button {
      flex: 0;
      min-width: auto;
      background: rgba(34, 52, 108, 0.78);
      border: 1px solid rgba(90, 146, 255, 0.32);
      color: #dceaff;
      border-radius: 12px;
      padding: 9px 14px;
      font-size: 13px;
      font-weight: 600;
      letter-spacing: 0.2px;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
      transition: transform 0.2s ease, box-shadow 0.2s ease, filter 0.2s ease;
    }
    .icon-button svg {
      width: 16px;
      height: 16px;
      fill: currentColor;
    }
    .icon-button:hover {
      transform: translateY(-1px);
      box-shadow: 0 14px 30px -22px rgba(101, 149, 255, 0.8);
    }
    .icon-button:focus-visible {
      outline: 2px solid rgba(103, 161, 255, 0.8);
      outline-offset: 3px;
    }
    .settings-popover {
      position: absolute;
      top: calc(100% + 10px);
      right: 0;
      width: 260px;
      background: rgba(10, 15, 32, 0.95);
      border: 1px solid rgba(94, 138, 255, 0.32);
      box-shadow: 0 24px 60px -38px rgba(32, 78, 210, 0.6);
      border-radius: 16px;
      padding: 18px 20px;
      display: none;
      z-index: 30;
    }
    .settings-popover.open {
      display: block;
      animation: fadeIn 0.18s ease;
    }
    .settings-popover h4 {
      margin: 0 0 12px;
      font-size: 14px;
      color: #d5e3ff;
      font-weight: 600;
    }
    .setting-row {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .setting-row span {
      font-size: 12px;
      letter-spacing: 0.4px;
      text-transform: uppercase;
      color: #9aa8da;
    }
    .setting-options {
      display: inline-flex;
      gap: 12px;
    }
    .setting-options label {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-size: 13px;
      color: #c3d0ff;
    }
    .setting-options input[type="radio"] {
      width: auto;
    }
    .setting-columns {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .setting-field {
      display: flex;
      flex-direction: column;
      gap: 6px;
      font-size: 12px;
      color: #9aa8da;
    }
    .setting-field label {
      font-size: 12px;
      color: #c3d0ff;
    }
    .setting-field select {
      border-radius: 10px;
      border: 1px solid rgba(94, 138, 255, 0.3);
      background: rgba(12, 18, 38, 0.85);
      color: #f3f6ff;
      padding: 9px 12px;
      font-size: 13px;
    }
    .setting-actions {
      display: flex;
      gap: 10px;
    }
    .settings-apply {
      border: none;
      border-radius: 10px;
      padding: 8px 14px;
      font-size: 13px;
      font-weight: 600;
      background: linear-gradient(135deg, #4665ff, #8c9eff);
      color: #fff;
      cursor: pointer;
      transition: transform 0.15s ease, box-shadow 0.15s ease;
    }
    .settings-apply:hover {
      transform: translateY(-1px);
      box-shadow: 0 12px 26px -18px rgba(101, 149, 255, 0.6);
    }
    .settings-hint {
      margin: 6px 0 0;
      font-size: 12px;
      color: #93a6dc;
    }
    .settings-hint.error {
      color: #ff8899;
    }
    .admin-setting {
      display: none;
      flex-direction: column;
      gap: 10px;
    }
    .admin-setting.visible {
      display: flex;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-6px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .section-heading {
      display: flex;
      flex-direction: column;
      gap: 6px;
      margin-bottom: 12px;
    }
    .section-heading h2 {
      margin: 0;
      font-size: 20px;
      font-weight: 640;
      letter-spacing: 0.4px;
    }
    .section-heading p {
      margin: 0;
      font-size: 13px;
      color: #96a4d8;
      line-height: 1.5;
    }
    .accordion {
      display: grid;
      gap: 18px;
    }
    details {
      border: 1px solid rgba(82, 122, 225, 0.2);
      border-radius: 16px;
      padding: 18px 20px;
      background: rgba(8, 13, 30, 0.9);
      transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }
    details[open] {
      border-color: rgba(110, 160, 255, 0.4);
      box-shadow: 0 0 0 1px rgba(110, 160, 255, 0.22);
    }
    summary {
      margin: -18px -20px 12px;
      padding: 18px 20px;
      cursor: pointer;
      font-size: 16px;
      font-weight: 600;
      color: #e5ebff;
      display: flex;
      align-items: center;
      gap: 12px;
      list-style: none;
    }
    summary::-webkit-details-marker {
      display: none;
    }
    summary::marker {
      content: "";
    }
    summary::after {
      content: "▸";
      margin-left: auto;
      font-size: 14px;
      color: #83a9ff;
      transition: transform 0.2s ease;
    }
    details[open] summary::after {
      transform: rotate(90deg);
    }
    .section-body {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }
    .section-description {
      margin: 0;
      font-size: 13px;
      color: #92a3d8;
      line-height: 1.5;
    }
    .inputs {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    label {
      font-size: 13px;
      font-weight: 500;
      color: var(--text-secondary);
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    input, textarea, select {
      width: 100%;
      border-radius: 16px;
      border: 1px solid var(--border-color);
      background: var(--background-secondary);
      color: var(--text-primary);
      font-size: 15px;
      padding: 12px 16px;
      transition: all 0.25s ease;
      font-family: inherit;
      resize: vertical;
      min-height: 48px;
      position: relative;
      overflow: hidden;
    }
    textarea {
      min-height: 120px;
      line-height: 1.5;
    }
    input:focus, textarea:focus, select:focus {
      outline: none;
      border-color: var(--primary-color);
      box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.25);
      transform: translateY(-1px);
    }
    input::placeholder, textarea::placeholder {
      color: var(--text-tertiary);
      opacity: 0.8;
    }
    .inline-inputs {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
    }
    .inline-inputs label {
      flex: 1;
      min-width: 180px;
    }
    .checkbox-row {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 13px;
      color: #d0daf7;
    }
    input[type="checkbox"] {
      width: auto;
      min-height: initial;
      height: 18px;
      accent-color: #6388ff;
    }
    .button-row {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }
    button {
      flex: 1;
      min-width: 120px;
      background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
      border: none;
      border-radius: 16px;
      padding: 12px 18px;
      color: #fff;
      font-size: 15px;
      font-weight: 600;
      letter-spacing: 0.3px;
      cursor: pointer;
      transition: all 0.25s ease;
      position: relative;
      overflow: hidden;
    }
    button::before {
      content: '';
      position: absolute;
      left: -100%;
      top: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
      transition: left 0.35s ease;
    }
    button:hover {
      transform: translateY(-2px);
      box-shadow: 0 16px 36px -24px rgba(101, 149, 255, 0.9);
    }
    button:hover::before {
      left: 100%;
    }
    button:active {
      transform: translateY(0);
      box-shadow: 0 8px 24px -18px rgba(101, 149, 255, 0.8);
    }
    button:disabled {
      opacity: 0.6;
      cursor: not-allowed;
      transform: none;
      box-shadow: none;
    }
    button.secondary {
      background: var(--background-tertiary);
      border: 1px solid var(--border-color);
      color: var(--text-secondary);
    }
    button.secondary:hover {
      border-color: var(--primary-color);
      color: var(--primary-color);
      box-shadow: 0 12px 30px -20px rgba(101, 149, 255, 0.6);
    }
    .download-link {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      margin-top: 8px;
      color: #9ec7ff;
      font-size: 13px;
      text-decoration: none;
    }
    .download-link:hover {
      text-decoration: underline;
    }
    .output {
      display: flex;
      flex-direction: column;
      gap: 16px;
      overflow: hidden;
    }
    #results {
      flex: 1;
      min-height: 0;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      gap: 12px;
      padding-right: 6px;
    }
    .result-card {
      background: rgba(14, 21, 44, 0.82);
      border: 1px solid rgba(80, 135, 255, 0.22);
      border-radius: 12px;
      padding: 14px 16px;
      display: flex;
      flex-direction: column;
      gap: 10px;
      animation: fadeIn 0.25s ease;
    }
    .result-card.success {
      border-color: rgba(93, 255, 143, 0.3);
    }
    .result-card.error {
      border-color: rgba(255, 102, 124, 0.35);
    }
    .result-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 13px;
      color: #9aa4d0;
    }
    .result-header strong {
      color: #e0e6ff;
      letter-spacing: 0.3px;
    }
    .result-body {
      background: rgba(7, 11, 23, 0.9);
      border-radius: 10px;
      padding: 12px;
      font-family: "JetBrains Mono", "SFMono-Regular", Consolas, "Liberation Mono", monospace;
      font-size: 13px;
      color: #d9e3ff;
      line-height: 1.4;
      overflow-x: auto;
      white-space: pre-wrap;
      word-break: break-word;
    }
    .result-body.data-block {
      background: rgba(10, 16, 33, 0.92);
      margin-top: -6px;
    }
    .status-bar {
      font-size: 12px;
      color: #93a6dc;
      border-top: 1px solid rgba(90, 146, 255, 0.18);
      padding-top: 12px;
    }
    .session-summary {
      font-size: 13px;
      color: #a7b6e9;
      margin: 0 0 14px;
      line-height: 1.6;
    }
    .session-summary strong {
      color: #f4f7ff;
    }
    .session-actions {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      margin-top: 12px;
    }
    .session-chip {
      display: flex;
      flex-direction: column;
      gap: 4px;
      padding: 12px 14px;
      border-radius: 14px;
      background: rgba(17, 24, 48, 0.72);
      border: 1px solid rgba(90, 128, 220, 0.35);
      font-size: 12px;
      color: #d3defe;
    }
    .session-chip span strong {
      color: #8fb4ff;
    }
    .loading {
      opacity: 0.6;
      pointer-events: none;
    }
    .hint {
      font-size: 12px;
      color: #6f7fb6;
      margin: -6px 0 0;
    }
    input[readonly] {
      background: rgba(9, 15, 28, 0.45);
      color: #cfd8ff;
    }
    .panel.disabled {
      opacity: 0.55;
    }
    .panel.disabled .section-body {
      pointer-events: none;
    }
    .panel.disabled summary {
      cursor: not-allowed;
    }
    details.admin-disabled summary {
      cursor: not-allowed;
      opacity: 0.7;
    }
    details.admin-disabled .section-body {
      pointer-events: none;
      opacity: 0.7;
    }
    .auth-grid {
      display: grid;
      gap: 18px;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      margin-top: 18px;
    }
    .auth-card-block {
      border: 1px solid rgba(82, 122, 225, 0.28);
      border-radius: 14px;
      padding: 18px 20px;
      background: rgba(12, 18, 38, 0.85);
      display: flex;
      flex-direction: column;
      gap: 14px;
      animation: fadeIn 0.3s ease;
    }
    .auth-card-block h3 {
      margin: 0;
      font-size: 16px;
      font-weight: 600;
    }
    .auth-card-block .button-row {
      justify-content: flex-start;
    }
    .hidden {
      display: none !important;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(4px); }
      to { opacity: 1; transform: translateY(0); }
    }
    body.light-theme {
      /* 浅色主题颜色变量 */
      --primary-color: #2563eb;
      --primary-hover: #1d4ed8;
      --background-primary: #f8fafc;
      --background-secondary: #f1f5f9;
      --background-tertiary: #e2e8f0;
      --text-primary: #0f172a;
      --text-secondary: #334155;
      --text-tertiary: #64748b;
      --border-color: #cbd5e1;
      --success-color: #059669;
      --error-color: #dc2626;
      --card-bg: rgba(255, 255, 255, 0.95);
      --shadow-color: rgba(0, 0, 0, 0.1);
      color: var(--text-primary);
      background: var(--background-primary);
    }
    body.light-theme .panel {
      background: rgba(255, 255, 255, 0.95);
      border: 1px solid rgba(145, 165, 255, 0.35);
      box-shadow: 0 28px 60px -40px rgba(120, 150, 255, 0.25);
      color: inherit;
    }
    body.light-theme .badge {
      border: 1px solid rgba(145, 165, 255, 0.4);
      background: linear-gradient(135deg, rgba(190, 205, 255, 0.65), rgba(150, 170, 255, 0.45));
      color: #2f3d66;
    }
    body.light-theme .brand-card p,
    body.light-theme .session-card p,
    body.light-theme .links-card p,
    body.light-theme .hint {
      color: #4b5a7e;
    }
    body.light-theme .connection-chip {
      background: rgba(226, 231, 255, 0.95);
      border: 1px solid rgba(145, 165, 255, 0.45);
      color: #2f3d66;
    }
    body.light-theme .connection-dot {
      background: #2ac36b;
      box-shadow: 0 0 10px rgba(42, 195, 107, 0.6);
    }
    body.light-theme a {
      color: #2d4ccb;
    }
    body.light-theme a:hover {
      color: #22379f;
    }
    body.light-theme .quick-links a {
      background: rgba(233, 238, 255, 0.9);
      border: 1px solid rgba(170, 186, 255, 0.45);
      color: #2f3d66;
    }
    body.light-theme .quick-links a:hover {
      border-color: rgba(130, 150, 255, 0.6);
      background: rgba(223, 229, 255, 1);
    }
    body.light-theme .section-heading p,
    body.light-theme .section-description {
      color: #5a6a8b;
    }
    body.light-theme details {
      background: rgba(245, 247, 255, 0.95);
      border: 1px solid rgba(160, 180, 255, 0.35);
    }
    body.light-theme details[open] {
      border-color: rgba(120, 150, 255, 0.5);
      box-shadow: 0 0 0 1px rgba(120, 150, 255, 0.18);
    }
    body.light-theme summary {
      color: #1f2436;
    }
    body.light-theme .inputs label {
      color: #2f3d66;
    }
    body.light-theme input,
    body.light-theme textarea,
    body.light-theme select {
      background: #f6f8ff;
      border: 1px solid rgba(145, 165, 255, 0.45);
      color: #1f2436;
    }
    body.light-theme input::placeholder,
    body.light-theme textarea::placeholder {
      color: #93a3d8;
    }
    body.light-theme input:focus,
    body.light-theme textarea:focus,
    body.light-theme select:focus {
      border-color: rgba(120, 150, 255, 0.9);
      box-shadow: 0 0 0 3px rgba(120, 150, 255, 0.25);
    }
    body.light-theme input[readonly] {
      background: rgba(232, 236, 255, 0.95);
      color: #2f3d66;
    }
    body.light-theme .checkbox-row {
      color: #4b5a7e;
    }
    body.light-theme input[type="checkbox"] {
      accent-color: #4e6fe3;
    }
    body.light-theme button {
      background: linear-gradient(130deg, #4e6fe3, #7d94ff);
      box-shadow: 0 12px 28px -18px rgba(90, 120, 255, 0.4);
      color: #fff;
    }
    body.light-theme button.secondary {
      background: rgba(228, 233, 255, 0.95);
      border: 1px solid rgba(145, 165, 255, 0.55);
      color: #2f3d66;
    }
    body.light-theme .icon-button {
      background: rgba(228, 233, 255, 0.95);
      border: 1px solid rgba(145, 165, 255, 0.55);
      color: #2f3d66;
    }
    body.light-theme .settings-popover {
      background: rgba(255, 255, 255, 0.98);
      border: 1px solid rgba(145, 165, 255, 0.35);
      box-shadow: 0 28px 60px -42px rgba(120, 150, 255, 0.28);
    }
    body.light-theme .settings-popover h4 {
      color: #2f3d66;
    }
    body.light-theme .setting-row span {
      color: #5c6a8b;
    }
    body.light-theme .setting-options label {
      color: #2f3d66;
    }
    body.light-theme .setting-field label {
      color: #2f3d66;
    }
    body.light-theme .setting-field select {
      background: rgba(233, 238, 255, 0.95);
      border: 1px solid rgba(150, 170, 255, 0.45);
      color: #1f2436;
    }
    body.light-theme .settings-hint {
      color: #4b5a7e;
    }
    body.light-theme .settings-apply {
      background: linear-gradient(135deg, #4e6fe3, #7d94ff);
      color: #fff;
    }
    body.light-theme .download-link {
      color: #2d4ccb;
    }
    body.light-theme .result-card {
      background: rgba(241, 244, 255, 0.96);
      border: 1px solid rgba(170, 186, 255, 0.35);
    }
    body.light-theme .result-card.success {
      border-color: rgba(120, 190, 120, 0.35);
    }
    body.light-theme .result-card.error {
      border-color: rgba(240, 120, 140, 0.4);
    }
    body.light-theme .result-header {
      color: #4b5a7e;
    }
    body.light-theme .result-header strong {
      color: #2f3d66;
    }
    body.light-theme .result-body {
      background: rgba(229, 234, 255, 0.95);
      color: #2f3144;
    }
    body.light-theme .result-body.data-block {
      background: rgba(219, 226, 255, 0.95);
    }
    body.light-theme .status-bar {
      color: #2f3d66;
      border-top: 1px solid rgba(145, 165, 255, 0.28);
    }
    body.light-theme .session-summary strong {
      color: #2f3d66;
    }
    body.light-theme .session-chip {
      background: rgba(230, 235, 255, 0.95);
      border: 1px solid rgba(160, 180, 240, 0.45);
      color: #2f3d66;
    }
    body.light-theme .session-chip span strong {
      color: #2d4ccb;
    }
    body.light-theme .auth-card-block {
      background: rgba(234, 238, 255, 0.95);
      border: 1px solid rgba(160, 180, 245, 0.35);
    }
    body.light-theme .auth-overlay {
      background: rgba(232, 236, 255, 0.9);
    }
    body.light-theme .auth-card {
      background: rgba(255, 255, 255, 0.98);
      border: 1px solid rgba(145, 165, 255, 0.35);
      color: #1f2436;
    }
    body.light-theme .auth-tabs {
      background: rgba(227, 232, 255, 0.94);
    }
    body.light-theme .auth-tab {
      color: #2f3d66;
    }
    body.light-theme .auth-tab.active {
      background: #4e6fe3;
      color: #fff;
    }
    body.light-theme #results::-webkit-scrollbar {
      width: 10px;
      background: rgba(217, 222, 255, 0.6);
    }
    body.light-theme #results::-webkit-scrollbar-thumb {
      background: rgba(130, 150, 255, 0.7);
    }
    button:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }
    .gate-disabled {
      opacity: 0.4;
      pointer-events: none;
    }
    .auth-overlay {
      position: fixed;
      inset: 0;
      background: rgba(4, 7, 17, 0.82);
      backdrop-filter: blur(4px);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
      z-index: 1000;
    }
    .auth-overlay.hidden {
      display: none;
    }
    .admin-disabled {
      opacity: 0.45;
      pointer-events: none;
    }
    .auth-card {
      width: min(440px, 100%);
      background: rgba(12, 18, 36, 0.96);
      border: 1px solid rgba(110, 160, 255, 0.35);
      border-radius: 22px;
      padding: 28px 32px;
      box-shadow: 0 32px 90px rgba(24, 45, 120, 0.58);
      display: flex;
      flex-direction: column;
      gap: 22px;
    }
    .auth-tabs {
      display: inline-flex;
      align-self: center;
      border-radius: 999px;
      padding: 4px;
      background: rgba(21, 30, 60, 0.8);
      gap: 4px;
    }
    .auth-tab {
      border: none;
      background: transparent;
      color: #cbd8ff;
      font-size: 13px;
      padding: 8px 18px;
      border-radius: 999px;
      cursor: pointer;
      transition: background 0.2s ease, color 0.2s ease;
    }
    .auth-tab.active {
      background: linear-gradient(135deg, rgba(94, 132, 255, 0.36), rgba(60, 92, 210, 0.7));
      color: #ffffff;
    }
    .auth-forms {
      display: flex;
      flex-direction: column;
      gap: 0;
    }
    .auth-form {
      display: none;
      flex-direction: column;
      gap: 14px;
      animation: fadeIn 0.25s ease;
    }
    .auth-form.active {
      display: flex;
    }
    .auth-form button {
      margin-top: 8px;
    }
    .auth-hint {
      font-size: 12px;
      color: #92a3d8;
      min-height: 18px;
    }
    .auth-hint.error {
      color: #ff8899;
    }
    @media (max-width: 1080px) {
      .layout {
        grid-template-columns: 260px minmax(0, 1fr);
        grid-template-areas:
          "sidebar main"
          "sidebar results";
        padding: 26px 18px 40px;
      }
      .sidebar {
        position: static;
      }
      .results-panel {
        position: static;
        height: auto;
        max-height: none;
      }
    }
    @media (max-width: 720px) {
      .layout {
        grid-template-columns: 1fr;
        grid-template-areas:
          "sidebar"
          "main"
          "results";
      }
      button {
        flex: 1 1 100%;
      }
      .inline-inputs {
        flex-direction: column;
      }
    }
  </style>
</head>
<body class="dark-theme">
  <div class="layout">
    <aside class="sidebar">
      <section class="panel brand-card">
        <span class="badge">Local MCP Surface</span>
        <h1>OpenContext7</h1>
        <p>Control and inspect your private library workspace directly from the browser.</p>
        <div class="connection-chip" id="connectionChip">
          <span class="connection-dot"></span>
          <span id="connectionLabel">Connecting...</span>
        </div>
      </section>
      <section class="panel session-card">
        <h2>Session Settings</h2>
        <p>Sign in below or paste an existing bearer token to authenticate UI requests.</p>
        <div class="inputs">
          <label>
            Bearer token
            <input id="apiKeyInput" type="text" placeholder="Paste token or sign in below">
          </label>
        </div>
        <div class="button-row">
          <button id="logoutBtn" class="secondary" type="button">Sign out</button>
        </div>
        <p class="hint" id="currentUserHint">Not signed in.</p>
        <p class="hint">Tokens are stored only for this browser session and sent as Bearer headers.</p>
      </section>
      <section class="panel links-card">
        <h2>Navigation</h2>
        <p>Jump directly to the workflow you need.</p>
        <ul class="quick-links">
          <li><a href="#library-tools">Library workflows</a></li>
          <li><a href="#automation-tools">Automation &amp; ops</a></li>
          <li><a href="#results-panel">Recent responses</a></li>
        </ul>
      </section>
    </aside>
    <main class="main">
      <section class="panel hero">
        <div class="hero-header">
          <div class="section-heading">
            <h2>Workspace Overview</h2>
            <p>Use the panels below to register documentation, run searches, sync repositories, and manage backups.</p>
          </div>
          <div class="settings-wrapper">
            <button id="settingsToggle" class="icon-button" type="button" aria-haspopup="true" aria-expanded="false">
              <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 15.6a3.6 3.6 0 1 1 0-7.2 3.6 3.6 0 0 1 0 7.2Zm9-3.6-1.96-1.52.28-2.48-2.42-.98-.98-2.42-2.48.28L12 3l-1.52 1.96-2.48-.28-.98 2.42-2.42.98.28 2.48L3 12l1.96 1.52-.28 2.48 2.42.98.98 2.42 2.48-.28L12 21l1.52-1.96 2.48.28.98-2.42 2.42-.98-.28-2.48L21 12Z"></path>
              </svg>
              Settings
            </button>
            <div id="settingsPopover" class="settings-popover" role="dialog" aria-modal="false" aria-label="Interface settings" aria-hidden="true">
              <div class="setting-row">
                <span>Theme</span>
                <div class="setting-options" role="radiogroup" aria-label="Theme selection">
                  <label>
                    <input type="radio" name="themeChoice" value="dark" checked>
                    Dark
                  </label>
                  <label>
                    <input type="radio" name="themeChoice" value="light">
                    Light
                  </label>
                </div>
              </div>
              <div class="setting-row admin-setting" id="settingsAccountRow">
                <span>Account Permissions</span>
                <div class="setting-columns">
                  <label class="setting-field">
                    <span>User</span>
                    <select id="settingsUserSelect"></select>
                  </label>
                  <label class="setting-field">
                    <span>Role</span>
                    <select id="settingsRoleSelect"></select>
                  </label>
                </div>
                <div class="setting-actions">
                  <button class="settings-apply" id="settingsRoleApply" type="button">Apply</button>
                </div>
                <p class="settings-hint" id="settingsRoleStatus"></p>
              </div>
            </div>
          </div>
        </div>
        <div class="auth-card-block" id="authPanel">
          <h3>Authentication Status</h3>
          <p class="section-description" id="authStatus">Checking authentication state…</p>
          <p class="hint">Use the sidebar to manage bearer tokens or sign out to switch accounts.</p>
        </div>
      </section>
      <section class="panel" id="library-tools">
        <div class="section-heading">
          <h2>Library Workflows</h2>
          <p>Everything you need to register, query, and move documentation between environments.</p>
        </div>
        <div class="accordion">
          <details open data-admin-only="true" data-admin-section="register">
            <summary>Register Library</summary>
            <div class="section-body">
              <p class="section-description">Create or replace a library entry with documentation content.</p>
              <div class="inputs">
                <label>
                  Library name
                  <input id="registerName" type="text" placeholder="acme.widgets">
                </label>
                <label>
                  Version
                  <input id="registerVersion" type="text" placeholder="1.0.0">
                </label>
                <label>
                  Description (optional)
                  <input id="registerDescription" type="text" placeholder="Short summary shown in search results">
                </label>
                <label>
                  Documentation (markdown or plain text)
                  <textarea id="registerDocs" placeholder="# Overview&#10;Describe your library here..."></textarea>
                </label>
              </div>
              <div class="button-row">
                <button id="registerBtn" type="button">Register Library</button>
                <button id="registerResetBtn" class="secondary" type="button">Clear</button>
              </div>
              <p class="hint hidden" id="registerAdminHint">Only administrators can register libraries.</p>
            </div>
          </details>
          <details>
            <summary>Search Libraries</summary>
            <div class="section-body">
              <p class="section-description">Query across registered libraries using the server-side search index.</p>
              <div class="inputs">
                <label>
                  Search query
                  <input id="searchQuery" type="text" placeholder="analytics sdk">
                </label>
              </div>
              <div class="button-row">
                <button id="searchBtn" type="button">Search</button>
              </div>
            </div>
          </details>
          <details>
            <summary>Get Library Docs</summary>
            <div class="section-body">
              <p class="section-description">Retrieve documentation with optional topic focus and character limit.</p>
              <div class="inputs">
                <label>
                  Library name
                  <input id="docsName" type="text" placeholder="acme.widgets">
                </label>
                <label>
                  Version (optional, defaults to latest)
                  <input id="docsVersion" type="text" placeholder="latest">
                </label>
                <label>
                  Max characters
                  <input id="docsMax" type="number" min="100" max="20000" step="100" value="5000">
                </label>
                <label>
                  Topics (comma separated, optional)
                  <input id="docsTopics" type="text" placeholder="setup, quick start">
                </label>
                <label>
                  Topic match strategy
                  <select id="docsTopicMatch">
                    <option value="literal" selected>literal</option>
                    <option value="structure">structure</option>
                    <option value="embedding">embedding</option>
                  </select>
                </label>
              </div>
              <div class="button-row">
                <button id="docsBtn" type="button">Fetch Documentation</button>
              </div>
            </div>
          </details>
        </div>
      </section>
    </main>
    <section class="panel results-panel" id="results-panel">
      <div class="section-heading">
        <h2>Recent Responses</h2>
        <p>Results appear here whenever an action completes.</p>
      </div>
      <div class="panel-body">
        <div id="results"></div>
        <div class="status-bar" id="statusBar">Waiting for actions...</div>
      </div>
    </section>
  </div>
  <script>
    const apiKeyInput = document.getElementById("apiKeyInput");
    const results = document.getElementById("results");
    const statusBar = document.getElementById("statusBar");
    const connectionLabel = document.getElementById("connectionLabel");
    const connectionChip = document.getElementById("connectionChip");
    const logoutBtn = document.getElementById("logoutBtn");
    const currentUserHint = document.getElementById("currentUserHint");
    const authPanel = document.getElementById("authPanel");
    const authStatus = document.getElementById("authStatus");
    const accessControlSection = document.getElementById("accessControlSection");
    const accessControlStatus = document.getElementById("accessControlStatus");
    const settingsToggle = document.getElementById("settingsToggle");
    const settingsPopover = document.getElementById("settingsPopover");
    const settingsWrapper = settingsPopover ? settingsPopover.parentElement : null;
    // 重命名变量以避免冲突
    const themeRadios = settingsPopover ? settingsPopover.querySelectorAll("input[name='themeChoice']") : [];
    const settingsAccountRow = document.getElementById("settingsAccountRow");
    const settingsUserSelect = document.getElementById("settingsUserSelect");
    const settingsRoleSelect = document.getElementById("settingsRoleSelect");
    const settingsRoleApply = document.getElementById("settingsRoleApply");
    const settingsRoleStatus = document.getElementById("settingsRoleStatus");

    const adminOnlyNodes = document.querySelectorAll("[data-admin-only='true']");
    const registerSection = document.querySelector("[data-admin-section='register']");
    const registerAdminHint = document.getElementById("registerAdminHint");

    const tokenStorageKey = "opencontext7.authToken";
    const themeStorageKey = "opencontext7.theme";
    let serverInfo = null;
    let currentUserIsAdmin = false;
    let currentUsername = "";
    let settingsDataLoaded = false;
    let settingsUsers = [];
    let settingsRoles = [];

    function bearerHeaders() {
      const headers = { "Content-Type": "application/json" };
      if (!apiKeyInput) return headers;
      const token = apiKeyInput.value.trim();
      if (token.length > 0) {
        headers["Authorization"] = token.startsWith("Bearer ") ? token : `Bearer ${token}`;
      }
      return headers;
    }

    function normalizeToken(value) {
      if (typeof value !== "string") return "";
      return value.replace(/^Bearer\s+/i, "").trim();
    }

    function toggleAdminSettings(enabled) {
      if (!settingsAccountRow) return;
      settingsAccountRow.classList.toggle("visible", enabled);
      if (!enabled && settingsRoleStatus) {
        settingsRoleStatus.textContent = "";
        settingsRoleStatus.classList.remove("error");
      }
    }

    function setAdminFeaturesEnabled(enabled) {
      if (registerSection) {
        registerSection.classList.toggle("admin-disabled", !enabled);
        const registerInputs = registerSection.querySelectorAll("input, textarea, button, select");
        registerInputs.forEach(element => {
          element.disabled = !enabled;
        });
      }
      if (registerAdminHint) {
        registerAdminHint.classList.toggle("hidden", enabled);
      }
      adminOnlyNodes.forEach(node => {
        if (node === registerSection) return;
        node.classList.toggle("admin-disabled", !enabled);
        const interactive = node.querySelectorAll("input, textarea, button, select");
        interactive.forEach(element => {
          element.disabled = !enabled;
        });
      });
      if (!enabled) {
        settingsDataLoaded = false;
      }
    }

    function applySettingsRoleOptions(rolesArray) {
      if (!Array.isArray(rolesArray)) return;
      settingsRoles = rolesArray
        .filter(role => typeof role.name === "string" && role.name.length > 0)
        .map(role => ({ name: role.name, permissions: role.permissions || [] }));
      if (settingsRoleSelect) {
        settingsRoleSelect.innerHTML = "";
        const fragment = document.createDocumentFragment();
        settingsRoles.forEach(role => {
          const option = document.createElement("option");
          option.value = role.name;
          option.textContent = role.name;
          fragment.appendChild(option);
        });
        settingsRoleSelect.appendChild(fragment);
      }
      refreshSettingsSelections();
    }

    function applySettingsUserOptions(usersArray) {
      if (!Array.isArray(usersArray)) return;
      settingsUsers = usersArray
        .filter(user => typeof user.username === "string" && user.username.length > 0)
        .map(user => ({
          username: user.username,
          role: user.role || "",
          isAdmin: user.isAdmin === true
        }));
      if (settingsUserSelect) {
        settingsUserSelect.innerHTML = "";
        const fragment = document.createDocumentFragment();
        settingsUsers.forEach(user => {
          const option = document.createElement("option");
          option.value = user.username;
          option.textContent = user.username + (user.isAdmin ? " (admin)" : "");
          fragment.appendChild(option);
        });
        settingsUserSelect.appendChild(fragment);
      }
      refreshSettingsSelections();
    }


    
    function refreshSettingsSelections() {
      if (!settingsAccountRow) return;
      const isAdmin = currentUserIsAdmin;
      toggleAdminSettings(isAdmin);
      if (!isAdmin) {
        return;
      }
      if (settingsUsers.length === 0) {
        const option = document.createElement("option");
        option.value = currentUsername;
        option.textContent = currentUsername || "current user";
        settingsUserSelect.innerHTML = "";
        settingsUserSelect.appendChild(option);
      }
      if (settingsUserSelect) {
        if (currentUsername) {
          settingsUserSelect.value = currentUsername;
        }
      }
      if (settingsRoleSelect && settingsRoles.length > 0 && currentUserIsAdmin) {
        const selectedUser = settingsUsers.find(user => user.username === settingsUserSelect.value);
        const roleValue = selectedUser ? selectedUser.role : "";
        if (roleValue && settingsRoles.some(role => role.name === roleValue)) {
          settingsRoleSelect.value = roleValue;
        }
      }
    }

    function applyThemePreference(theme, persist = true) {
      const normalized = theme === "light" ? "light" : "dark";
      document.body.classList.remove("light-theme", "dark-theme");
      document.body.classList.add(normalized === "light" ? "light-theme" : "dark-theme");
      document.documentElement.style.setProperty("color-scheme", normalized === "light" ? "light" : "dark");
      if (persist) {
        localStorage.setItem(themeStorageKey, normalized);
      }
      if (themeRadios && themeRadios.length > 0) {
        themeRadios.forEach(radio => {
          radio.checked = radio.value === normalized;
        });
      }
    }

    function redirectToLogin() {
      window.location.replace("/ui/login");
    }

    function redirectToRegister() {
      window.location.replace("/ui/register");
    }

    function clearTokenAndRedirect() {
      sessionStorage.removeItem(tokenStorageKey);
      if (apiKeyInput) {
        apiKeyInput.value = "";
      }
      redirectToLogin();
    }

    function updateSessionSummary(user) {
      if (!currentUserHint) return;
      if (!serverInfo || (!serverInfo.authRequired && !serverInfo.multiUserEnabled)) {
        currentUserHint.textContent = "Authentication not required for this server.";
        if (logoutBtn) logoutBtn.disabled = false;
        return;
      }
      if (user && user.username) {
        currentUserHint.textContent = `Signed in as ${user.username} (${user.role || "role unknown"})`;
        if (logoutBtn) logoutBtn.disabled = false;
      } else {
        let message = "Session not authenticated. Use the sign-in page to continue.";
        if (serverInfo && !serverInfo.hasUsers) {
          message = "Create the first administrator account to continue.";
        }
        currentUserHint.textContent = message;
        if (logoutBtn) logoutBtn.disabled = true;
      }
    }

    function setAccessControlEnabled(enabled) {
      if (!accessControlSection) return;
      accessControlSection.classList.toggle("disabled", !enabled);
      const interactive = accessControlSection.querySelectorAll(".section-body input, .section-body button, .section-body select, .section-body textarea");
      interactive.forEach(el => {
        if (el.id === "userToken") {
          el.readOnly = true;
          el.disabled = false;
          return;
        }
        el.disabled = !enabled;
      });
      if (accessControlStatus) {
        accessControlStatus.textContent = enabled
          ? "You are signed in as an administrator."
          : "Sign in with an administrator to modify users.";
      }
      if (!enabled) {
        const passwordField = document.getElementById("userPassword");
        if (passwordField) {
          passwordField.value = "";
        }
        const rotateField = document.getElementById("userRotateToken");
        if (rotateField) {
          rotateField.checked = false;
        }
      }
    }

    function updateStoredTokenFromInput() {
      if (!apiKeyInput) return;
      const normalized = normalizeToken(apiKeyInput.value);
      apiKeyInput.value = normalized;
      if (normalized.length > 0) {
        sessionStorage.setItem(tokenStorageKey, normalized);
      } else {
        sessionStorage.removeItem(tokenStorageKey);
      }
      updateAuthState();
    }

    function setToken(token) {
      if (!apiKeyInput) return;
      apiKeyInput.value = normalizeToken(token);
      updateStoredTokenFromInput();
    }

    async function readErrorMessage(response) {
      const text = await response.text();
      try {
        const parsed = JSON.parse(text);
        if (parsed && typeof parsed === "object") {
          return parsed.error || parsed.message || text || response.statusText;
        }
      } catch (_) {
        /* ignore json parse failure */
      }
      return text || response.statusText;
    }

    function setBusy(isBusy) {
      if (isBusy) {
        document.body.classList.add("loading");
        statusBar.textContent = "Working...";
      } else {
        document.body.classList.remove("loading");
      }
    }

    function buildPayload(base) {
      const cleaned = {};
      for (const [key, value] of Object.entries(base)) {
        if (value === undefined || value === null) continue;
        if (Array.isArray(value)) {
          cleaned[key] = value;
          continue;
        }
        if (typeof value === "string") {
          const trimmed = value.trim();
          if (trimmed.length === 0) continue;
          cleaned[key] = trimmed;
          continue;
        }
        cleaned[key] = value;
      }
      return cleaned;
    }

    function splitCsv(value) {
      return value.split(",").map(part => part.trim()).filter(Boolean);
    }

    function applyServerInfo(info) {
      serverInfo = info;
      if (!authPanel) {
        updateSessionSummary(null);
        return;
      }
      const hasInfo = !!info;
      const requiresAuth = hasInfo && (info.authRequired || info.multiUserEnabled);
      const needsInitialAccount = hasInfo && !info.hasUsers;
      authPanel.style.display = hasInfo ? "" : "none";
      if (authStatus) {
        if (!hasInfo) {
          authStatus.textContent = "Authentication status unavailable.";
        } else if (needsInitialAccount) {
          authStatus.textContent = "Create the first administrator account to continue.";
        } else if (requiresAuth) {
          authStatus.textContent = "Sign in with your username and password.";
        } else {
          authStatus.textContent = "Authentication not required for this server.";
        }
      }
      const controlsUnlocked = hasInfo && info.hasUsers && !requiresAuth;
      setAccessControlEnabled(controlsUnlocked);
      updateSessionSummary(null);
    }

    function populateUserForm(user) {
      if (!user) return;
      const usernameField = document.getElementById("userName");
      if (usernameField && user.username) {
        usernameField.value = user.username;
      }
      const roleField = document.getElementById("userRole");
      if (roleField) {
        roleField.value = user.role || "";
      }
      const libsField = document.getElementById("userLibraries");
      if (libsField) {
        if (Array.isArray(user.libraries)) {
          libsField.value = user.libraries.join(", ");
        } else {
          libsField.value = "";
        }
      }
      const tokenField = document.getElementById("userToken");
      if (tokenField && user.token) {
        tokenField.value = user.token;
      }
      const activeField = document.getElementById("userActive");
      if (activeField) {
        activeField.checked = user.active !== false;
      }
      const passwordField = document.getElementById("userPassword");
      if (passwordField) {
        passwordField.value = "";
      }
      const rotateField = document.getElementById("userRotateToken");
      if (rotateField) {
        rotateField.checked = false;
      }
    }

    function getUsernameValue() {
      const field = document.getElementById("userName");
      return field ? field.value.trim() : "";
    }

    function appendResult(tool, payload, isError) {
      const card = document.createElement("article");
      card.className = "result-card " + (isError ? "error" : "success");

      const header = document.createElement("div");
      header.className = "result-header";
      const time = new Date().toLocaleTimeString();
      header.innerHTML = `<strong>${tool}</strong><span>${time}</span>`;
      card.appendChild(header);

      const body = document.createElement("pre");
      body.className = "result-body";
      let message = "";
      if (payload && Array.isArray(payload.content)) {
        message = payload.content
          .map(chunk => typeof chunk.text === "string" ? chunk.text : JSON.stringify(chunk, null, 2))
          .join("\n\n");
      } else if (payload && typeof payload.message === "string") {
        message = payload.message;
      } else {
        message = JSON.stringify(payload, null, 2);
      }
      body.textContent = message;
      card.appendChild(body);

      if (payload && payload.data !== undefined) {
        const dataBlock = document.createElement("pre");
        dataBlock.className = "result-body data-block";
        dataBlock.textContent = JSON.stringify(payload.data, null, 2);
        card.appendChild(dataBlock);
      }

      if (payload && payload.fileName) {
        const link = document.createElement("a");
        link.href = "data:application/json," + encodeURIComponent(JSON.stringify(payload.data, null, 2));
        link.download = payload.fileName;
        link.textContent = "Download exported library";
        link.className = "download-link";
        card.appendChild(link);
      }

      results.prepend(card);
      const summary = isError ? "Error" : "Success";
      const timeLabel = new Date().toLocaleTimeString();
      statusBar.textContent = `${summary}: ${tool} at ${timeLabel}`;
    }

    function appendError(tool, message) {
      appendResult(tool, { message }, true);
    }

    function handleActionResult(tool, payload, isError) {
      if (isError || !payload) return;
      if (payload.data && payload.data.user) {
        populateUserForm(payload.data.user);
      }
      if (tool === "users_remove") {
        const tokenField = document.getElementById("userToken");
        if (tokenField) tokenField.value = "";
      }
    }

    async function updateAuthState() {
      if (!serverInfo) {
        updateSessionSummary(null);
        setAccessControlEnabled(false);
        currentUserIsAdmin = false;
        currentUsername = "";
        toggleAdminSettings(false);
        setAdminFeaturesEnabled(false);
        return;
      }
      const requiresAuth = serverInfo.authRequired || serverInfo.multiUserEnabled;
      const needsInitialAccount = !serverInfo.hasUsers;
      if (!requiresAuth && !needsInitialAccount) {
        updateSessionSummary(null);
        setAccessControlEnabled(serverInfo.hasUsers);
        currentUserIsAdmin = false;
        currentUsername = "";
        toggleAdminSettings(false);
        setAdminFeaturesEnabled(serverInfo.hasUsers);
        return;
      }
      const token = normalizeToken(apiKeyInput.value);
      if (!token) {
        updateSessionSummary(null);
        setAccessControlEnabled(false);
        currentUserIsAdmin = false;
        currentUsername = "";
        toggleAdminSettings(false);
        setAdminFeaturesEnabled(false);
        if (authStatus) {
          authStatus.textContent = needsInitialAccount
            ? "No administrator account found. Redirecting to registration…"
            : "Session expired. Redirecting to login…";
        }
        if (needsInitialAccount) {
          sessionStorage.removeItem(tokenStorageKey);
          if (apiKeyInput) apiKeyInput.value = "";
          redirectToRegister();
        } else {
          clearTokenAndRedirect();
        }
        return;
      }
      try {
        const response = await fetch("/ui/auth/profile", {
          headers: bearerHeaders()
        });
        if (!response.ok) {
          if (response.status === 401) {
            sessionStorage.removeItem(tokenStorageKey);
            if (apiKeyInput) apiKeyInput.value = "";
            if (needsInitialAccount) {
              redirectToRegister();
            } else {
              redirectToLogin();
            }
            return;
          }
          throw new Error(`HTTP ${response.status}`);
        }
        const profile = await response.json();
        const user = profile.user;
        if (user && user.username) {
          updateSessionSummary(user);
          currentUsername = user.username;
          const userRole = (user.role || "").toLowerCase();
          currentUserIsAdmin = user.isAdmin === true || userRole === "admin";
          setAccessControlEnabled(currentUserIsAdmin);
          setAdminFeaturesEnabled(currentUserIsAdmin || !serverInfo.hasUsers);
          toggleAdminSettings(currentUserIsAdmin);
          if (currentUserIsAdmin) {
            await ensureAdminDataLoaded();
          } else {
            settingsDataLoaded = false;
          }
          refreshSettingsSelections();
          if (authStatus) {
            authStatus.textContent = `Signed in as ${user.username} (${user.role || "role"}).`;
          }
        } else {
          updateSessionSummary(null);
          setAccessControlEnabled(false);
          currentUserIsAdmin = false;
          currentUsername = "";
          toggleAdminSettings(false);
          setAdminFeaturesEnabled(false);
        }
      } catch (error) {
        updateSessionSummary(null);
        setAccessControlEnabled(false);
        currentUserIsAdmin = false;
        currentUsername = "";
        toggleAdminSettings(false);
        setAdminFeaturesEnabled(false);
        if (authStatus) {
          authStatus.textContent = error.message || "Authentication failed.";
        }
      }
    }

    async function callTool(tool, args = {}) {
      setBusy(true);
      try {
        const response = await fetch("/ui/actions", {
          method: "POST",
          headers: bearerHeaders(),
          body: JSON.stringify({ tool, arguments: args })
        });
        if (!response.ok) {
          const text = await response.text();
          throw new Error(text || response.statusText);
        }
        const json = await response.json();
        if (!json || !json.result) {
          appendError(tool, "Malformed response from server");
          return;
        }
        const payload = json.result;
        const isError = payload.isError === true;
        appendResult(tool, payload, isError);
        handleActionResult(tool, payload, isError);
        if (!isError && payload.data) {
          if (tool === "users_list" && Array.isArray(payload.data.users)) {
            applySettingsUserOptions(payload.data.users);
          }
          if (tool === "roles_list" && Array.isArray(payload.data.roles)) {
            applySettingsRoleOptions(payload.data.roles);
          }
          if (currentUserIsAdmin) {
            refreshSettingsSelections();
          }
        }
        return payload;
      } catch (error) {
        appendError(tool, error.message || "Unexpected error");
        return null;
      } finally {
        setBusy(false);
      }
    }

    function callAdmin(action, args = {}) {
      return callTool(action, args);
    }

    async function callAdminSilent(action, args = {}) {
      try {
        const response = await fetch("/ui/actions", {
          method: "POST",
          headers: bearerHeaders(),
          body: JSON.stringify({ tool: action, arguments: args })
        });
        if (!response.ok) {
          return null;
        }
        const json = await response.json();
        if (!json || !json.result) {
          return null;
        }
        return json.result;
      } catch (error) {
        console.warn("Admin request failed", error);
        return null;
      }
    }

    async function ensureAdminDataLoaded() {
      if (!currentUserIsAdmin || settingsDataLoaded) {
        return;
      }
      const rolesResponse = await callAdminSilent("roles_list");
      if (rolesResponse && rolesResponse.data && Array.isArray(rolesResponse.data.roles)) {
        applySettingsRoleOptions(rolesResponse.data.roles);
      }
      const usersResponse = await callAdminSilent("users_list");
      if (usersResponse && usersResponse.data && Array.isArray(usersResponse.data.users)) {
        applySettingsUserOptions(usersResponse.data.users);
      }
      settingsDataLoaded = true;
      refreshSettingsSelections();
    }

    if (apiKeyInput) {
      apiKeyInput.addEventListener("change", updateStoredTokenFromInput);
      apiKeyInput.addEventListener("blur", updateStoredTokenFromInput);
    }

    if (logoutBtn) {
      logoutBtn.addEventListener("click", () => {
        statusBar.textContent = "Signed out.";
        clearTokenAndRedirect();
      });
    }

    const storedTheme = localStorage.getItem(themeStorageKey) || "dark";
    applyThemePreference(storedTheme, false);

    const storedToken = sessionStorage.getItem(tokenStorageKey);
    if (storedToken) {
      apiKeyInput.value = normalizeToken(storedToken);
    }

    if (themeRadios && themeRadios.length > 0) {
      themeRadios.forEach(radio => {
        radio.addEventListener("change", event => {
          const target = event.currentTarget;
          if (target instanceof HTMLInputElement && target.checked) {
            applyThemePreference(target.value, true);
          }
        });
      });
    }

    if (settingsToggle && settingsPopover && settingsWrapper) {
      settingsToggle.addEventListener("click", async event => {
        event.stopPropagation();
        const isOpen = settingsPopover.classList.toggle("open");
        settingsToggle.setAttribute("aria-expanded", isOpen ? "true" : "false");
        settingsPopover.setAttribute("aria-hidden", isOpen ? "false" : "true");
        if (isOpen && currentUserIsAdmin) {
          await ensureAdminDataLoaded();
          refreshSettingsSelections();
        }
      });
      document.addEventListener("click", event => {
        if (!settingsPopover.classList.contains("open")) {
          return;
        }
        if (!settingsWrapper.contains(event.target)) {
          settingsPopover.classList.remove("open");
          settingsToggle.setAttribute("aria-expanded", "false");
          settingsPopover.setAttribute("aria-hidden", "true");
        }
      });
      document.addEventListener("keydown", event => {
        if (event.key === "Escape" && settingsPopover.classList.contains("open")) {
          settingsPopover.classList.remove("open");
          settingsToggle.setAttribute("aria-expanded", "false");
          settingsPopover.setAttribute("aria-hidden", "true");
        }
      });
    }

    if (settingsUserSelect) {
      settingsUserSelect.addEventListener("change", () => {
        const selectedUser = settingsUsers.find(user => user.username === settingsUserSelect.value);
        if (selectedUser && settingsRoleSelect) {
          settingsRoleSelect.value = selectedUser.role || "";
        }
        if (settingsRoleStatus) {
          settingsRoleStatus.textContent = "";
          settingsRoleStatus.classList.remove("error");
        }
      });
    }

    if (settingsRoleApply) {
      settingsRoleApply.addEventListener("click", async () => {
        if (!currentUserIsAdmin) {
          if (settingsRoleStatus) {
            settingsRoleStatus.textContent = "Only administrators can change roles.";
            settingsRoleStatus.classList.add("error");
          }
          return;
        }
        const targetUser = settingsUserSelect ? settingsUserSelect.value : currentUsername;
        const selectedRole = settingsRoleSelect ? settingsRoleSelect.value : "";
        if (!targetUser || !selectedRole) {
          if (settingsRoleStatus) {
            settingsRoleStatus.textContent = "Select a user and role to apply.";
            settingsRoleStatus.classList.add("error");
          }
          return;
        }
        if (settingsRoleStatus) {
          settingsRoleStatus.textContent = "Applying role…";
          settingsRoleStatus.classList.remove("error");
        }
        settingsDataLoaded = false;
        const payload = buildPayload({
          username: targetUser,
          role: selectedRole
        });
        const result = await callAdmin("users_add", payload);
        if (result && result.isError !== true) {
          if (settingsRoleStatus) {
            settingsRoleStatus.textContent = "Role updated.";
            settingsRoleStatus.classList.remove("error");
          }
          await ensureAdminDataLoaded();
          await updateAuthState();
        } else if (settingsRoleStatus) {
          settingsRoleStatus.textContent = (result && result.message) || "Failed to update role.";
          settingsRoleStatus.classList.add("error");
        }
      });
    }

    document.getElementById("registerBtn").addEventListener("click", () => {
      if (!currentUserIsAdmin) {
        statusBar.textContent = "Only administrators can register libraries.";
        return;
      }
      const name = document.getElementById("registerName").value.trim();
      const version = document.getElementById("registerVersion").value.trim();
      const docs = document.getElementById("registerDocs").value;
      const description = document.getElementById("registerDescription").value.trim();
      if (!name || !version || !docs.trim()) {
        appendError("register_library", "Name, version, and documentation are required.");
        return;
      }
      callTool("register_library", buildPayload({
        name,
        version,
        docs,
        description
      }));
    });

    document.getElementById("registerResetBtn").addEventListener("click", () => {
      if (!currentUserIsAdmin) {
        statusBar.textContent = "Only administrators can modify registration form.";
        return;
      }
      document.getElementById("registerName").value = "";
      document.getElementById("registerVersion").value = "";
      document.getElementById("registerDescription").value = "";
      document.getElementById("registerDocs").value = "";
      statusBar.textContent = "Cleared register form inputs.";
    });

    document.getElementById("searchBtn").addEventListener("click", () => {
      const query = document.getElementById("searchQuery").value.trim();
      if (!query) {
        appendError("search_libraries", "Search query is required.");
        return;
      }
      callTool("search_libraries", { query });
    });

    document.getElementById("docsBtn").addEventListener("click", () => {
      const name = document.getElementById("docsName").value.trim();
      const version = document.getElementById("docsVersion").value.trim();
      const maxCharacters = parseInt(document.getElementById("docsMax").value, 10) || 5000;
      const topic = document.getElementById("docsTopics").value.trim();
      const topicMatch = document.getElementById("docsTopicMatch").value;
      if (!name) {
        appendError("get_library_docs", "Library name is required.");
        return;
      }
      callTool("get_library_docs", buildPayload({
        name,
        version,
        max_characters: maxCharacters,
        topic,
        topic_match: topicMatch
      }));
    });

    const exportBtn = document.getElementById("exportBtn");
    if (exportBtn) {
      exportBtn.addEventListener("click", () => {
        const name = document.getElementById("exportName").value.trim();
        const version = document.getElementById("exportVersion").value.trim();
        if (!name) {
          appendError("library_export", "Library name is required for export.");
          return;
        }
        callAdmin("library_export", buildPayload({ name, version }));
      });
    }

    const importBtn = document.getElementById("importBtn");
    if (importBtn) {
      importBtn.addEventListener("click", () => {
        const raw = document.getElementById("importJson").value.trim();
        if (!raw) {
          appendError("library_import", "Paste a JSON payload before importing.");
          return;
        }
        try {
          const library = JSON.parse(raw);
          callAdmin("library_import", { library });
        } catch (error) {
          appendError("library_import", "Invalid JSON payload: " + (error.message || ""));
        }
      });
    }

    const importClearBtn = document.getElementById("importClearBtn");
    if (importClearBtn) {
      importClearBtn.addEventListener("click", () => {
        document.getElementById("importJson").value = "";
        statusBar.textContent = "Cleared import payload.";
      });
    }

    const gitListBtn = document.getElementById("gitListBtn");
    if (gitListBtn) {
      gitListBtn.addEventListener("click", () => {
        callAdmin("git_list", {});
      });
    }

    const gitAddBtn = document.getElementById("gitAddBtn");
    if (gitAddBtn) {
      gitAddBtn.addEventListener("click", () => {
        const descriptor = buildPayload({
          id: document.getElementById("gitId").value,
          url: document.getElementById("gitUrl").value,
          docsPath: document.getElementById("gitDocsPath").value,
          branch: document.getElementById("gitBranch").value,
          library: document.getElementById("gitLibrary").value,
          version: document.getElementById("gitVersion").value,
          autoSync: document.getElementById("gitAutoSync").checked
        });
        callAdmin("git_add", descriptor);
      });
    }

    const gitSyncBtn = document.getElementById("gitSyncBtn");
    if (gitSyncBtn) {
      gitSyncBtn.addEventListener("click", () => {
        const repoId = document.getElementById("gitId").value.trim();
        callAdmin("git_sync", repoId ? { id: repoId } : {});
      });
    }

    const gitSyncAllBtn = document.getElementById("gitSyncAllBtn");
    if (gitSyncAllBtn) {
      gitSyncAllBtn.addEventListener("click", () => {
        callAdmin("git_sync", {});
      });
    }

    const gitRemoveBtn = document.getElementById("gitRemoveBtn");
    if (gitRemoveBtn) {
      gitRemoveBtn.addEventListener("click", () => {
        const repoId = document.getElementById("gitId").value.trim();
        if (!repoId) {
          appendError("git_remove", "Provide a repository ID before removing.");
          return;
        }
        callAdmin("git_remove", { id: repoId });
      });
    }

    const backupCreateBtn = document.getElementById("backupCreateBtn");
    if (backupCreateBtn) {
      backupCreateBtn.addEventListener("click", () => {
        const note = document.getElementById("backupNote").value.trim();
        callAdmin("backup_create", buildPayload({ note }));
      });
    }

    const backupListBtn = document.getElementById("backupListBtn");
    if (backupListBtn) {
      backupListBtn.addEventListener("click", () => {
        callAdmin("backup_list");
      });
    }

    const backupRestoreBtn = document.getElementById("backupRestoreBtn");
    if (backupRestoreBtn) {
      backupRestoreBtn.addEventListener("click", () => {
        const snapshotId = document.getElementById("backupSnapshotId").value.trim();
        if (!snapshotId) {
          appendError("backup_restore", "Snapshot ID is required to restore.");
          return;
        }
        callAdmin("backup_restore", { snapshotId });
      });
    }

    const backupPruneBtn = document.getElementById("backupPruneBtn");
    if (backupPruneBtn) {
      backupPruneBtn.addEventListener("click", () => {
        callAdmin("backup_prune");
      });
    }

    const userAddBtn = document.getElementById("userAddBtn");
    if (userAddBtn) {
      userAddBtn.addEventListener("click", () => {
        const username = getUsernameValue();
        if (!username) {
          appendError("users_add", "Provide a username before saving.");
          return;
        }
        const librariesField = document.getElementById("userLibraries");
        const rawLibraries = librariesField ? librariesField.value : "";
        const payloadBase = {
          username,
          role: document.getElementById("userRole") ? document.getElementById("userRole").value : "",
          active: document.getElementById("userActive") ? document.getElementById("userActive").checked : true,
          rotateToken: document.getElementById("userRotateToken") ? document.getElementById("userRotateToken").checked : false
        };
        if (rawLibraries && rawLibraries.trim().length > 0) {
          payloadBase.libraries = splitCsv(rawLibraries);
        }
        const payload = buildPayload(payloadBase);
        const passwordField = document.getElementById("userPassword");
        if (passwordField && passwordField.value.trim().length > 0) {
          payload.password = passwordField.value;
        }
        callAdmin("users_add", payload);
      });
    }

    const userListBtn = document.getElementById("userListBtn");
    if (userListBtn) {
      userListBtn.addEventListener("click", () => {
        callAdmin("users_list");
      });
    }

    const userDeactivateBtn = document.getElementById("userDeactivateBtn");
    if (userDeactivateBtn) {
      userDeactivateBtn.addEventListener("click", () => {
        const username = getUsernameValue();
        if (!username) {
          appendError("users_deactivate", "Provide a username to deactivate.");
          return;
        }
        callAdmin("users_deactivate", { username });
      });
    }

    const userActivateBtn = document.getElementById("userActivateBtn");
    if (userActivateBtn) {
      userActivateBtn.addEventListener("click", () => {
        const username = getUsernameValue();
        if (!username) {
          appendError("users_activate", "Provide a username to activate.");
          return;
        }
        callAdmin("users_activate", { username });
      });
    }

    const userRotateBtn = document.getElementById("userRotateBtn");
    if (userRotateBtn) {
      userRotateBtn.addEventListener("click", () => {
        const username = getUsernameValue();
        if (!username) {
          appendError("users_add", "Provide a username before rotating a token.");
          return;
        }
        callAdmin("users_add", { username, rotateToken: true });
      });
    }

    const userRemoveBtn = document.getElementById("userRemoveBtn");
    if (userRemoveBtn) {
      userRemoveBtn.addEventListener("click", () => {
        const username = getUsernameValue();
        if (!username) {
          appendError("users_remove", "Provide a username to remove.");
          return;
        }
        callAdmin("users_remove", { username });
      });
    }

    const roleAddBtn = document.getElementById("roleAddBtn");
    if (roleAddBtn) {
      roleAddBtn.addEventListener("click", () => {
        const permissions = splitCsv(document.getElementById("rolePermissions").value);
        callAdmin("roles_add", buildPayload({
          name: document.getElementById("roleName").value,
          permissions
        }));
      });
    }

    const roleListBtn = document.getElementById("roleListBtn");
    if (roleListBtn) {
      roleListBtn.addEventListener("click", () => {
        callAdmin("roles_list");
      });
    }

    const roleRemoveBtn = document.getElementById("roleRemoveBtn");
    if (roleRemoveBtn) {
      roleRemoveBtn.addEventListener("click", () => {
        const name = document.getElementById("roleName").value.trim();
        if (!name) {
          appendError("roles_remove", "Provide a role name to remove.");
          return;
        }
        callAdmin("roles_remove", { name });
      });
    }

    async function fetchInfo() {
      try {
        const response = await fetch("/ui/info", {
          headers: bearerHeaders()
        });
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }
        const info = await response.json();
        applyServerInfo(info);
        connectionLabel.textContent = `${info.name} v${info.version}`;
        connectionChip.title = `Transport: ${info.transport}`;
        connectionChip.querySelector(".connection-dot").style.background = "#5dff8f";
        statusBar.textContent = `Connected to ${info.name} v${info.version} using ${info.transport} transport.`;
        await updateAuthState();
      } catch (error) {
        connectionLabel.textContent = "Connection failed";
        connectionChip.querySelector(".connection-dot").style.background = "#ff667c";
        statusBar.textContent = error.message || "Failed to load server information.";
        serverInfo = null;
        updateSessionSummary(null);
        setAccessControlEnabled(false);
      }
    }

    fetchInfo();
  </script>
</body>
</html>
"""
