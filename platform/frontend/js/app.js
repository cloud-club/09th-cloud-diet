/**
 * app.js — GitHub API client, auth, and shared utilities
 */

const APP = {
  // Will be set from group.yaml or defaults
  REPO: '',
  OWNER: '',
  API_BASE: 'https://api.github.com',

  // Local dev mode: serves files from project root instead of GitHub API
  LOCAL: location.hostname === 'localhost' || location.hostname === '127.0.0.1',
  LOCAL_BASE: '../..', // relative path from platform/frontend/ to project root

  /** Get stored GitHub token */
  getToken() {
    return localStorage.getItem('gh_token') || '';
  },

  /** Save GitHub token */
  setToken(token) {
    localStorage.setItem('gh_token', token);
  },

  /** Get current username (cached after first fetch) */
  getUsername() {
    if (this.LOCAL) return localStorage.getItem('gh_username') || 'leejiseok';
    return localStorage.getItem('gh_username') || '';
  },

  setUsername(username) {
    localStorage.setItem('gh_username', username);
  },

  /** Check if user is logged in */
  isLoggedIn() {
    if (this.LOCAL) return true; // auto-login in local mode
    return !!this.getToken() && !!this.getUsername();
  },

  /** Logout */
  logout() {
    localStorage.removeItem('gh_token');
    localStorage.removeItem('gh_username');
    localStorage.removeItem('gh_is_admin');
    window.location.href = 'index.html';
  },

  /** Check if current user is admin */
  isAdmin() {
    if (this.LOCAL) return true;
    return localStorage.getItem('gh_is_admin') === 'true';
  },

  /**
   * Make authenticated GitHub API request
   */
  async api(endpoint, options = {}) {
    const token = this.getToken();
    const headers = {
      'Accept': 'application/vnd.github.v3+json',
      ...options.headers,
    };
    if (token) {
      headers['Authorization'] = `token ${token}`;
    }

    const url = endpoint.startsWith('http') ? endpoint : `${this.API_BASE}${endpoint}`;
    const resp = await fetch(url, { ...options, headers });

    if (!resp.ok) {
      const body = await resp.text();
      throw new Error(`GitHub API ${resp.status}: ${body}`);
    }

    if (resp.status === 204) return null;
    return resp.json();
  },

  /**
   * Get file content from repo (base64 decoded)
   */
  async getFileContent(path) {
    if (this.LOCAL) {
      const resp = await fetch(`${this.LOCAL_BASE}/${path}`);
      if (!resp.ok) throw new Error(`Local file not found: ${path}`);
      return resp.text();
    }
    const data = await this.api(`/repos/${this.OWNER}/${this.REPO}/contents/${path}`);
    if (data.encoding === 'base64') {
      return decodeURIComponent(escape(atob(data.content)));
    }
    return data.content;
  },

  /**
   * Get JSON file from repo
   */
  async getJSON(path) {
    if (this.LOCAL) {
      const resp = await fetch(`${this.LOCAL_BASE}/${path}`);
      if (!resp.ok) throw new Error(`Local file not found: ${path}`);
      return resp.json();
    }
    const content = await this.getFileContent(path);
    return JSON.parse(content);
  },

  /**
   * Get YAML file from repo (simple parser for our use case)
   */
  async getYAML(path) {
    const content = await this.getFileContent(path);
    return parseSimpleYAML(content);
  },

  /**
   * List directory contents in repo
   */
  async listDir(path) {
    if (this.LOCAL) {
      // Local mode: use a pre-generated index or return known structure
      return this._localListDir(path);
    }
    try {
      return await this.api(`/repos/${this.OWNER}/${this.REPO}/contents/${path}`);
    } catch {
      return [];
    }
  },

  /**
   * Local mode directory listing (reads from _index.json files)
   */
  async _localListDir(path) {
    try {
      const resp = await fetch(`${this.LOCAL_BASE}/${path}/_index.json`);
      if (resp.ok) return resp.json();
    } catch {}
    return [];
  },

  /**
   * Verify token and fetch username
   */
  async login(token) {
    this.setToken(token);
    try {
      const user = await this.api('/user');
      this.setUsername(user.login);

      // Check admin status from group.yaml
      try {
        const groupYaml = await this.getFileContent('platform/config/group.yaml');
        const isAdmin = groupYaml.includes(user.login) &&
          groupYaml.split('admins:')[1]?.includes(user.login);
        localStorage.setItem('gh_is_admin', isAdmin ? 'true' : 'false');
      } catch {
        localStorage.setItem('gh_is_admin', 'false');
      }

      return user;
    } catch (e) {
      this.logout();
      throw e;
    }
  },

  /**
   * Create a GitHub Issue (for submissions)
   */
  async createIssue(title, body, labels = []) {
    return this.api(`/repos/${this.OWNER}/${this.REPO}/issues`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title, body, labels }),
    });
  },

  /**
   * Trigger a workflow dispatch
   */
  async triggerWorkflow(workflowFile, inputs = {}) {
    return this.api(
      `/repos/${this.OWNER}/${this.REPO}/actions/workflows/${workflowFile}/dispatches`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ ref: 'main', inputs }),
      }
    );
  },

  /**
   * Initialize app — load repo config
   */
  async init() {
    if (this.LOCAL) {
      console.log('[LOCAL MODE] Serving files from project root');
      this.updateAuthUI();
      return;
    }

    // Try to load from group.yaml, fall back to defaults
    try {
      const content = await this.getFileContent('platform/config/group.yaml');
      const repoMatch = content.match(/repo:\s*"?([^"\n]+)"?/);
      if (repoMatch) {
        const [owner, repo] = repoMatch[1].split('/');
        this.OWNER = owner;
        this.REPO = repo;
      }
    } catch {
      // Use defaults from URL or hardcoded
      this.OWNER = 'cloud-club';
      this.REPO = '09th-cloud-diet';
    }

    this.updateAuthUI();
  },

  /** Update sidebar footer with user info */
  updateAuthUI() {
    const authArea = document.getElementById('auth-area');
    if (!authArea) return;

    if (this.isLoggedIn()) {
      const username = this.getUsername();
      const initial = username.charAt(0).toUpperCase();
      authArea.innerHTML = `
        <div class="sidebar-user">
          <div class="avatar">${initial}</div>
          <div class="user-info">
            <div class="user-name">@${escapeHtml(username)}</div>
            <div class="user-role">${this.isAdmin() ? 'Admin' : 'Member'}</div>
          </div>
          <button onclick="APP.logout()" class="btn btn-ghost btn-sm" title="Logout" style="padding:4px;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
          </button>
        </div>
      `;
    } else {
      authArea.innerHTML = `
        <button onclick="showLoginModal()" class="btn btn-primary" style="width:100%;">Login</button>
      `;
    }
  }
};

// ── Simple YAML parser (handles our flat configs) ──

function parseSimpleYAML(text) {
  // Supports: top-level scalars, top-level lists (of scalars or objects),
  // and lists of multi-line objects (each "- key: val" followed by indented "  key2: val2" lines).
  const coerce = (raw) => {
    const v = String(raw).trim().replace(/^["']|["']$/g, '');
    if (v === '' || v === 'null') return null;
    if (v === 'true') return true;
    if (v === 'false') return false;
    if (/^-?\d+$/.test(v)) return parseInt(v, 10);
    if (/^-?\d+\.\d+$/.test(v)) return parseFloat(v);
    return v;
  };

  const result = {};
  let currentKey = null;        // key whose value is a list/object being filled
  let currentListItem = null;   // when inside a list of objects, the object being built
  let listItemIndent = -1;      // indentation level of "- " for the current list
  let listItemBodyIndent = -1;  // indentation of nested keys inside the current list item

  for (const rawLine of text.split('\n')) {
    if (!rawLine.trim() || rawLine.trim().startsWith('#')) continue;

    const indent = rawLine.match(/^(\s*)/)[1].length;
    const trimmed = rawLine.trim();

    // List item start: "- key: val" or "- value"
    if (trimmed.startsWith('- ')) {
      const body = trimmed.slice(2);

      // Ensure parent key holds an array
      if (currentKey === null) continue;
      if (!Array.isArray(result[currentKey])) result[currentKey] = [];

      listItemIndent = indent;
      listItemBodyIndent = -1; // will be set on first nested line

      if (body.includes(':')) {
        // First key of an object item
        const m = body.match(/^([\w_-]+)\s*:\s*(.*)$/);
        if (m) {
          currentListItem = {};
          const val = m[2].trim();
          if (val) currentListItem[m[1]] = coerce(val);
          // If the same line also has inline "k1: v1, k2: v2" comma form, parse extras
          // (kept conservative — most YAML won't need this)
          result[currentKey].push(currentListItem);
          continue;
        }
      }
      // Scalar item
      result[currentKey].push(coerce(body));
      currentListItem = null;
      continue;
    }

    // Nested key inside the current list item: "  key: value"
    if (currentListItem !== null && indent > listItemIndent) {
      if (listItemBodyIndent === -1) listItemBodyIndent = indent;
      if (indent >= listItemBodyIndent) {
        const m = trimmed.match(/^([\w_-]+)\s*:\s*(.*)$/);
        if (m) { currentListItem[m[1]] = coerce(m[2]); continue; }
      }
    }

    // Top-level / non-list "key: value"
    const m = trimmed.match(/^([\w_-]+)\s*:\s*(.*)$/);
    if (m) {
      const key = m[1];
      const val = m[2].trim();
      // Leaving any open list item
      currentListItem = null;

      if (!val) {
        // Start a new list/object container
        result[key] = [];
        currentKey = key;
      } else {
        result[key] = coerce(val);
        currentKey = null;
      }
    }
  }
  return result;
}

// ── Utility functions ──

function escapeHtml(str) {
  const div = document.createElement('div');
  div.textContent = str;
  return div.innerHTML;
}

function showLoginModal() {
  const modal = document.getElementById('login-modal');
  if (modal) modal.classList.add('active');
}

function hideLoginModal() {
  const modal = document.getElementById('login-modal');
  if (modal) modal.classList.remove('active');
}

async function handleLogin() {
  const tokenInput = document.getElementById('token-input');
  const errorEl = document.getElementById('login-error');
  const token = tokenInput.value.trim();

  if (!token) {
    errorEl.textContent = 'Token을 입력하세요.';
    return;
  }

  errorEl.textContent = '';
  try {
    const user = await APP.login(token);
    hideLoginModal();
    window.location.reload();
  } catch (e) {
    errorEl.textContent = '유효하지 않은 토큰입니다.';
  }
}

/** Format date for display */
function formatDate(dateStr) {
  if (!dateStr) return '-';
  const d = new Date(dateStr);
  return d.toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' });
}

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', () => APP.init());
