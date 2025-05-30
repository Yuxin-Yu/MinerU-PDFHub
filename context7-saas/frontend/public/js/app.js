// Context7 PWA Application
(function() {
    'use strict';
    
    // Global state
    const state = {
        user: null,
        token: localStorage.getItem('context7_token'),
        wasmModule: null,
        isOnline: navigator.onLine
    };
    
    // API configuration
    const API_BASE = window.location.hostname === 'localhost' 
        ? 'http://localhost:8000' 
        : 'https://api.context7.com';
    
    // Initialize app
    document.addEventListener('DOMContentLoaded', async () => {
        await initializeWASM();
        setupHTMX();
        setupEventListeners();
        checkAuthentication();
        setupServiceWorker();
        setupOfflineDetection();
    });
    
    // Initialize WebAssembly module
    async function initializeWASM() {
        try {
            const response = await fetch('/context7.wasm');
            const wasmBuffer = await response.arrayBuffer();
            const wasmModule = await WebAssembly.instantiate(wasmBuffer);
            state.wasmModule = wasmModule.instance.exports;
            console.log('WASM module loaded successfully');
        } catch (error) {
            console.error('Failed to load WASM module:', error);
        }
    }
    
    // Setup HTMX configuration
    function setupHTMX() {
        // Add authentication header to all HTMX requests
        document.body.addEventListener('htmx:configRequest', (event) => {
            if (state.token) {
                event.detail.headers['Authorization'] = `Bearer ${state.token}`;
            }
        });
        
        // Handle authentication errors
        document.body.addEventListener('htmx:responseError', (event) => {
            if (event.detail.xhr.status === 401) {
                logout();
                showAlert('セッションが期限切れです。再度ログインしてください。', 'error');
            }
        });
        
        // Update history properly
        document.body.addEventListener('htmx:pushedIntoHistory', (event) => {
            // Update active menu items
            updateActiveMenu();
        });
    }
    
    // Setup event listeners
    function setupEventListeners() {
        // Cash-DOM event delegation
        $(document).on('submit', '#login-form', handleLogin);
        $(document).on('submit', '#register-form', handleRegister);
        $(document).on('submit', '#search-form', handleSearch);
        $(document).on('click', '.library-card', handleLibraryClick);
        $(document).on('click', '#logout-btn', logout);
        
        // PWA install button
        let deferredPrompt;
        window.addEventListener('beforeinstallprompt', (e) => {
            e.preventDefault();
            deferredPrompt = e;
            showInstallButton(deferredPrompt);
        });
    }
    
    // Authentication
    async function checkAuthentication() {
        if (state.token) {
            try {
                const response = await fetch(`${API_BASE}/api/me`, {
                    headers: {
                        'Authorization': `Bearer ${state.token}`
                    }
                });
                
                if (response.ok) {
                    state.user = await response.json();
                    updateAuthMenu();
                } else {
                    logout();
                }
            } catch (error) {
                console.error('Auth check failed:', error);
            }
        }
    }
    
    async function handleLogin(e) {
        e.preventDefault();
        const form = e.target;
        const formData = new FormData(form);
        
        try {
            const response = await fetch(`${API_BASE}/auth/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    email: formData.get('email'),
                    password: formData.get('password')
                })
            });
            
            const data = await response.json();
            
            if (response.ok) {
                state.token = data.token;
                state.user = data.user;
                localStorage.setItem('context7_token', data.token);
                updateAuthMenu();
                htmx.ajax('GET', '/components/search.html', '#main-content');
                showAlert('ログインしました', 'success');
            } else {
                showAlert(data.error || 'ログインに失敗しました', 'error');
            }
        } catch (error) {
            showAlert('ネットワークエラーが発生しました', 'error');
        }
    }
    
    async function handleRegister(e) {
        e.preventDefault();
        const form = e.target;
        const formData = new FormData(form);
        
        try {
            const response = await fetch(`${API_BASE}/auth/register`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    email: formData.get('email'),
                    password: formData.get('password'),
                    organization: formData.get('organization')
                })
            });
            
            const data = await response.json();
            
            if (response.ok) {
                state.token = data.token;
                state.user = data.user;
                localStorage.setItem('context7_token', data.token);
                updateAuthMenu();
                htmx.ajax('GET', '/components/search.html', '#main-content');
                showAlert('アカウントを作成しました', 'success');
            } else {
                showAlert(data.error || '登録に失敗しました', 'error');
            }
        } catch (error) {
            showAlert('ネットワークエラーが発生しました', 'error');
        }
    }
    
    function logout() {
        state.token = null;
        state.user = null;
        localStorage.removeItem('context7_token');
        updateAuthMenu();
        htmx.ajax('GET', '/', '#main-content');
    }
    
    function updateAuthMenu() {
        const authMenu = $('#auth-menu');
        if (state.user) {
            authMenu.html(`
                <a href="#" class="pure-menu-link">${state.user.email}</a>
                <ul class="pure-menu-children">
                    <li class="pure-menu-item">
                        <a href="#" class="pure-menu-link" id="logout-btn">ログアウト</a>
                    </li>
                </ul>
            `);
        } else {
            authMenu.html(`
                <a href="#" class="pure-menu-link" hx-get="/components/login.html" hx-target="#main-content" hx-push-url="/login">ログイン</a>
            `);
            htmx.process(authMenu[0]);
        }
    }
    
    // Search functionality
    async function handleSearch(e) {
        e.preventDefault();
        const form = e.target;
        const query = form.querySelector('input[name="q"]').value;
        
        if (!query) return;
        
        showLoading('#search-results');
        
        try {
            const response = await fetch(`${API_BASE}/api/libraries?q=${encodeURIComponent(query)}`, {
                headers: {
                    'Authorization': `Bearer ${state.token}`
                }
            });
            
            const data = await response.json();
            
            if (response.ok) {
                displaySearchResults(data.libraries);
            } else {
                showAlert('検索中にエラーが発生しました', 'error');
            }
        } catch (error) {
            showAlert('ネットワークエラーが発生しました', 'error');
        }
    }
    
    function displaySearchResults(libraries) {
        const resultsContainer = $('#search-results');
        
        if (libraries.length === 0) {
            resultsContainer.html('<p class="no-results">検索結果が見つかりませんでした</p>');
            return;
        }
        
        // Use WASM for scoring if available
        if (state.wasmModule && state.wasmModule.wasmCalculateSearchScore) {
            const query = $('#search-form input[name="q"]').val();
            libraries.forEach(lib => {
                const score = state.wasmModule.wasmCalculateSearchScore(
                    JSON.stringify(lib),
                    query
                );
                lib.searchScore = score;
            });
            libraries.sort((a, b) => b.searchScore - a.searchScore);
        }
        
        const html = libraries.map(lib => `
            <div class="library-card" data-library-id="${lib.id}">
                <h3>${escapeHtml(lib.name)} v${escapeHtml(lib.version)}</h3>
                <div class="library-meta">
                    <span>組織: ${escapeHtml(lib.organization)}</span>
                    <span>信頼スコア: ${lib.trustScore}/10</span>
                    <span>スニペット数: ${lib.snippetCount}</span>
                </div>
                <p>${escapeHtml(lib.description)}</p>
                <div class="library-tags">
                    ${lib.tags.map(tag => `<span class="tag">${escapeHtml(tag)}</span>`).join('')}
                </div>
            </div>
        `).join('');
        
        resultsContainer.html(html);
    }
    
    async function handleLibraryClick(e) {
        const card = e.currentTarget;
        const libraryId = card.dataset.libraryId;
        
        if (!libraryId) return;
        
        try {
            const response = await fetch(`${API_BASE}/api/libraries/${encodeURIComponent(libraryId)}`, {
                headers: {
                    'Authorization': `Bearer ${state.token}`
                }
            });
            
            const data = await response.json();
            
            if (response.ok) {
                displayLibraryDoc(data);
            } else {
                showAlert('ドキュメントの取得に失敗しました', 'error');
            }
        } catch (error) {
            showAlert('ネットワークエラーが発生しました', 'error');
        }
    }
    
    function displayLibraryDoc(data) {
        const html = `
            <div class="doc-viewer">
                <div class="doc-header">
                    <h1>${escapeHtml(data.library.name)} v${escapeHtml(data.library.version)}</h1>
                    <p>${escapeHtml(data.library.description)}</p>
                    <div class="library-meta">
                        <span>組織: ${escapeHtml(data.library.organization)}</span>
                        <span>最終更新: ${new Date(data.library.lastUpdated).toLocaleDateString('ja-JP')}</span>
                    </div>
                </div>
                <div class="doc-content">
                    ${marked.parse(data.content)}
                </div>
            </div>
        `;
        
        $('#main-content').html(html);
    }
    
    // Service Worker
    async function setupServiceWorker() {
        if ('serviceWorker' in navigator) {
            try {
                const registration = await navigator.serviceWorker.register('/sw.js');
                console.log('Service Worker registered:', registration);
            } catch (error) {
                console.error('Service Worker registration failed:', error);
            }
        }
    }
    
    // Offline detection
    function setupOfflineDetection() {
        window.addEventListener('online', () => {
            state.isOnline = true;
            $('.offline-indicator').hide();
        });
        
        window.addEventListener('offline', () => {
            state.isOnline = false;
            showOfflineIndicator();
        });
    }
    
    function showOfflineIndicator() {
        if (!$('.offline-indicator').length) {
            $('body').append('<div class="offline-indicator">オフラインモード</div>');
        }
        $('.offline-indicator').show();
    }
    
    // Utility functions
    function showAlert(message, type = 'info') {
        const alertHtml = `<div class="alert alert-${type}">${escapeHtml(message)}</div>`;
        const alert = $(alertHtml);
        $('#main-content').prepend(alert);
        
        setTimeout(() => alert.fadeOut(() => alert.remove()), 5000);
    }
    
    function showLoading(selector) {
        $(selector).html('<div class="loading"></div>');
    }
    
    function escapeHtml(text) {
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return text.replace(/[&<>"']/g, m => map[m]);
    }
    
    function updateActiveMenu() {
        const path = window.location.pathname;
        $('.pure-menu-link').removeClass('active');
        $(`.pure-menu-link[href="${path}"]`).addClass('active');
    }
    
    function showInstallButton(deferredPrompt) {
        const installBtn = $('<button class="install-button">アプリをインストール</button>');
        $('body').append(installBtn);
        installBtn.show();
        
        installBtn.on('click', async () => {
            deferredPrompt.prompt();
            const { outcome } = await deferredPrompt.userChoice;
            
            if (outcome === 'accepted') {
                console.log('PWA installed');
                installBtn.hide();
            }
        });
    }
    
    // Export for debugging
    window.Context7 = { state, API_BASE };
})();