#!/usr/bin/env python3
import sys
import os
import json
import requests
import platform
import subprocess

# Speicherort der Konfigurationsdatei
CONFIG_PATH = os.path.join(os.path.dirname(sys.executable if getattr(sys, 'frozen', False) else __file__), 'config.json')

# Sprachdefinitionen
LANG = {
    "de": {
        "success": "✅ Upload erfolgreich!",
        "error": "❌ Upload fehlgeschlagen:",
        "http": "HTTP",
        "upload_exception": "⚠️ Fehler beim Upload:",
        "nofile": "⚠️ Es wurde keine Datei übergeben.",
        "setup_hint": "✅ Einrichtung abgeschlossen!\n\nBitte die App ins Dock ziehen und zukünftig PDFs einfach auf das Symbol ziehen.",
        "title": "Paperless Upload"
    },
    "en": {
        "success": "✅ Upload successful!",
        "error": "❌ Upload failed:",
        "http": "HTTP",
        "upload_exception": "⚠️ Error during upload:",
        "nofile": "⚠️ No file provided.",
        "setup_hint": "✅ Setup complete!\n\nPlease add the app to your Dock and drop PDFs onto the icon in the future.",
        "title": "Paperless Upload"
    }
}

# Dialoganzeige
def show_message(text, title="Paperless Upload", icon=0):
    system = platform.system()
    if system == "Darwin":
        # AppleScript-sicherer Text (Anführungszeichen escapen)
        safe_text = text.replace('"', '\\"')
        safe_title = title.replace('"', '\\"')
        script = f'display dialog "{safe_text}" with title "{safe_title}" buttons ["OK"] default button 1'
        subprocess.run(["osascript", "-e", script])
    elif system == "Windows":
        import ctypes
        ctypes.windll.user32.MessageBoxW(0, text, title, icon)
    else:
        print(f"[{title}] {text}")

# Texteingabe mit Dialog
def prompt_input(prompt, default=""):
    script = f'display dialog "{prompt}" default answer "{default}" with title "Paperless Upload"'
    result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
    if result.returncode != 0 or "text returned:" not in result.stdout:
        raise Exception("Benutzereingabe abgebrochen oder ungültig.")
    try:
        return result.stdout.split("text returned:")[1].strip().strip('"')
    except IndexError:
        raise Exception("Keine Eingabe erhalten.")

# Sprachauswahl
def prompt_language():
    script = '''
        display dialog "Sprache wählen / Select language:" buttons {"Deutsch", "English"} default button 2
        set choice to button returned of result
        if choice is "Deutsch" then
            return "de"
        else
            return "en"
        end if
    '''
    result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
    return result.stdout.strip()

# Konfiguration erzeugen
def create_config_interactively():
    lang_code = prompt_language()
    server = ""
    while not server:
        server = prompt_input("Paperless-Server-URL (z. B. https://docs.example.com):")
    api_key = ""
    while not api_key:
        api_key = prompt_input("API Key eingeben (ohne 'Token '):")

    config = {
        "language": lang_code,
        "server": server.strip(),
        "api_key": api_key.strip()
    }

    with open(CONFIG_PATH, 'w', encoding='utf-8') as f:
        json.dump(config, f, indent=4)

    return config

# Konfiguration laden
def load_config():
    if not os.path.exists(CONFIG_PATH):
        return create_config_interactively()
    with open(CONFIG_PATH, 'r', encoding='utf-8') as f:
        return json.load(f)

# Datei hochladen
def upload_file(file_path):
    config = load_config()
    lang_code = config.get("language", "en")
    text = LANG.get(lang_code, LANG["en"])

    api_key = config.get("api_key", "")
    if not api_key.startswith("Token "):
        api_key = "Token " + api_key

    url = config["server"].rstrip("/") + "/api/documents/post_document/"
    headers = {"Authorization": api_key}
    files = {"document": open(file_path, "rb")}

    try:
        response = requests.post(url, headers=headers, files=files)
        if response.status_code in (200, 201):
            try:
                data = response.json()
                msg = f"{text['success']}\nID: {data.get('id', '–')}"
            except Exception:
                msg = text['success']
            show_message(msg, title=text["title"])
        else:
            show_message(f"{text['error']}\n{text['http']} {response.status_code}\n{response.text}", title=text["title"])
    except Exception as e:
        show_message(f"{text['upload_exception']}\n{str(e)}", title=text["title"])

# Hauptprogramm
if __name__ == "__main__":
    try:
        if len(sys.argv) < 2:
            config = load_config()
            lang_code = config.get("language", "en")
            text = LANG.get(lang_code, LANG["en"])
            show_message(text["setup_hint"], title=text["title"])
        else:
            upload_file(sys.argv[1])
    except Exception as e:
        show_message(f"❌ {str(e)}", title="Paperless Upload")
