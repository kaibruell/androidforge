
# 🤖 Android SDK Command-Line Tools Installation für Arch Linux

## 🎯 Wofür brauchen wir die Android SDK Command-Line Tools?

Die **Android SDK Command-Line Tools** sind das **Fundament** für die Android-Entwicklung. Sie enthalten:

  * **`sdkmanager`**: Ein Werkzeug zum Verwalten und Installieren von Android SDK-Komponenten (wie Build-Tools, Platform-Versionen, Emulator, usw.)
  * **Platform Tools**: Tools wie `adb` (Android Debug Bridge) und `fastboot` zum Debuggen von Apps auf echten Geräten oder im Emulator
  * **Build Tools**: Notwendig zum Kompilieren und Packen von Android-Apps
  * **Emulator**: Für das Testen von Apps ohne physisches Gerät

Ohne diese Tools können Sie keine Android-Apps erstellen, debuggen oder auf Geräten testen.

-----

## 🛠️ Installation der Android SDK Command-Line Tools

### Schritt 1: Arbeitsverzeichnis erstellen

```bash
# Android SDK installieren wir im Home-Verzeichnis
# ~ ist eine Abkürzung für /home/[benutzername]
# Folgendes erstellt also: /home/[benutzername]/Android/Sdk
mkdir -p ~/Android/Sdk
```

#### Warum `~/Android/Sdk`?

Die Verwendung von `~/Android/Sdk` ist die **offizielle Convention** von Google und Android Developers. Alle Standard-Tools erwarten diesen Pfad automatisch:

  * **Android Studio**: Sucht automatisch nach `~/Android/Sdk`
  * **Gradle**: Das Android Gradle Plugin verweist standardmäßig auf `~/Android/Sdk`
  * **`adb`**: Findet die Platform Tools automatisch in diesem Verzeichnis
  * **`sdkmanager`**: Erkennt diesen Pfad als Standard-Installation
  * **Andere Tools**: Emulator, Build Tools, usw. erwarten diese Struktur

> **Vorteil**: Sie müssen `ANDROID_HOME` nicht extra setzen – die Tools funktionieren sofort "out of the box", wenn Sie diesen Standard-Pfad verwenden.

**Alternative Pfade**: Falls Sie das SDK woanders installieren, müssen Sie immer manuell diese Umgebungsvariablen setzen:

```bash
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
```

**Empfehlung**: Bleiben Sie bei `~/Android/Sdk` – das spart Ihnen Konfigurationsarbeit und ist mit allen Tools kompatibel.

### Schritt 2: Command-Line Tools herunterladen

Die neueste Version der Command-Line Tools finden Sie auf der [offiziellen Android Developers Seite](https://developer.android.com/studio/command-line/sdkmanager).

Für Linux (64-bit) downloaden Sie die Datei mit folgendem Befehl:

1.  Besuchen Sie die [offizielle Android Developers Seite](https://developer.android.com/studio/command-line/sdkmanager)
2.  Suchen Sie nach dem Download-Link für **"Command line tools for Linux"**
3.  Kopieren Sie die Download-URL und verwenden Sie `wget`:

<!-- end list -->

```bash
cd ~/Downloads
# Ersetzen Sie [URL] durch die aktuelle Download-URL von der offiziellen Seite
wget [URL]
```

> **Wichtig**: Laden Sie immer die neueste Version von der offiziellen Seite herunter. Die Versionsnummern ändern sich regelmäßig.

### Schritt 3: Command-Line Tools extrahieren

```bash
cd ~/Android/Sdk

# Entpacken Sie die heruntergeladene Zip-Datei
unzip ~/Downloads/commandlinetools-linux-*_latest.zip

# Nach dem Entpacken haben Sie einen "cmdline-tools" Ordner mit bin/, lib/ etc.
# Android-Tools erwarten aber die Struktur: cmdline-tools/latest/bin/
# Deshalb verschieben wir den Ordner:

mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/

# Endgültiges Resultat: ~/Android/Sdk/cmdline-tools/latest/bin/sdkmanager
# Verifizieren Sie das mit:
ls -la cmdline-tools/latest/bin/sdkmanager
```

### Schritt 4: Umgebungsvariablen konfigurieren

Der `sdkmanager` muss im `PATH` erreichbar sein und der `ANDROID_HOME` muss gesetzt sein.

**Für Bash** (`~/.bashrc`):

```bash
# Android SDK Umgebungsvariablen
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
```

**Für andere Shells** (Zsh, Fish, etc.):
Bitte suchen Sie online nach der korrekten Syntax für Ihre Shell (z.B. "Zsh .zshrc environment variables").

Nach dem Hinzufügen:

```bash
source ~/.bashrc
```

### Schritt 5: `sdkmanager` Lizenz akzeptieren

Der `sdkmanager` verlangt, dass Sie die Android-Lizenzen akzeptieren:

```bash
# Alle Android SDK Lizenzen akzeptieren
sdkmanager --licenses
```

Sie werden aufgefordert, mehrere Lizenzen zu akzeptieren. Drücken Sie für jede Lizenz `y` und `Enter`.

-----

## 🏗️ Wichtige Android SDK-Komponenten installieren

Jetzt müssen Sie die einzelnen Android SDK-Komponenten installieren, die für die Android-Entwicklung notwendig sind.

-----

### 1\. Android Platform-Versionen installieren

#### Wozu dient das?

Android Platform-Versionen sind die verschiedenen Android API-Level, auf die Sie Ihre Apps zielgerichtet entwickeln können. Jede API-Version entspricht einer Android Version (z.B. API 35 = Android 15).

#### Welche Versionen sollte ich wählen?

  * **Aktuelle Version (z.B. android-35)**: Nutzen Sie die neuesten Android-Features. Dies ist die **Target API** – das System, auf das Ihre App optimiert ist.
  * **Minimum API (z.B. android-24 / Android 7.0)**: Definiert die ältesten Devices, auf denen Ihre App noch funktioniert.

| Android Version | API Level | Marktanteil | Empfehlung |
| :---: | :---: | :---: | :---: |
| Android 15 | 35 | \~5% | ✅ Target API |
| Android 14 | 34 | \~15% | ✅ Fallback |
| Android 13 | 33 | \~20% | ⭕ Für breite Kompatibilität |
| ... | ... | ... | ... |
| Android 7 (Nougat) | 24 | \~5% | ⚠️ Minimales Target |

#### Installation:

Installieren Sie alle Android-Versionen zwischen Ihrem **Target API** (neuste Version) und Ihrem **Minimum API** (älteste Version, die Sie noch unterstützen möchten).

```bash
# Beispiel: Unterstützung von Android 7 (API 24) bis Android 15 (API 35)
sdkmanager "platforms;android-35"
sdkmanager "platforms;android-34"
sdkmanager "platforms;android-33"
sdkmanager "platforms;android-24"
```

### 2\. Build Tools installieren

#### Wozu dient das?

Die Build Tools enthalten die notwendigen Kompiler und Werkzeuge, um Ihren Android-App-Code in ausführbare Android-Apps umzuwandeln.

  * Die Build Tools Version sollte **gleich oder höher** sein als die höchste Android Platform-Version, die Sie installiert haben.
      * *Beispiel:* Wenn Sie `platforms;android-35` installiert haben, brauchen Sie mindestens `build-tools;35.0.0`.

#### Installation:

1.  Finden Sie die passende Build Tools Version auf der [Android Developer Site](https://developer.android.com/studio/releases/build-tools)
2.  Wählen Sie eine Version, die mindestens so hoch wie Ihre höchste Platform-Version ist

<!-- end list -->

```bash
# Ersetzen Sie [VERSION] durch die gewählte Version von der Website (z.B. 35.0.0)
sdkmanager "build-tools;[VERSION]"
```

### 3\. Platform Tools installieren

#### Wozu dient das?

Die Platform Tools sind essenzielle Kommandozeilen-Werkzeuge für die Kommunikation mit Android-Geräten und dem Emulator.

  * Enthält **`adb` (Android Debug Bridge)** und **`fastboot`**.

#### Installation:

```bash
sdkmanager "platform-tools"
```

> **Hinweis**: Bei `platform-tools` gibt es **keine spezifischen Versionsnummern** im Befehl. Der Befehl installiert immer die **neueste Version** automatisch.

### 4\. Android Emulator installieren

#### Wozu dient das?

Der Android Emulator ist eine vollständige Android-Simulation auf Ihrem Computer zum Testen von Apps.

> **Wichtig**: Der Emulator braucht viel RAM und CPU.

#### Installation:

```bash
sdkmanager "emulator"
```

### 5\. System Images für Emulator installieren

#### Wozu dient das?

System Images sind die kompletten Android-Betriebssystem-Abbilder, die der Emulator ausführt. Ohne System Images können Sie den Emulator nicht starten.

| Variante | Beschreibung | Architektur | Empfehlung |
| :--- | :--- | :--- | :--- |
| **google\_apis** | Mit Google Play Services | **x86\_64** | Empfohlen für Entwicklung |
| **google\_apis\_playstore** | Mit Google Play Services + Play Store | **x86\_64** | Wenn Sie den Play Store im Emulator brauchen |

#### Installation:

Installieren Sie mindestens eine System Image für die aktuelle Android-Version:

```bash
# Beispiel für Android 15 (API 35) mit Google Services
sdkmanager "system-images;android-35;google_apis;x86_64"
```

-----

## ✅ Installation verifizieren

Nach erfolgreicher Installation prüfen Sie alle installierten Komponenten mit:

```bash
sdkmanager --list_installed
```

### Prüfbefehle:

```bash
# sdkmanager Version prüfen
sdkmanager --version

# Erwartete Ausgabe:
# Android SDK Command-line Tools Version 11.0 oder höher

# ANDROID_HOME prüfen
echo $ANDROID_HOME

# Erwartete Ausgabe:
# /home/[benutzername]/Android/Sdk

# adb prüfen (gehört zu Platform Tools)
adb version

# Erwartete Ausgabe:
# Android Debug Bridge version 1.0.41 (oder höher)
```

-----
