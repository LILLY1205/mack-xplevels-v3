let leaderboardData = [];
let currentCitizenId = null;
let filteredStats = [];
let displayedCount = 5;

const MAX_XP = 100000;

// ===== Helpers =====

function getBarClass(percentage) {
    if (percentage >= 75) return 'green';
    if (percentage >= 25) return 'yellow';
    return 'red';
}

function getLevelImage(xp) {
    if (xp <= 1000) return 'xp1000.png';
    else if (xp <= 2000) return 'xp2000.png';
    else if (xp <= 3000) return 'xp3000.png';
    else if (xp <= 4000) return 'xp4000.png';
    else if (xp <= 5000) return 'xp5000.png';
    else if (xp <= 6000) return 'xp6000.png';
    else if (xp <= 7000) return 'xp7000.png';
    else if (xp <= 8000) return 'xp8000.png';
    else if (xp <= 9000) return 'xp9000.png';
    else return 'xp10000.png';
}

function createXPBar(xp) {
    const percentage = Math.min(Math.max((xp / MAX_XP) * 100, 0), 100);
    return `
        <div class="xp-bar-container">
            <div class="xp-bar">
                <div class="xp-bar-fill ${getBarClass(percentage)}" style="width: ${percentage}%"></div>
            </div>
        </div>
    `;
}

// ===== Show / Hide (clipboard animation) =====

function showApp() {
    document.getElementById('app').classList.add('visible');
}

function hideApp() {
    document.getElementById('app').classList.remove('visible');
}

function closeUI() {
    hideApp();
    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).catch(function (err) {
        console.error('closeUI error:', err);
    });
}

// ===== Render Top Players =====

function renderRankedList() {
    const container = document.getElementById('rankedList');
    if (!container) return;
    container.innerHTML = '';

    if (!leaderboardData || leaderboardData.length === 0) {
        container.innerHTML = '<div class="empty-state">No players available.</div>';
        return;
    }

    var topPlayers = leaderboardData.slice(0, 5);
    topPlayers.forEach(function (stat) {
        if (!stat.rank || !stat.name) return;

        var isMe = stat.citizenid === currentCitizenId;
        var item = document.createElement('div');
        item.className = 'ranked-item' + (isMe ? ' current-player' : '');
        item.innerHTML =
            '<div class="rank-number">#' + stat.rank + '</div>' +
            '<img src="' + getLevelImage(stat.xp) + '" alt="Level" class="level-badge" onerror="this.src=\'fallback.png\'">' +
            '<div class="ranked-info">' +
                '<div class="ranked-name">' + stat.name + '</div>' +
                '<div class="ranked-xp">' + stat.xp.toLocaleString() + ' XP</div>' +
                createXPBar(stat.xp) +
            '</div>';
        container.appendChild(item);
    });
}

// ===== Render Player Stats =====

function renderStats() {
    var container = document.getElementById('statsList');
    if (!container) return;
    container.innerHTML = '';

    if (!filteredStats || filteredStats.length === 0) {
        container.innerHTML = '<div class="empty-state">No player stats available.</div>';
        return;
    }

    var statsToDisplay = filteredStats.slice(0, displayedCount);
    statsToDisplay.forEach(function (stat) {
        if (!stat.citizenid || !stat.name) return;

        var isMe = stat.citizenid === currentCitizenId;
        var item = document.createElement('div');
        item.className = 'stat-item' + (isMe ? ' current-player' : '');
        item.innerHTML =
            '<div class="stat-header">' +
                '<img src="' + getLevelImage(stat.xp || 0) + '" alt="Level" class="level-badge" onerror="this.src=\'fallback.png\'">' +
                '<div>' +
                    '<div class="stat-name">' + stat.name + '</div>' +
                    '<div class="stat-xp-text">' + (stat.xp || 0).toLocaleString() + ' XP</div>' +
                '</div>' +
            '</div>' +
            createXPBar(stat.xp || 0);
        container.appendChild(item);
    });

    var loadMoreBtn = document.getElementById('loadMoreButton');
    if (loadMoreBtn) {
        loadMoreBtn.disabled = displayedCount >= filteredStats.length;
    }
}

// ===== Search =====

function filterStats(searchTerm) {
    if (!searchTerm) {
        filteredStats = leaderboardData;
    } else {
        filteredStats = leaderboardData.filter(function (stat) {
            return stat.name.toLowerCase().includes(searchTerm.toLowerCase());
        });
    }
    displayedCount = 5;
    renderStats();
}

// ===== NUI Message Handler =====

window.addEventListener('message', function (event) {
    var data = event.data;

    if (data.action === 'openLeaderboardUI') {
        leaderboardData = data.leaderboardData || [];
        filteredStats = leaderboardData;
        displayedCount = 5;
        currentCitizenId = data.currentCitizenId || null;

        renderRankedList();
        renderStats();
        showApp();
    } else if (data.action === 'closeUI') {
        closeUI();
    }
});

// ===== Tabs =====

function switchTab(tabName) {
    var buttons = document.querySelectorAll('.tab-btn');
    var contents = document.querySelectorAll('.tab-content');

    buttons.forEach(function (btn) {
        btn.classList.toggle('active', btn.getAttribute('data-tab') === tabName);
    });

    contents.forEach(function (content) {
        content.classList.toggle('active', content.id === 'tab-' + tabName);
    });
}

// ===== DOM Events =====

document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('close-btn').addEventListener('click', closeUI);

    // Tab buttons
    document.querySelectorAll('.tab-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            switchTab(btn.getAttribute('data-tab'));
        });
    });

    var searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', function (e) {
            filterStats(e.target.value);
        });
    }

    var loadMoreBtn = document.getElementById('loadMoreButton');
    if (loadMoreBtn) {
        loadMoreBtn.addEventListener('click', function () {
            displayedCount += 5;
            renderStats();
        });
    }
});

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        closeUI();
    }
});

// ===== Preload level images =====
[
    'xp1000.png', 'xp2000.png', 'xp3000.png', 'xp4000.png', 'xp5000.png',
    'xp6000.png', 'xp7000.png', 'xp8000.png', 'xp9000.png', 'xp10000.png'
].forEach(function (url) {
    var img = new Image();
    img.src = url;
});
