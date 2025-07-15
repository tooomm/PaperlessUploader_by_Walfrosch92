{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 [Setup]\
AppName=Paperless Uploader\
AppVersion=1.0\
DefaultDirName=\{pf\}\\PaperlessUploader\
DefaultGroupName=PaperlessUploader\
OutputDir=output\
OutputBaseFilename=Setup\
UninstallDisplayIcon=\{app\}\\uploader.exe\
Compression=lzma\
SolidCompression=yes\
ArchitecturesInstallIn64BitMode=x64\
\
[Languages]\
Name: "english"; MessagesFile: "compiler:Default.isl"\
Name: "german"; MessagesFile: "compiler:Languages\\German.isl"\
\
[Files]\
Source: "dist\\uploader.exe"; DestDir: "\{app\}"; Flags: ignoreversion\
Source: "dist\\icon.ico"; DestDir: "\{app\}"; Flags: ignoreversion\
\
[Icons]\
Name: "\{group\}\\Paperless Uploader"; Filename: "\{app\}\\uploader.exe"\
Name: "\{group\}\\Uninstall Paperless Uploader"; Filename: "\{uninstallexe\}"\
\
[Registry]\
; Kontextmen\'fceintrag \'96 Text und Icon dynamisch per Sprache\
Root: HKCR; Subkey: "*\\shell\\UploadToPaperless"; ValueType: string; ValueName: ""; \\\
  ValueData: "\{code:GetMenuText\}"; Flags: uninsdeletekey\
Root: HKCR; Subkey: "*\\shell\\UploadToPaperless"; ValueType: string; ValueName: "Icon"; \\\
  ValueData: "\{app\}\\icon.ico"; Flags: uninsdeletevalue\
Root: HKCR; Subkey: "*\\shell\\UploadToPaperless\\command"; ValueType: string; \\\
  ValueData: """\{app\}\\uploader.exe"" ""%1"""; Flags: uninsdeletekey\
\
[Code]\
var\
  PageServer: TInputQueryWizardPage;\
  PageLanguage: TInputOptionWizardPage;\
  ServerURL, ApiKey, Language: string;\
\
procedure InitializeWizard;\
begin\
  // Abfrage: Server-URL und API-Key\
  PageServer := CreateInputQueryPage(\
    wpSelectDir,\
    'Paperless-Konfiguration',\
    'Verbindungsdaten zur Paperless Instanz',\
    'Bitte gib die Verbindungseinstellungen ein:'\
  );\
  PageServer.Add('Server URL (z.\uc0\u8239 B. https://paperless.example.com):', False);\
  PageServer.Add('API Key:', False);\
\
  // Abfrage: Sprache per Dropdown\
  PageLanguage := CreateInputOptionPage(\
    wpSelectDir,\
    'Sprache ausw\'e4hlen',\
    'Bitte w\'e4hle die Sprache f\'fcr die Anwendung.',\
    'Diese Sprache wird f\'fcr das Kontextmen\'fc und die Konfigurationsdatei verwendet.',\
    False,\
    False\
  );\
  PageLanguage.Add('Deutsch');\
  PageLanguage.Add('English');\
  PageLanguage.SelectedValueIndex := 0; // Standard: Deutsch\
end;\
\
function GetMenuText(Value: string): string;\
begin\
  if Language = 'en' then\
    Result := '\uc0\u55358 \u56389  Upload to Paperless'\
  else\
    Result := '\uc0\u55358 \u56389  Zu Paperless hochladen';\
end;\
\
procedure CurStepChanged(CurStep: TSetupStep);\
var\
  ConfigFile, JSONText: string;\
begin\
  if CurStep = ssPostInstall then\
  begin\
    ServerURL := Trim(PageServer.Values[0]);\
    ApiKey := Trim(PageServer.Values[1]);\
    if PageLanguage.SelectedValueIndex = 1 then\
      Language := 'en'\
    else\
      Language := 'de';\
\
    ConfigFile := ExpandConstant('\{app\}\\config.json');\
\
    JSONText :=\
      '\{' + #13#10 +\
      '  "server": "' + ServerURL + '",' + #13#10 +\
      '  "api_key": "' + ApiKey + '",' + #13#10 +\
      '  "language": "' + Language + '"' + #13#10 +\
      '\}';\
\
    if not SaveStringToFile(ConfigFile, JSONText, False) then\
      MsgBox('Fehler beim Schreiben der Konfigurationsdatei.', mbError, MB_OK);\
  end;\
end;\
}