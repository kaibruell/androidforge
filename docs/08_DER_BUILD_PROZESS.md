
-----

# 08\_DER\_BUILD-PROZESS SCHRITT FÜR SCHRITT

Das Verstehen des Build-Prozesses beginnt mit der **Struktur und Hierarchie** des Projekts, da diese die Build-Konfiguration steuert.

## 🤝 Die Build-Konfigurationshierarchie

Ein Android-Projekt ist in eine **Root-Ebene** (Projekt-Level) und **App-Ebenen** (Modul-Level) unterteilt. Die Konfigurationen auf diesen Ebenen arbeiten hierarchisch zusammen, um den Build-Prozess zu steuern.

### 🏗️ Root-Level (Wurzelverzeichnis)

Das **Root-Level** ist der **Manager** des Projekts. Es bezieht sich auf das oberste Verzeichnis und steuert das Projekt als Ganzes.

| Datei | Zweck | Wer nutzt diese Einstellung? |
| :--- | :--- | :--- |
| `settings.gradle` | **Projektstruktur** | Definiert alle Module (z.B. `:app`, `:libraryA`), die gebaut werden sollen. |
| `build.gradle` (Root) | **Globale Konfiguration** | Definiert Versionen von Build-Tools (wie das **Android Gradle Plugin (AGP)**) und die Repositories (Quellen) für alle Abhängigkeiten. |
| `gradle.properties` | **Build-System-Flags** | Globale VM-Argumente für den Gradle-Daemon und AGP-Konfigurations-Flags. |
| `gradlew / gradlew.bat` | **Der Wrapper** | Die Skripte, die den eigentlichen Build-Prozess starten. |

Änderungen hier wirken sich auf alle Untermodule aus.

### 📱 App-Level (Modul-Level)

Das **App-Level** (im Verzeichnis `app/`) ist der **Arbeitsbereich**. Es enthält den Quellcode und die **app-spezifische Konfiguration**.

| Datei | Zweck | Wer nutzt diese Einstellung? |
| :--- | :--- | :--- |
| `app/build.gradle` | **Modul-Konfiguration** | Definiert die Build-Details für genau dieses Modul: Welche SDK-Versionen (`minSdk`, `targetSdk`), welche **Abhängigkeiten** (`dependencies {}`) und welche Build-Typen (`debug`, `release`) dieses Modul verwendet. |
| `app/src/main/` | **Quellcode & Ressourcen** | Enthält den gesamten Java/Kotlin-Code, alle Ressourcen (`res/`) und die `AndroidManifest.xml` – die eigentlichen Inhalte der App. |

Das Modul erbt die Werkzeuge (AGP-Version, Gradle-Version) vom Root-Level, konfiguriert aber seine eigenen App-spezifischen Metadaten.

### 🔗 Zusammenspiel

Die Beziehung ist **hierarchisch**:

1.  Der Build wird über das Root-Level-Skript gestartet: `./gradlew assembleDebug`.
2.  Das Root-Level (über `settings.gradle` und `build.gradle`) delegiert die Aufgabe an das definierte Modul (`:app`).
3.  Das `:app`-Modul führt die Aufgabe basierend auf seiner spezifischen Konfiguration in `app/build.gradle` aus.

-----

## Übersicht des Build-Trichters: Von Java zur APK

Dies ist das Kapitel, das die "Black Box" wirklich öffnet und die Magie erklärt, die hinter dem Befehl `./gradlew assembleDebug` steckt. Es geht darum, wie Ihre Java-Dateien, Ressourcen und Konfigurationen in eine einzige, ausführbare `.apk`-Datei verwandelt werden.

Der Befehl `./gradlew assembleDebug` ist ein **Orchestrator** (vom Android Gradle Plugin bereitgestellt), der eine Reihe von spezialisierten Kommandozeilen-Tools nacheinander aufruft. Jedes Tool ist für einen bestimmten Schritt im **Build-Trichter** (Build Funnel) verantwortlich.

| Schritt | Tool | Input | Output | Zweck |
| :--- | :--- | :--- | :--- | :--- |
| **1. Ressourcen-Kompilierung** | `aapt2` | `res/`, `AndroidManifest.xml` | `R.java`, `resources.arsc` | Erzeugt eindeutige **IDs** für alle Ressourcen und erstellt eine binäre Ressourcen-Tabelle. |
| **2. Java-Kompilierung** | `javac` | `.java` Dateien (+ `R.java`) | `.class` Dateien (Java Bytecode) | Übersetzt den Quellcode in **plattformunabhängigen Java-Bytecode**. |
| **3. DEXing** | `d8` | `.class` Dateien | `.dex` Dateien (Dalvik Executable) | Konvertiert Java Bytecode in das für die **Android Runtime (ART)** optimierte Format. |
| **4. Packaging & Signierung** | `aapt2`, `apksigner` | `.dex`, `resources.arsc`, bin. Manifest | Unsignierte `.apk` | Packt alle Komponenten (Code, Ressourcen, Metadaten) und **signiert** das Archiv. |
| **5. Optimierung** | `zipalign` | Signierte `.apk` | Finale, optimierte `.apk` | Stellt die **Speicherausrichtung** der Daten sicher, um die Ladezeiten auf dem Gerät zu beschleunigen. |

-----

## 1\. aapt (Android Asset Packaging Tool)

Der erste Schritt gehört dem **Android Asset Packaging Tool (aapt)**, in modernen Versionen als `aapt2` bekannt.

### Aufgabe: Ressourcen verarbeiten und referenzierbar machen

`aapt2` verarbeitet alle Nicht-Code-Komponenten und erstellt die Verweise für den Code:

1.  **Ressourcen-Kompilierung**: Es parst alle XML-Dateien (Layouts, Strings, Styles, etc.) und die `AndroidManifest.xml`.
2.  **`R.java`-Generierung**: Für jede Ressource generiert `aapt2` eine eindeutige, statische **Integer-ID**. Diese IDs werden in der Datei **`R.java`** gespeichert, die dem Java-Compiler im nächsten Schritt als Input dient. Dadurch kann Ihr Java-Code auf Ressourcen mit Bezeichnern wie **`R.layout.activity_main`** zugreifen.
3.  **`resources.arsc`**: Es erstellt eine binäre Datei (`resources.arsc`), die alle Metadaten der Ressourcen enthält. Diese Tabelle wird vom Android-Betriebssystem zur Laufzeit verwendet, um die korrekte Ressource schnell zu finden (z.B. den richtigen String für die jeweilige Sprache).

> **Ergebnis:** Ohne `aapt2` wüssten weder Ihr Java-Code noch das Android-Betriebssystem, wo sich die Ressourcen befinden und wie sie zu referenzieren sind.

-----

## 2\. javac und Bytecode

Nachdem die Ressourcen-IDs (`R.java`) erstellt wurden, kann der eigentliche Java-Code kompiliert werden.

### Aufgabe: Vom Quellcode zum Bytecode

Das Tool **`javac`** (der Java-Compiler) übernimmt diesen Schritt:

1.  **Input**: Ihre Quellcode-Dateien (`.java`) und die vom AGP bereitgestellte **`R.java`**.
2.  **Kompilierung**: `javac` übersetzt den Java-Quellcode in **Java Bytecode**.
3.  **Output**: Für jede Java-Klasse wird eine separate **`.class`**-Datei generiert.

> **Java Bytecode (.class)**: Dies ist ein **Zwischenformat**. Es ist kein Maschinencode, sondern eine Reihe von Anweisungen, die von einer Java Virtual Machine (JVM) verstanden werden können.

-----

## 3\. d8 (Dexing)

Der entscheidende Android-spezifische Konvertierungsschritt ist das **Dexing**.

### Aufgabe: Java Bytecode in das Dalvik Executable Format konvertieren

Android verwendet nicht die Standard-JVM, sondern die **Android Runtime (ART)**. Die ART ist für Mobilgeräte optimiert und kann Bytecode im **Dalvik Executable (.dex) Format** effizienter ausführen.

Das Tool **`d8`** (der Dex-Compiler, der `dx` in modernen Builds ersetzt) führt diese Konvertierung durch:

1.  **Input**: Alle **`.class`**-Dateien des Projekts und aller abhängiger Bibliotheken.
2.  **Konvertierung**: `d8` führt eine Optimierung durch und fasst alle separaten `.class`-Dateien in einer (oder bei sehr großen Projekten in mehreren) komprimierten **`.dex`**-Datei(en) zusammen.

> **Warum Dexing?**: `D8` reduziert Redundanzen und erstellt ein kompakteres Format. In der `.dex`-Datei sind alle Klassen so umstrukturiert, dass sie von der Android Runtime (ART) effizienter aufgerufen werden können.

-----

## 4\. APK-Erstellung und Signierung

Nachdem der Code im `.dex`-Format vorliegt und die Ressourcen binär verarbeitet wurden, werden sie zusammengefügt.

### Aufgabe: Das Archiv schnüren und versiegeln

1.  **Packaging (mit `aapt2`)**: Alle Komponenten werden in einem standardisierten ZIP-Archiv, der **`.apk`**-Datei (Android Package Kit), zusammengepackt:
      * Die `classes.dex` (der ausführbare Code).
      * Die `resources.arsc` und alle komprimierten Ressourcen.
      * Das binär kompilierte `AndroidManifest.xml`.
2.  **Signierung (mit `apksigner`)**: Jede `.apk`-Datei muss **digital signiert** werden. Das Betriebssystem verwendet diese Signatur zur Gewährleistung der **Integrität** und zur Überprüfung der **Identität des Entwicklers** (wichtig für App-Updates).

<!-- end list -->

  * **Debug-Builds**: Verwenden einen automatisch generierten **Debug-Keystore**.
  * **Release-Builds**: Erfordern einen **eigenen, sicheren Keystore**.

-----

## 5\. Zipalign: Optimierung der APK-Datei

Der letzte Schritt im Build-Prozess ist eine entscheidende Optimierung für die Performance auf dem Gerät.

### Aufgabe: Speicherausrichtung für Memory Mapping

Das Tool **`zipalign`** wird auf die signierte APK-Datei angewendet.

1.  **Was es tut**: `zipalign` ordnet alle unkomprimierten Dateien innerhalb des APK-Archivs an **4-Byte-Grenzen** neu an.
2.  **Warum es wichtig ist**: Diese Ausrichtung ermöglicht es dem Android-System, die Ressourcen direkt aus der `.apk`-Datei im Speicher abzubilden (**Memory Mapping**), anstatt die Daten entpacken zu müssen.
3.  **Vorteil**: **Schnellere App-Startzeiten** und **reduzierter RAM-Verbrauch**.

> **Ergebnis:** Die finale, optimierte `.apk`-Datei ist nun bereit zur Installation.

## 📦 Die Ausgabe der Build-Tasks

Der Hauptzweck des Gradle-Befehls `./gradlew assembleDebug` oder `./gradlew assembleRelease` ist die Erstellung der **finalen APK-Dateien**.

| Befehl | Zweck | Ausgabe-Pfad (Relativ) |
| :--- | :--- | :--- |
| **`./gradlew assembleDebug`** | Führt den gesamten Build-Trichter mit **Debug-Konfiguration** und **Debug-Schlüssel** durch. | `app/build/outputs/apk/debug/app-debug.apk` |
| **`./gradlew assembleRelease`** | Führt den gesamten Build-Trichter mit **Release-Konfiguration** durch (erfordert Keystore-Konfiguration). | `app/build/outputs/apk/release/app-release.apk` |

### 1\. Die finale APK

Die `.apk`-Datei ist ein **Standard-ZIP-Archiv**, das alle notwendigen Komponenten für die Installation auf einem Android-Gerät enthält, einschließlich: `classes.dex`, `resources.arsc`, dem binär kompilierten `AndroidManifest.xml` und Signatur-Metadaten.

### 2\. Der nächste Schritt: Installation

Sobald die APK generiert wurde, kann sie direkt auf einem angeschlossenen Gerät oder Emulator installiert werden, ohne sie manuell verschieben zu müssen.

Das **Android Gradle Plugin (AGP)** stellt dafür separate Tasks bereit:

  * **Installation (Debug):**

    ```bash
    ./gradlew installDebug
    ```

    Dieser Befehl führt automatisch `assembleDebug` aus (falls nötig) und verwendet anschließend das **Android Debug Bridge (adb)** Tool zur Übertragung und Installation der `app-debug.apk`.

  * **Installation (Release):**

    ```bash
    ./gradlew installRelease
    ```

Das Verstehen des Build-Prozesses ist die Grundlage. Jetzt können Sie sehen, wie die Ergebnisse dieses Prozesses direkt in den nächsten Schritt übergehen: das Testen auf einem Gerät.

-----
