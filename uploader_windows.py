import sys
import os
import requests
import json
import ctypes

# Sprachdefinition
LANG = {
    "de": {
        "success": "✅ Upload erfolgreich!",
        "error": "❌ Upload fehlgeschlagen:",
        "http": "HTTP",
        "upload_exception": "⚠️ Fehler beim Upload:",
        "nofile": "⚠️ Es wurde keine Datei übergeben.",
        "title": "Paperless Upload"
    },
    "en": {
        "success": "✅ Upload successful!",
        "error": "❌ Upload failed:",
        "http": "HTTP",
        "upload_exception": "⚠️ Error during upload:",
        "nofile": "⚠️ No file provided.",
        "title": "Paperless Upload"
    }
}

def show_message(text, title="Paperless Upload", icon=0x10):
    ctypes.windll.user32.MessageBoxW(0, text, title, icon)

def load_config():
    base_dir = os.path.dirname(sys.executable if getattr(sys, 'frozen', False) else __file__)
    config_path = os.path.join(base_dir, 'config.json')

    if not os.path.exists(config_path):
        raise FileNotFoundError(f"Konfigurationsdatei nicht gefunden:\n{config_path}")

    with open(config_path, 'r', encoding='utf-8') as f:
        return json.load(f)

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
            show_message(msg, title=text["title"], icon=0x40)
        else:
            show_message(f"{text['error']}\n{text['http']} {response.status_code}\n{response.text}", title=text["title"])
    except Exception as e:
        show_message(f"{text['upload_exception']}\n{str(e)}", title=text["title"])

if __name__ == "__main__":
    try:
        if len(sys.argv) < 2:
            config = load_config()
            lang_code = config.get("language", "en")
            text = LANG.get(lang_code, LANG["en"])
            show_message(text["nofile"], title=text["title"], icon=0x30)
        else:
            upload_file(sys.argv[1])
    except Exception as e:
        show_message(f"❌ {str(e)}", icon=0x10)