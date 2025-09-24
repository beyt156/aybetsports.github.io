<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aybet Sports - Canlı Maç Yayını</title>
    
    <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <script src="https://voetbaluitslagen.be/ranking.min.js" async></script>

    <style>
        :root {
            --primary-accent: #FFD700;
            --primary-accent-rgb: 255, 215, 0;
            --accent-glow: 0 0 20px rgba(var(--primary-accent-rgb), 0.5);
            
            --bg-deep-dark: #0D0D10;
            --bg-card: #16161A;
            --bg-element: #25252A;
            
            --border-color: rgba(255, 255, 255, 0.1);
            
            --text-primary: #F0F0F5;
            --text-secondary: #94A1B2;
            --text-on-accent: #000000;
            
            --radius: 16px;
            --transition: 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        *, *::before, *::after {
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background-color: var(--bg-deep-dark);
            color: var(--text-primary);
            padding: 2rem;
            background-image: radial-gradient(circle at 1% 1%, rgba(var(--primary-accent-rgb), 0.08), transparent 40%),
                              radial-gradient(circle at 99% 99%, rgba(100, 120, 255, 0.05), transparent 50%);
        }

        .container {
            width: 100%;
            max-width: 1400px;
            margin: auto;
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 2rem;
        }

        .header {
            grid-column: 1 / -1;
            text-align: center;
        }
        .header .logo { width: 150px; margin-bottom: 1.5rem; }
        .header .banner { width: 100%; max-width: 900px; border-radius: var(--radius); }

        .player-section {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .player-card {
            background: var(--bg-card);
            border-radius: var(--radius);
            border: 1px solid var(--border-color);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }

        .video-wrapper {
            position: relative;
            padding-top: 56.25%;
            background-color: #000;
        }

        #video-stream, #iframe-stream {
            position: absolute; top: 0; left: 0;
            width: 100%; height: 100%;
            border: none;
        }

        #player-overlay {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            display: flex; flex-direction: column; justify-content: center; align-items: center;
            background-color: rgba(0,0,0,0.8); z-index: 10;
            opacity: 0; visibility: hidden; transition: opacity var(--transition);
        }
        #player-overlay.visible { opacity: 1; visibility: visible; }
        
        #loading-spinner {
            border: 4px solid rgba(255,255,255,0.2);
            border-top-color: var(--primary-accent);
            border-radius: 50%; width: 50px; height: 50px;
            animation: spin 1s linear infinite; display: none;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        #error-message {
            color: #ff6b6b; font-size: 1.1rem;
            font-weight: 500; display: none; text-align: center; padding: 1rem;
        }
        
        #player-overlay.is-loading #loading-spinner { display: block; }
        #player-overlay.has-error #error-message { display: block; }
        #player-overlay.has-error #loading-spinner { display: none; }
        
        .player-controls {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        
        #match-title {
            font-size: 1.75rem;
            font-weight: 600;
            line-height: 1.2;
            color: var(--primary-accent);
            text-shadow: var(--accent-glow);
            margin: 0;
        }

        .stream-controls {
            display: flex;
            gap: 1rem;
        }
        .stream-controls button {
            flex: 1;
            padding: 0.8rem 1rem;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-secondary);
            background-color: var(--bg-element);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            cursor: pointer;
            transition: all var(--transition);
        }
        .stream-controls button:hover {
            color: var(--text-primary);
            border-color: var(--primary-accent);
            background-color: var(--bg-card);
        }
        .stream-controls button.active {
            color: var(--text-on-accent);
            background-color: var(--primary-accent);
            border-color: var(--primary-accent);
            box-shadow: var(--accent-glow);
        }
        
        .widget-card {
            background: var(--bg-card);
            border-radius: var(--radius);
            border: 1px solid var(--border-color);
            padding: 1rem;
        }

        .sidebar {
            background: var(--bg-card);
            border-radius: var(--radius);
            border: 1px solid var(--border-color);
            padding: 1.5rem 1rem;
            align-self: start;
            max-height: calc(100vh - 4rem);
            overflow-y: auto;
        }
        .sidebar h3 {
            font-size: 1.25rem; font-weight: 600;
            text-align: center; margin: 0 0 1.5rem 0;
            padding: 0 0.5rem 1rem 0.5rem;
            border-bottom: 1px solid var(--border-color);
        }
        
        #channel-list { display: flex; flex-direction: column; gap: 0.75rem; padding: 0 0.5rem;}
        
        .channel {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-radius: 10px;
            background-color: var(--bg-element);
            border: 1px solid var(--border-color);
            color: var(--text-secondary);
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition);
            position: relative;
        }
        .channel:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
            color: var(--text-primary);
            border-color: var(--primary-accent);
        }
        .channel.active {
            color: var(--text-on-accent);
            background-color: var(--primary-accent);
            border-color: var(--primary-accent);
            font-weight: 600;
            box-shadow: var(--accent-glow);
        }
        .channel.inactive {
            opacity: 0.5; cursor: not-allowed;
        }
        .channel.inactive:hover { transform: none; box-shadow: none; border-color: var(--border-color); }

        .footer {
            grid-column: 1 / -1; text-align: center;
            margin-top: 1.5rem; padding-top: 1.5rem;
            border-top: 1px solid var(--border-color);
        }
        .footer img { border-radius: var(--radius); }

        /* Responsive */
        @media (max-width: 1100px) {
            .container { grid-template-columns: 1fr; }
            .sidebar { max-height: 450px; }
        }
        @media (max-width: 768px) {
            body { padding: 1rem; }
            .container { gap: 1.5rem; }
            #match-title { font-size: 1.5rem; }
            .player-controls { padding: 1rem; }
            .stream-controls { flex-direction: column; }
        }

    </style>
</head>
<body>

    <div class="container">
        <header class="header">
            <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgkhr2HZisgzBR7fnEvaHRX5uwBnfR7pikBXTxMCNheW2un_X56sIoPdWbzxKQLWio8VAMysEyHnmo-Uzp3QP_oj4kT31FqdnwIofNuF0wFtE5O8acBzihyhLaSdMh_xOYwcQOIJYosni0hA9h_YvoJh_o0ZSamxgv-NJS5B2HThsFKz6y-mKpAilnU01I/s320/DALL%C2%B7E%202025-01-24%2019.56.56%20-%20Create%20a%20sports-themed%20logo%20for%20&#39;Aybet%20Sports&#39;.%20The%20design%20should%20feature%20a%20dynamic%20and%20energetic%20style%20with%20a%20bold,%20modern%20font.%20Use%20vibrant%20colors%20s.webp" alt="Aybet Sports Logo" class="logo">
            <img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjGxFsk-leLt8bB05mfHSquXsze7brNBIRuGYHqVb8WPj0t3mIvvg4xGTFyG1ruxDF-c5aKZK0BgUwM0ACpHL1LFwW4GWBnK8dslI4xwgRrrNP3U_fDhBR03F-nEhPMEu-m3WnrbeuFfuIUsnOfadpjyh3nY-GlaIOBNPb-oijs5Dc_fvHeR3b0H6s0hINk/s484/Ekran%20g%C3%B6r%C3%BCnt%C3%BCs%C3%BC_31-3-2025_101934_aybetlisans.blogspot.com.jpeg" alt="Banner" class="banner">
        </header>

        <main class="player-section">
            <div class="player-card">
                <div class="video-wrapper">
                    <div id="player-overlay">
                        <div id="loading-spinner"></div>
                        <span id="error-message"></span>
                    </div>
                    <video id="video-stream" style="display:none;" controls></video>
                    <iframe id="iframe-stream" style="display:none;" allowfullscreen></iframe>
                </div>
                <div class="player-controls">
                    <h1 id="match-title">Yayın Seçiniz...</h1>
                    <div class="stream-controls">
                        <button id="btn-iframe" onclick="switchStream('iframe')">Kaynak 1 (Web)</button>
                        <button id="btn-m3u8" onclick="switchStream('m3u8')">Kaynak 2 (HD)</button>
                    </div>
                </div>
            </div>
            <div class="widget-card">
                 <a href="https://voetbaluitslagen.be/" data-type="next-match" data-name="super-lig" data-lang="tr" data-style="dark">Voetbaluitslagen</a>
            </div>
        </main>
        
        <aside class="sidebar">
            <h3>📺 Kanal Listesi</h3>
            <div id="channel-list"></div>
        </aside>

        <footer class="footer">
             <a href="https://tr.link/ref/220823" target="_blank">
                <img src="//tr.link/webroot/img/ref/250x250.jpg" title="Para Kazanmak İçin Tıkla Kayıt OL" />
            </a>
        </footer>
    </div>

<script>
    // --- JAVASCRIPT BÖLÜMÜ ---
    // Kodun işlevselliği değişmediği için bu alanda herhangi bir değişiklik yapılmamıştır.
    // Tüm fonksiyonlar yeni tasarımla %100 uyumlu çalışmaktadır.

    const channels = [
        { name: 'Bein Sports 1', iframeUrl: 'https://main.uxsyplayer033b6adff1.click/index.php?id=selcuktivibuspor1#poster=https%3A%2F%2Fblogger.googleusercontent.com%2Fimg%2Fb%2FR29vZ2xl%2FAVvXsEj8CEtL3mwmCMomVlu7nEuxd4mSjxav1nUQXt8gfLyFFho-ZsnqKx9gF8-rtf9r1lXctp0vUESwjR9BwBAhfKUl0QNN3Ip3FRUP6oarn2eP64MW_NcF1_vsPWqkYFpTu6TeQHw8dglnEOXbIYurZKZuY8dTwDFkik707MOKVTdhooPYDzPpvkGbCjeRJjO4%2Fs16000%2Fcrtswp-s-min.png&reklamResim=https%3A%2F%2Fblogger.googleusercontent.com%2Fimg%2Fb%2FR29vZ2xl%2FAVvXsEh4aAioTaLgNi0hZqjfBTrtvMpGgO9lKvPL9nzWbPkwKQBj8J5TH5BzFPwD22XroM9AmJwWmZ_MvOV2MfGF5nZ7TvmydGBlhZ6UjU64syprVpNX8o13C0ZrdmsleP6oIgWTvJZW6mhhRPo_sH_K4Gn9gkoIKyxTg_iV3H22PmY3ZAc1D5JCql46yzfDftp7%2Fs16000%2Fpshg-min-min.gif&reklamGidis=https%3A%2F%2Fcutt.ly%2Fselcuksportspsh', m3u8Url: 'https://one.6c53c716e5c951f6.click/live/selcukbeinsports1/playlist.m3u8', active: true },
        { name: 'Bein Sports 2', iframeUrl: 'https://tinyurl.com/235j9fjm', m3u8Url: 'https://alpha.cf-worker-5867c71e49ce10.workers.dev/live/selcukbeinsports3/playlist.m3u8', active: true },
        { name: 'TRT Spor', iframeUrl: 'https://www.trtizle.com/canli/tv/trt-spor', m3u8Url: 'https://tv-trttv.medya.trt.com.tr/master_720.m3u8', active: true },
        { name: 'Bozuk Link (Test)', iframeUrl: 'about:blank', m3u8Url: 'https://example.com/not-a-real-stream.m3u8', active: true },
        { name: 'Süper Lig Özel (Yakında)', iframeUrl: 'about:blank', m3u8Url: '', active: false },
    ];
    let currentChannelIndex = 0;
    let streamType = 'iframe';
    let hlsInstance = null;
    const videoEl = document.getElementById('video-stream');
    const iframeEl = document.getElementById('iframe-stream');
    const channelListEl = document.getElementById('channel-list');
    const matchTitleEl = document.getElementById('match-title');
    const playerOverlay = document.getElementById('player-overlay');
    const errorMessageEl = document.getElementById('error-message');
    function renderChannelList() {
        channelListEl.innerHTML = '';
        channels.forEach((channel, index) => {
            const channelDiv = document.createElement('div');
            channelDiv.className = 'channel';
            channelDiv.textContent = channel.name;
            if (channel.active) { channelDiv.onclick = () => selectChannel(index); }
            else { channelDiv.classList.add('inactive'); }
            channelListEl.appendChild(channelDiv);
        });
    }
    function selectChannel(index) { currentChannelIndex = index; loadMedia(); }
    function switchStream(type) {
        streamType = type;
        localStorage.setItem('preferredStreamType', type);
        loadMedia();
    }
    function loadMedia() {
        if (hlsInstance) { hlsInstance.destroy(); }
        videoEl.style.display = 'none';
        iframeEl.style.display = 'none';
        playerOverlay.className = 'visible is-loading';
        errorMessageEl.textContent = '';
        const channel = channels[currentChannelIndex];
        if (streamType === 'iframe') {
            iframeEl.style.display = 'block';
            iframeEl.src = channel.iframeUrl;
            iframeEl.onload = () => { playerOverlay.className = ''; };
            iframeEl.onerror = () => {
                playerOverlay.className = 'visible has-error';
                errorMessageEl.textContent = 'Kaynak yüklenemedi. Lütfen başka bir kaynak veya kanal deneyin.';
            };
        } else {
            videoEl.style.display = 'block';
            if (Hls.isSupported() && channel.m3u8Url) {
                hlsInstance = new Hls();
                hlsInstance.loadSource(channel.m3u8Url);
                hlsInstance.attachMedia(videoEl);
                hlsInstance.on(Hls.Events.MANIFEST_PARSED, () => {
                    playerOverlay.className = '';
                    videoEl.play();
                });
                hlsInstance.on(Hls.Events.ERROR, (event, data) => {
                    if (data.fatal) {
                        playerOverlay.className = 'visible has-error';
                        errorMessageEl.textContent = 'Yayın Yüklenemedi (Hata: ' + data.type + '). Başka bir kaynak deneyin.';
                    }
                });
            } else if (!channel.m3u8Url) {
                playerOverlay.className = 'visible has-error';
                errorMessageEl.textContent = 'Bu kanal için HD kaynak (M3U8) bulunmuyor.';
            }
        }
        updateUI();
    }
    function updateUI() {
        const channel = channels[currentChannelIndex];
        matchTitleEl.textContent = channel.name;
        document.getElementById('btn-iframe').classList.toggle('active', streamType === 'iframe');
        document.getElementById('btn-m3u8').classList.toggle('active', streamType === 'm3u8');
        document.querySelectorAll('.channel').forEach((el, index) => {
            el.classList.toggle('active', index === currentChannelIndex);
        });
    }
    document.addEventListener('DOMContentLoaded', () => {
        const savedType = localStorage.getItem('preferredStreamType');
        if (savedType) { streamType = savedType; }
        renderChannelList();
        const firstActiveIndex = channels.findIndex(c => c.active);
        if (firstActiveIndex !== -1) { selectChannel(firstActiveIndex); }
        else {
            matchTitleEl.textContent = "Aktif yayın bulunamadı.";
            playerOverlay.className = 'visible has-error';
            errorMessageEl.textContent = 'Gösterilecek aktif kanal yok.';
        }
    });
</script>

</body>
</html>
