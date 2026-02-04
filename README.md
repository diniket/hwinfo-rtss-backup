# HWiNFO + RTSS Backup/Restore

Script PowerShell + launcher BAT per salvare e ripristinare automaticamente le impostazioni di **HWiNFO** e **RivaTuner Statistics Server (RTSS)**.

PowerShell script + BAT launcher to automatically back up and restore **HWiNFO** and **RivaTuner Statistics Server (RTSS)** settings.

---

## 🇮🇹 Italiano

### 🔧 Cosa fa
Questo tool permette di:
- Salvare le impostazioni di HWiNFO (registro utente HKCU)
- Salvare i file di configurazione di RTSS (Profiles, ProfileTemplates, RTSS.cfg)
- Creare un file ZIP di backup
- Ripristinare tutto su un altro PC con un solo click

Perfetto dopo:
- Reinstallazione di Windows  
- Cambio PC  
- Formattazione  
- Migrazione setup

---

### ▶️ Come si usa

1. Metti **backup_overlay.bat** e **backup_overlay.ps1** nella stessa cartella  
2. Doppio click su **backup_overlay.bat**
3. Scegli:
   - **1 = Backup** → crea ZIP con le impostazioni
   - **2 = Restore** → ripristina da ZIP

⚠️ Durante il ripristino servono i permessi di amministratore (il .bat li richiede automaticamente).

---

### 📦 Cosa viene salvato

| Software | Cosa viene salvato |
|----------|--------------------|
| HWiNFO | Impostazioni utente (registro HKCU) |
| RTSS | Profili, template e file di configurazione |

---

### 🔒 Privacy
Questo script **non invia dati online**.  
Salva solo file e impostazioni locali sul tuo PC.

---

## 🇬🇧 English

### 🔧 What it does
This tool allows you to:
- Back up HWiNFO user settings (HKCU registry)
- Back up RTSS configuration files (Profiles, ProfileTemplates, RTSS.cfg)
- Create a ZIP backup file
- Restore everything on another PC with one click

Perfect after:
- Windows reinstall  
- PC upgrade  
- System format  
- Setup migration

---

### ▶️ How to use

1. Place **backup_overlay.bat** and **backup_overlay.ps1** in the same folder  
2. Double-click **backup_overlay.bat**
3. Choose:
   - **1 = Backup** → creates ZIP with your settings
   - **2 = Restore** → restores from ZIP

⚠️ Restore requires administrator rights (the .bat will request them automatically).

---

### 📦 What gets backed up

| Software | What is saved |
|----------|---------------|
| HWiNFO | User settings (HKCU registry) |
| RTSS | Profiles, templates and configuration files |

---

### 🔒 Privacy
This script **does not send any data online**.  
It only saves local files and settings on your PC.

---

## 🧠 Notes
- Works with any GPU brand (NVIDIA / AMD / Intel)
- If some sensors differ between PCs, a few overlay items may need to be re-enabled manually

---

## 📜 License
MIT License
