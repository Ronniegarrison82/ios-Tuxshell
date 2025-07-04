const terminalContainer = document.getElementById('terminal-container');
const editorContainer = document.getElementById('editor-container');
const runBtn = document.getElementById('run-script');
const saveScriptBtn = document.getElementById('save-script');
const saveLogBtn = document.getElementById('save-log');

let term;
let editor;
let logBuffer = '';

function createControlButtons() {
const container = document.createElement('div');
container.style.position = 'fixed';
container.style.bottom = '10px';
container.style.right = '10px';
container.style.display = 'flex';
container.style.gap = '6px';
container.style.zIndex = '1000';

// Common button style
const btnStyle = `
background: rgba(0, 255, 0, 0.1);
border: 1px solid #0f0;
border-radius: 4px;
color: #0f0;
font-size: 12px;
padding: 6px 10px;
cursor: pointer;
user-select: none;
opacity: 0.6;
transition: opacity 0.3s ease;
`;

function createButton(text, title, onClick) {
const btn = document.createElement('button');
btn.textContent = text;
btn.title = title;
btn.style.cssText = btnStyle;
btn.onmouseenter = () => btn.style.opacity = '1';
btn.onmouseleave = () => btn.style.opacity = '0.6';
btn.onclick = onClick;
return btn;
}

// Copy terminal text
const copyBtn = createButton('Copy', 'Copy Terminal Text', () => {
navigator.clipboard.writeText(term.element.textContent || '').then(() => {
term.writeln('\n[✓] Terminal content copied to clipboard');
term.prompt();
});
});

// Paste clipboard text into terminal input
const pasteBtn = createButton('Paste', 'Paste from Clipboard', async () => {
try {
const text = await navigator.clipboard.readText();
if (text) {
for (const ch of text) {
term.write(ch);
command += ch;
}
}
} catch {
term.writeln('\n[!] Clipboard paste not supported');
term.prompt();
}
});

// Clear terminal
const clearBtn = createButton('Clear', 'Clear Terminal', () => {
term.clear();
command = '';
term.prompt();
});

// History Up button (for touch)
const upBtn = createButton('Up', 'Previous Command', () => {
if (history.length && historyIndex > 0) {
clearCommandLine();
historyIndex--;
command = history[historyIndex];
term.write(command);
}
});

// History Down button (for touch)
const downBtn = createButton('Down', 'Next Command', () => {
if (history.length && historyIndex < history.length - 1) {
clearCommandLine();
historyIndex++;
command = history[historyIndex];
term.write(command);
} else if (historyIndex === history.length - 1) {
clearCommandLine();
historyIndex = history.length;
command = '';
}
});

container.appendChild(copyBtn);
container.appendChild(pasteBtn);
container.appendChild(clearBtn);
container.appendChild(upBtn);
container.appendChild(downBtn);

document.body.appendChild(container);
}

let command = '';
const history = [];
let historyIndex = -1;

function clearCommandLine() {
while (command.length > 0) {
term.write('\b \b');
command = command.slice(0, -1);
}
}

function initTerminal() {
term = new Terminal({
cursorBlink: true,
theme: { background: '#000', foreground: '#0f0' },
});
term.open(terminalContainer);
term.writeln('AI Environment Terminal Console');
term.prompt = () => {
term.write('\r\n$ ');
};
term.prompt();

term.onKey(e => {
const ev = e.domEvent;
const printable = !ev.altKey && !ev.ctrlKey && !ev.metaKey;

if (ev.keyCode === 13) { // Enter
if (command.trim()) {
history.push(command);
historyIndex = history.length;
runCommand(command);
}
command = '';
} else if (ev.keyCode === 8) { // Backspace
if (command.length > 0) {
command = command.slice(0, -1);
term.write('\b \b');
}
} else if (ev.keyCode === 38) { // Up Arrow
if (history.length && historyIndex > 0) {
clearCommandLine();
historyIndex--;
command = history[historyIndex];
term.write(command);
}
} else if (ev.keyCode === 40) { // Down Arrow
if (history.length && historyIndex < history.length - 1) {
clearCommandLine();
historyIndex++;
command = history[historyIndex];
term.write(command);
} else if (historyIndex === history.length - 1) {
clearCommandLine();
historyIndex = history.length;
command = '';
}
} else if (printable) {
command += e.key;
term.write(e.key);
}
});

createControlButtons();
}

function runCommand(cmd) {
const trimmed = cmd.trim();
if (!trimmed) {
term.prompt();
return;
}

if (trimmed === 'clear') {
term.clear();
term.prompt();
return;
}

term.writeln('');
term.writeln(`Running: ${trimmed}`);

fakeBackendExecute(trimmed)
.then(output => {
term.writeln(output);
logBuffer += `$ ${trimmed}\n${output}\n`;
term.prompt();
term.scrollToBottom();
})
.catch(err => {
term.writeln(`Error: ${err}`);
term.prompt();
});
}

function fakeBackendExecute(cmd) {
return new Promise(resolve => {
setTimeout(() => {
resolve(`Output for command: "${cmd}" (Simulated)`);
}, 1000);
});
}

window.onload = () => {
initTerminal();
};
