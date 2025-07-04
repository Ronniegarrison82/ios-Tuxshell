const terminalContainer = document.getElementById('terminal-container');
const editorContainer = document.getElementById('editor-container');
const runBtn = document.getElementById('run-script');
const saveScriptBtn = document.getElementById('save-script');
const saveLogBtn = document.getElementById('save-log');

let term;
let editor;
let logBuffer = '';

// Initialize xterm.js Terminal with history and input handling
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

let command = '';
const history = [];
let historyIndex = -1;

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
while (command.length > 0) {
term.write('\b \b');
command = command.slice(0, -1);
}
historyIndex--;
command = history[historyIndex];
term.write(command);
}
} else if (ev.keyCode === 40) { // Down Arrow
if (history.length && historyIndex < history.length - 1) {
while (command.length > 0) {
term.write('\b \b');
command = command.slice(0, -1);
}
historyIndex++;
command = history[historyIndex];
term.write(command);
} else if (historyIndex === history.length - 1) {
while (command.length > 0) {
term.write('\b \b');
command = command.slice(0, -1);
}
historyIndex = history.length;
command = '';
}
} else if (printable) {
command += e.key;
term.write(e.key);
}
});
}

// Run command logic with support for 'clear' command and simulated output
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

// Simulate backend command execution (replace later with real backend/API)
function fakeBackendExecute(cmd) {
return new Promise(resolve => {
setTimeout(() => {
resolve(`Output for command: "${cmd}" (Simulated)`);
}, 1000);
});
}

// Initialization on window load (add your editor and buttons init here as well)
window.onload = () => {
initTerminal();
// Initialize editor, buttons, etc.
};
