# 05\_ANDROID\_MANIFEST.md: Die Konfiguration des Betriebssystems

Die **`AndroidManifest.xml`** ist die wichtigste Datei in Ihrem Android-Projekt. Sie ist nicht einfach nur eine Konfigurationsdatei, sondern der **Personalausweis** und die **Bedienungsanleitung** Ihrer App für das Android-Betriebssystem.

## 1\. Was ist das Android Manifest?

Bevor Android Ihre App überhaupt ausführen oder installieren kann, liest der Betriebssystem-Kernel das Manifest. Es dient dazu, dem System Folgendes mitzuteilen:

1.  **Identität:** Wie heißt die App und wie lautet ihr einzigartiger Bezeichner (`Package Name`)?
2.  **Komponenten:** Welche Teile der App (Bildschirme, Hintergrunddienste, Empfänger) existieren?
3.  **Berechtigungen:** Welche Systemfunktionen braucht die App (Kamera, Internet, GPS)?
4.  **Kompatibilität:** Welche Android-Versionen und Hardware-Funktionen werden vorausgesetzt?

-----

## 2\. Die Grundstruktur

Ihr Script (`init-android-sdk-project-structure.sh`) hat die Datei unter `app/src/main/AndroidManifest.xml` erstellt. Sie enthält die absolute Mindestkonfiguration:

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.myapp">

    <application
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher"
        android:supportsRtl="true">

        <activity android:name="com.example.myapp.MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
```

### 2.1. `<manifest>`: Der Container

Dies ist das oberste Tag. Es definiert zwei zentrale Attribute:

| Attribut | Bedeutung | Erläuterung |
| :--- | :--- | :--- |
| `package` | **Der Package Name** | Eindeutiger Bezeichner der App im Play Store (z.B. `com.spotify.music`). Muss exakt dem Package-Namen in Ihrem Java-Code entsprechen. |
| `xmlns:android` | **Namespace** | Definiert den XML-Namespace für alle Android-Attribute. Dies muss immer auf `http://schemas.android.com/apk/res/android` gesetzt sein. |

### 2.2. `<application>`: Die App-Einstellungen

Dieses Tag umschließt alle Komponenten und definiert globale Standardeinstellungen für die gesamte Anwendung.

| Attribut | Bedeutung | Erläuterung |
| :--- | :--- | :--- |
| `android:label` | **App-Name** | Der Name, der unter dem App-Icon auf dem Home-Screen angezeigt wird. (Beachten Sie das `@string/app_name` – mehr dazu in Kapitel 06). |
| `android:icon` | **App-Icon** | Pfad zur Haupt-Icon-Datei (meist in `res/mipmap/`). |
| `android:supportsRtl` | **Rechts-nach-Links-Support** | Definiert, ob die App Layouts für Sprachen wie Arabisch oder Hebräisch unterstützen kann. |
| `android:name` | **Application Class** | Optional: Verweist auf eine benutzerdefinierte `Application` Klasse für globale Initialisierung. |
| `android:allowBackup` | **Backup-Erlaubnis** | Legt fest, ob die App-Daten im Cloud-Speicher gesichert werden dürfen. Standardmäßig `true`. |

-----

## 3\. Die Vier Komponenten (und ihre Manifest-Tags)

Jede Android-App besteht aus einer Kombination von bis zu vier Arten von Komponenten. **Jede Komponente muss im `<application>`-Tag registriert werden**, damit das Betriebssystem sie starten kann.

### 3.1. `<activity>`: Der Bildschirm

Ein **Activity** ist in der Regel ein einzelner, fokussierter Bildschirm, den der Benutzer sehen und mit dem er interagieren kann (z.B. der Posteingang, die Einstellungen, der Login-Screen).

**Im Manifest:**

```xml
<activity android:name="com.example.myapp.MainActivity"
    android:exported="true">
    ...
</activity>
```

  * `android:name`: **Erforderlich.** Voller Klassenname der Java-Datei, die diese Activity implementiert (z.B. `MainActivity`).
  * `android:exported`: **Neu und wichtig ab API 31.** Legt fest, ob Komponenten anderer Apps diese Activity starten dürfen. Muss für die Start-Activity (`MAIN` Action) auf `true` gesetzt werden.

### 3.2. `<service>`: Der Hintergrund-Job

Ein **Service** führt langlaufende Operationen im Hintergrund aus, ohne eine Benutzeroberfläche bereitzustellen (z.B. Musik-Streaming, Herunterladen von Dateien).

**Im Manifest:**

```xml
<service android:name=".MyDownloadService" />
```

### 3.3. `<receiver>`: Der System-Zuhörer

Ein **Broadcast Receiver** reagiert auf systemweite oder App-spezifische Nachrichten (Broadcasts). Er wird kurzzeitig gestartet, um eine Nachricht zu verarbeiten (z.B. Batterie ist niedrig, Gerät wurde neu gestartet).

**Im Manifest:**

```xml
<receiver android:name=".AlarmReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED" />
    </intent-filter>
</receiver>
```

### 3.4. `<provider>`: Der Daten-Teiler

Ein **Content Provider** verwaltet den Zugriff auf eine gemeinsame Menge von Anwendungsdaten. Er ermöglicht es anderen Apps, Daten zu lesen oder zu schreiben (z.B. die Kontakte-Datenbank).

**Im Manifest:**

```xml
<provider android:name=".MyFileProvider"
    android:authorities="com.example.myapp.fileprovider"
    android:exported="false"
    android:grantUriPermissions="true"/>
```

-----

## 4\. Intents und Intent-Filter: Kommunikation

Intents sind Nachrichtenobjekte, die zur Laufzeit verwendet werden, um eine Aktion anzufordern (z.B. "Starte diese Activity" oder "Sende diese E-Mail").

**Intent-Filter** im Manifest definieren, auf welche Arten von Intents eine App-Komponente reagieren kann.

Schauen wir uns den Filter für die `MainActivity` an, den Ihr Script erzeugt hat:

```xml
<intent-filter>
    <action android:name="android.intent.action.MAIN" />
    <category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
```

### `android.intent.action.MAIN` (Action)

  * **Bedeutung:** Definiert den **Einstiegspunkt** der Anwendung.
  * **Aktion:** "Dies ist die Hauptaktion, die ausgeführt werden soll, wenn der Benutzer die App startet."

### `android.intent.category.LAUNCHER` (Category)

  * **Bedeutung:** Definiert, dass diese Komponente im **App-Drawer** des Systems als Top-Level-Anwendung erscheinen soll.
  * **Kategorie:** "Diese Komponente soll vom Homescreen oder App-Drawer aus startbar sein."

**Zusammenfassung:** Nur Komponenten, die beide Tags besitzen, erscheinen als Symbol auf dem Home-Screen und können als erster Bildschirm der App gestartet werden.

-----

## 5\. Systemanforderungen und Berechtigungen

### 5.1. Berechtigungen (`<uses-permission>`)

Alle Berechtigungen, die Ihre App benötigt, um auf sensible Daten oder geschützte Systemfunktionen zuzugreifen, müssen **außerhalb** des `<application>`-Tags, aber **innerhalb** des `<manifest>`-Tags deklariert werden.

**Beispiele:**

```xml
<uses-permission android:name="android.permission.INTERNET" />

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

**Wichtig:** Das Manifest teilt dem System nur mit, **dass** die App die Berechtigung benötigt. Für gefährliche Berechtigungen (wie Kamera, Standort) muss die App den Benutzer zur Laufzeit (Runtime) **zusätzlich** um Erlaubnis fragen. Die Manifest-Deklaration ist der erste, notwendige Schritt.

### 5.2. Hardware- und Versions-Anforderungen

Diese Tags legen fest, welche Geräte Ihre App unterstützen kann.

#### `<uses-feature>`: Hardware-Anforderung

Wenn die App ohne eine bestimmte Hardware-Funktion nicht funktioniert, muss dies hier deklariert werden.

```xml
<uses-feature android:name="android.hardware.camera" android:required="true" />
```

#### `<uses-sdk>`: Versions-Kompatibilität

Obwohl diese Werte meistens über die `app/build.gradle` (siehe Kapitel 07) überschrieben werden, sind sie technisch gesehen Teil des Manifests. Sie definieren die minimal und maximal unterstützten API-Level:

| Attribut | Gradle-Entsprechung | Bedeutung |
| :--- | :--- | :--- |
| `android:minSdkVersion` | `minSdk` | Niedrigste API-Level, auf dem die App lauffähig ist. |
| `android:targetSdkVersion` | `targetSdk` | Die API-Level, für das die App optimiert wurde und auf dem sie getestet wurde. |
| `android:maxSdkVersion` | (Nicht empfohlen) | Höchste API-Level, auf dem die App ausgeführt werden soll. |

**Fazit:** Das Manifest ist die XML-Zentrale. Es ist das erste und wichtigste Artefakt, das der Android Compiler (genauer gesagt `aapt`, das Android Asset Packaging Tool) verarbeitet, um die App zu bauen. Ein fehlerhaftes Manifest bedeutet einen fehlerhaften Build oder eine nicht startbare App.

