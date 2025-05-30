// Context7 Service Worker
const CACHE_NAME = 'context7-v1';
const API_CACHE = 'context7-api-v1';

// Assets to cache for offline use
const STATIC_ASSETS = [
    '/',
    '/index.html',
    '/manifest.json',
    '/css/main.css',
    '/js/app.js',
    '/context7.wasm',
    'https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css',
    'https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/grids-responsive-min.css',
    'https://unpkg.com/htmx.org@1.9.10',
    'https://cdn.jsdelivr.net/npm/cash-dom@8.1.5/dist/cash.min.js'
];

// Install event - cache static assets
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => {
                console.log('Caching static assets');
                return cache.addAll(STATIC_ASSETS);
            })
            .then(() => self.skipWaiting())
    );
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys()
            .then(cacheNames => {
                return Promise.all(
                    cacheNames
                        .filter(name => name !== CACHE_NAME && name !== API_CACHE)
                        .map(name => caches.delete(name))
                );
            })
            .then(() => self.clients.claim())
    );
});

// Fetch event - serve from cache when offline
self.addEventListener('fetch', (event) => {
    const { request } = event;
    const url = new URL(request.url);
    
    // Skip non-GET requests
    if (request.method !== 'GET') return;
    
    // Handle API requests
    if (url.pathname.startsWith('/api/')) {
        event.respondWith(handleApiRequest(request));
        return;
    }
    
    // Handle static assets
    event.respondWith(handleStaticRequest(request));
});

// Handle static asset requests
async function handleStaticRequest(request) {
    const cache = await caches.open(CACHE_NAME);
    
    try {
        // Try network first for HTML files
        if (request.headers.get('accept').includes('text/html')) {
            const networkResponse = await fetch(request);
            
            // Update cache with fresh response
            if (networkResponse.ok) {
                cache.put(request, networkResponse.clone());
            }
            
            return networkResponse;
        }
    } catch (error) {
        // Fall back to cache if network fails
    }
    
    // Try cache first for other assets
    const cachedResponse = await cache.match(request);
    if (cachedResponse) {
        return cachedResponse;
    }
    
    // Try network if not in cache
    try {
        const networkResponse = await fetch(request);
        
        // Cache successful responses
        if (networkResponse.ok) {
            cache.put(request, networkResponse.clone());
        }
        
        return networkResponse;
    } catch (error) {
        // Return offline page if available
        if (request.headers.get('accept').includes('text/html')) {
            const offlineResponse = await cache.match('/offline.html');
            if (offlineResponse) {
                return offlineResponse;
            }
        }
        
        return new Response('Offline', {
            status: 503,
            statusText: 'Service Unavailable'
        });
    }
}

// Handle API requests with caching strategy
async function handleApiRequest(request) {
    const cache = await caches.open(API_CACHE);
    
    // Try network first
    try {
        const networkResponse = await fetch(request);
        
        // Cache successful GET responses
        if (networkResponse.ok && request.method === 'GET') {
            cache.put(request, networkResponse.clone());
        }
        
        return networkResponse;
    } catch (error) {
        // Fall back to cache for GET requests
        if (request.method === 'GET') {
            const cachedResponse = await cache.match(request);
            if (cachedResponse) {
                // Add header to indicate cached response
                const headers = new Headers(cachedResponse.headers);
                headers.set('X-From-Cache', 'true');
                
                return new Response(cachedResponse.body, {
                    status: cachedResponse.status,
                    statusText: cachedResponse.statusText,
                    headers: headers
                });
            }
        }
        
        // Return error response
        return new Response(
            JSON.stringify({ error: 'Network error - offline mode' }),
            {
                status: 503,
                statusText: 'Service Unavailable',
                headers: {
                    'Content-Type': 'application/json'
                }
            }
        );
    }
}

// Background sync for offline actions
self.addEventListener('sync', (event) => {
    if (event.tag === 'sync-libraries') {
        event.waitUntil(syncLibraries());
    }
});

async function syncLibraries() {
    // Implement background sync logic here
    console.log('Background sync: syncing libraries');
}

// Push notifications
self.addEventListener('push', (event) => {
    const options = {
        body: event.data ? event.data.text() : 'New update available',
        icon: '/assets/icon-192.png',
        badge: '/assets/icon-192.png',
        vibrate: [200, 100, 200]
    };
    
    event.waitUntil(
        self.registration.showNotification('Context7', options)
    );
});

// Notification click handler
self.addEventListener('notificationclick', (event) => {
    event.notification.close();
    
    event.waitUntil(
        clients.openWindow('/')
    );
});