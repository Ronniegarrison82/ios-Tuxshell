(() => {
const logContainer = document.getElementById('log-container');
const filterInput = document.getElementById('log-filter');
const downloadBtn = document.getElementById('download-logs');
const clearBtn = document.getElementById('clear-logs');

let logs = [];

async function fetchLogs() {
try {
const res = await fetch('/api/logs');
if (!res.ok) throw new Error(`HTTP ${res.status}`);
logs = await res.json();
renderLogs(logs);
} catch (err) {
logContainer.textContent = `Failed to fetch logs: ${err.message}`;
}
}

function renderLogs(logsToRender) {
if (!logsToRender.length) {
logContainer.innerHTML = '<p>No logs available.</p>';
return;
}

const tableRows = logsToRender.map(log => `
<tr>
<td>${escapeHtml(log.timestamp)}</td>
<td>${escapeHtml(log.level)}</td>
<td>${escapeHtml(log.message)}</td>
</tr>
`).join('');

logContainer.innerHTML = `
<table>
<thead>
<tr>
<th>Timestamp</th>
<th>Level</th>
<th>Message</th>
</tr>
</thead>
<tbody>${tableRows}</tbody>
</table>
`;
}

function escapeHtml(text) {
return text.replace(/[&<>"']/g, m => ({
'&': '&amp;',
'<': '&lt;',
'>': '&gt;',
'"': '&quot;',
"'": '&#39;'
})[m]);
}

function filterLogs() {
const filterText = filterInput.value.toLowerCase();
if (!filterText) {
renderLogs(logs);
return;
}
const filtered = logs.filter(log =>
log.timestamp.toLowerCase().includes(filterText) ||
log.level.toLowerCase().includes(filterText) ||
log.message.toLowerCase().includes(filterText)
);
renderLogs(filtered);
}

async function downloadLogs() {
if (!logs.length) return alert('No logs to download.');

const content = logs.map(log => `[${log.timestamp}] [${log.level}] ${log.message}`).join('\n');
const blob = new Blob([content], { type: 'text/plain' });
const a = document.createElement('a');
a.href = URL.createObjectURL(blob);
a.download = `logs_${new Date().toISOString()}.txt`;
a.click();
}

async function clearLogs() {
if (!confirm('Are you sure you want to clear all logs?')) return;
try {
const res = await fetch('/api/logs/clear', { method: 'POST' });
if (!res.ok) throw new Error(`HTTP ${res.status}`);
logs = [];
renderLogs(logs);
alert('Logs cleared.');
} catch (err) {
alert(`Failed to clear logs: ${err.message}`);
}
}

// Event listeners
filterInput.addEventListener('input', filterLogs);
downloadBtn.addEventListener('click', downloadLogs);
clearBtn.addEventListener('click', clearLogs);

// Initial fetch on load
fetchLogs();
})();
