[Setup]
AppName=Paperless Uploader
AppVersion=1.0
DefaultDirName={pf}\PaperlessUploader
DefaultGroupName=PaperlessUploader
OutputDir=output
OutputBaseFilename=Setup
UninstallDisplayIcon={app}\uploader.exe
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Files]
Source: "dist\uploader.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "dist\icon.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Paperless Uploader"; Filename: "{app}\uploader.exe"
Name: "{group}\Uninstall Paperless Uploader"; Filename: "{uninstallexe}"

[Registry]
; Kontextmenüeintrag
Root: HKCR; Subkey: "*\shell\UploadToPaperless"; ValueType: string; ValueName: ""; \
  ValueData: "{code:GetMenuText}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\UploadToPaperless"; ValueType: string; ValueName: "Icon"; \
  ValueData: "{app}\icon.ico"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "*\shell\UploadToPaperless\command"; ValueType: string; \
  ValueData: """{app}\uploader.exe"" ""%1"""; Flags: uninsdeletekey

[Code]
var
  PageServer: TInputQueryWizardPage;
  PageLanguage: TInputOptionWizardPage;
  ServerURL, ApiKey, Language: string;

procedure InitializeWizard;
begin
  // Serverdaten abfragen
  PageServer := CreateInputQueryPage(
    wpSelectDir,
    'Paperless-Konfiguration',
    'Verbindungsdaten zur Paperless Instanz',
    'Bitte gib die Verbindungseinstellungen ein:'
  );
  PageServer.Add('Server URL (z. B. https://paperless.example.com):', False);
  PageServer.Add('API Key:', False);

  // Sprachwahl
  PageLanguage := CreateInputOptionPage(
    wpSelectDir,
    'Sprache auswählen',
    'Bitte wähle die Sprache für die Anwendung.',
    'Diese Sprache wird für das Kontextmenü und die Konfigurationsdatei verwendet.',
    False,
    False
  );
  PageLanguage.Add('Deutsch');
  PageLanguage.Add('English');
  PageLanguage.SelectedValueIndex := 0;
end;

function GetMenuText(Value: string): string;
begin
  if Language = 'en' then
    Result := 'Upload to Paperless'
  else
    Result := 'Zu Paperless hochladen';
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ConfigFile, JSONText: string;
begin
  if CurStep = ssPostInstall then
  begin
    ServerURL := Trim(PageServer.Values[0]);
    ApiKey := Trim(PageServer.Values[1]);
    if PageLanguage.SelectedValueIndex = 1 then
      Language := 'en'
    else
      Language := 'de';

    ConfigFile := ExpandConstant('{app}\config.json');

    JSONText :=
      '{' + #13#10 +
      '  "server": "' + ServerURL + '",' + #13#10 +
      '  "api_key": "Token ' + ApiKey + '",' + #13#10 +
      '  "language": "' + Language + '"' + #13#10 +
      '}';

    if not SaveStringToFile(ConfigFile, JSONText, False) then
      MsgBox('Fehler beim Schreiben der Konfigurationsdatei.', mbError, MB_OK);
  end;
end;