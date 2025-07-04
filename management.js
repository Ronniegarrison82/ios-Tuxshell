// disk-manager.js

const DISK_TOTAL_MB = 102400;

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
if (el) el.textContent = `Disk: ${usedGB}GB used / ${freeGB}GB free`;
}

function simulateSaveFile() {
setUsedDisk(getUsedDisk() + 50);
updateDiskInfo();
}

function resetDiskUsage() {
setUsedDisk(0);
updateDiskInfo();
}

document.addEventListener("DOMContentLoaded", () => {
updateDiskInfo();

const saveBtn = document.getElementById("save-file");
if (saveBtn) {
saveBtn.addEventListener("click", () => {
simulateSaveFile();
updateSyncStatus?.("File saved.");
});
}

window.addEventListener("keydown", (e) => {
if (e.shiftKey && e.code === "KeyD") {
resetDiskUsage();
updateSyncStatus?.("Disk usage reset.");
}
});
});
