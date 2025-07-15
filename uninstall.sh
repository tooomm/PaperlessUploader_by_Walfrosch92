#!/bin/bash

APP_DIR="/Applications/PaperlessUploader"
SUPPORT_DIR="$HOME/Library/Application Support/PaperlessUploader"

echo "🗑 Starte Deinstallation..."

# App beenden, falls sie läuft
APP_NAME="PaperlessUploader"
pgrep -x "$APP_NAME" >/dev/null && killall "$APP_NAME"

# Warte kurz, um sicherzugehen
sleep 1

# Konfigurationsdaten löschen
if [ -d "$SUPPORT_DIR" ]; then
    echo "➖ Entferne Konfigurationsdateien: $SUPPORT_DIR"
    rm -rf "$SUPPORT_DIR"
fi

# App-Ordner löschen (inkl. PaperlessUploader.app und Uninstaller)
if [ -d "$APP_DIR" ]; then
    echo "➖ Entferne App-Ordner: $APP_DIR"
    rm -rf "$APP_DIR"
fi

# Meldung zum Abschluss
osascript -e 'display dialog "✅ PaperlessUploader wurde vollständig entfernt." with title "Deinstallation abgeschlossen" buttons {"OK"} default button 1'

exit 0
