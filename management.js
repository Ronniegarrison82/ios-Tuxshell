// management.js — Simulated Disk Usage Tracker for TuxShell Web UI

const DISK_TOTAL_MB = 102400; // 100GB quota

function getUsedDisk() {
return parseInt(localStorage.getItem("disk-used") || "0", 10);
}

function setUsedDisk(value) {
const clamped = Math.min(Math.max(0, value), DISK_TOTAL_MB);
localStorage.setItem("disk-used", clamped.toString());
return clamped;
}

function getFreeDisk() {
return DISK_TOTAL_MB - getUsedDisk();
}

function updateDiskInfo() {
const usedMB = getUsedDisk();
const freeMB = getFreeDisk();
const usedGB = (usedMB / 1024).toFixed(2);
const freeGB = (freeMB / 1024).toFixed(2);

const el = document.getElementById("disk-space");
if (el) {
el.textContent = `Disk: ${usedGB} GB used / ${freeGB} GB free`;
}
}

function simulateSaveFile(sizeMB = 50) {
const current = getUsedDisk();
if (current + sizeMB > DISK_TOTAL_MB) {
updateSyncStatus?.("⚠️ Disk full! Cannot save file.");
return false;
}
setUsedDisk(current + sizeMB);
updateDiskInfo();
return true;
}

function resetDiskUsage() {
setUsedDisk(0);
updateDiskInfo();
updateSyncStatus?.("Disk usage reset.");
}

document.addEventListener("DOMContentLoaded", () => {
updateDiskInfo();

const saveBtn = document.getElementById("save-file");
if (saveBtn) {
saveBtn.addEventListener("click", () => {
const success = simulateSaveFile();
if (success) updateSyncStatus?.("File saved.");
});
}

// Dev shortcut: Shift+D to reset disk
window.addEventListener("keydown", (e) => {
if (e.shiftKey && e.code === "KeyD") {
resetDiskUsage();
}
});
});
