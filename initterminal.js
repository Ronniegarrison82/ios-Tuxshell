const terminalContainer = document.getElementById('terminal-container');
const editorContainer = document.getElementById('editor-container');
const runBtn = document.getElementById('run-script');
const saveScriptBtn = document.getElementById('save-script');
const saveLogBtn = document.getElementById('save-log');

let term;
let editor;
let logBuffer = '';
const history = [];
let historyIndex = -1;
let command = '';

// Initialize xterm.js Terminal with input + history
function initTerminal() {
if (!terminalContainer) {
console.error('[!] Terminal container not found');
return;
}

term = new Terminal({
cursorBlink: true,
theme: {
background: '#000',
foreground: '#0f0',
},
});

term.open(terminalContainer);
term.writeln('AI Environment Terminal Console');
prompt();

term.onKey(handleKey);
}

// Handle keyboard input for the terminal
function handleKey(e) {
const ev = e.domEvent;
const printable = !ev.altKey && !ev.ctrlKey && !ev.metaKey;

switch (ev.keyCode) {
case 13: // Enter
if (command.trim()) {
history.push(command);
historyIndex = history.length;
runCommand(command);
}
command = '';
break;

case 8: // Backspace
if (command.length > 0) {
command = command.slice(0, -1);
term.write('\b \b');
}
break;

case 38: // Up arrow
if (history.length && historyIndex > 0) {
clearCommandLine();
historyIndex--;
command = history[historyIndex];
term.write(command);
}
break;

case 40: // Down arrow
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
break;

default:
if (printable) {
command += e.key;
term.write(e.key);
}
break;
}
}

// Clear the current line in the terminal
function clearCommandLine() {
while (command.length > 0) {
term.write('\b \b');
command = command.slice(0, -1);
}
}

// Run command by calling backend API
async function runCommand(cmd) {
const trimmed = cmd.trim();
term.writeln(`\nRunning: ${trimmed}`);

if (trimmed === 'clear') {
term.clear();
prompt();
return;
}

try {
const res = await fetch('/run', {
method: 'POST',
headers: {'Content-Type': 'application/json'},
body: JSON.stringify({command: trimmed}),
});
const data = await res.json();
if (data.output) {
term.writeln(data.output);
logBuffer += `$ ${trimmed}\n${data.output}\n`;
} else if (data.error) {
term.writeln(`Error: ${data.error}`);
} else {
term.writeln('Unknown error');
}
} catch (err) {
term.writeln(`Fetch error: ${err.message}`);
}

prompt();
term.scrollToBottom();
}

// Prompt symbol
function prompt() {
term.write('\r\n$ ');
term.scrollToBottom();
}

// Initialize terminal on window load
window.onload = () => {
initTerminal();
// Initialize editor, buttons, etc.
};
