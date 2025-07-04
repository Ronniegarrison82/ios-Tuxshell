function saveToFile() {
const content = window.editor.getValue?.() || '';
const blob = new Blob([content], { type: 'text/plain' });
const a = document.createElement('a');
a.href = URL.createObjectURL(blob);
a.download = prompt("Save as filename:", "script.js") || "script.js";
a.click();
}

function loadFromFile() {
const input = document.createElement('input');
input.type = 'file';
input.accept = '.js,.sh,.txt,.html,.py';
input.onchange = e => {
const file = e.target.files[0];
if (!file) return;
const reader = new FileReader();
reader.onload = event => {
if (window.editor?.setValue) {
window.editor.setValue(event.target.result);
} else {
console.warn("Editor not initialized.");
}
};
reader.readAsText(file);
};
input.click();
}
