function saveToFile() {
const content = window.editor.getValue();
const blob = new Blob([content], { type: 'text/plain' });
const a = document.createElement('a');
a.href = URL.createObjectURL(blob);
a.download = 'script.js';
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
window.editor.setValue(event.target.result);
};
reader.readAsText(file);
};
input.click();
}
