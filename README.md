# PaperlessUploader_by_Walfrosch92
Upload Documents to your selfhosted Paperless within Windows

# 📄 Paperless Uploader für Windows

Ein leichtgewichtiges Tool, mit dem sich beliebige Dateien direkt über das **Windows-Kontextmenü** an eine [Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx)-Instanz hochladen lassen – ganz ohne zusätzliches Python oder Terminal-Kenntnisse.

---

## ✨ Funktionen

- 📎 Hochladen beliebiger Dateien per Rechtsklick
- 🖱 Kontextmenü-Integration (Windows Explorer, „Erweiterte Optionen“)
- 🧩 Konfiguration bei der Installation (URL, API-Key, Sprache)
- 🌐 Mehrsprachig (Deutsch und Englisch)
- 🪟 Kein Python erforderlich – läuft als eigenständige `.exe`
- 🧹 Sauberer Uninstaller entfernt Programmdateien und Registry-Einträge

---

## 🖥️ Systemvoraussetzungen

- Windows 10 oder 11 (64-bit)
- Bestehende Paperless-ngx-Instanz (getestet mit v2.17.1+)
- Gültiger API-Key mit Upload-Berechtigung

---

## 🔧 Installation

1. Lade die aktuelle `Setup.exe` unter [Releases](./releases) herunter.
2. Führe das Setup aus und gib folgende Daten ein:
   - Die URL deiner Paperless-Instanz
   - Deinen API-Key (Token)
   - Bevorzugte Sprache (Deutsch oder Englisch)
3. Nach Abschluss findest du den neuen Eintrag im **erweiterten Kontextmenü** von Windows.

---

## 🖱 Verwendung

Nach erfolgreicher Installation:

- Klicke mit der **rechten Maustaste** auf eine Datei
- Wähle **„Weitere Optionen anzeigen“** (Windows 11) oder **Umschalt + Rechtsklick**
- Wähle den Eintrag **„Zu Paperless hochladen“** (bzw. „Upload to Paperless“ bei englischer Sprache)

Ein Dialogfenster informiert dich über den Uploadstatus.

---

