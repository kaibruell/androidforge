# Gradle Wrapper – Initialisiert und bereit

Im letzten Kapitel (03_PROJECT-STRUCTURE.md) haben wir unser Android-Projekt mit dem Script `init-android-sdk-project-structure.sh` erstellt.

Dieses Script hat nicht nur die gesamte Projektstruktur und Konfiguration angelegt, sondern auch den **Gradle Wrapper** **initialisiert**.

Das Script führte intern die **Gradle Wrapper Initialisation** aus:
```bash
gradle wrapper --gradle-version "$GRADLE_VERSION" --warning-mode all
```

---

## Was wurde erstellt?

Das Script hat diese Wrapper-Dateien in dein Projekt gelegt:

```
gradle/
├── wrapper/
│   ├── gradle-wrapper.jar        ← Die Wrapper-Logik
│   └── gradle-wrapper.properties  ← Die Konfiguration
│
gradlew                            ← Linux/Mac Build-Skript
gradlew.bat                        ← Windows Build-Skript
```

---

## Die Wrapper-Dateien erklärt

### `gradlew` (Linux/Mac Skript)

Das ist das Haupt-Skript zum Starten von Gradle. 

#### Was passiert beim ersten Start?

1. **Der Wrapper prüft die Gradle-Version**

   Das `gradlew`-Skript liest die Datei `gradle/wrapper/gradle-wrapper.properties` und sucht nach der `distributionUrl`:

   ```properties
   distributionUrl=https\://services.gradle.org/distributions/gradle-9.2.1-bin.zip
   ```

   Hier wird genau festgelegt, welche Gradle-Version heruntergeladen werden soll.

2. **Er lädt die Gradle-Distribution herunter**

   Falls diese Version noch nicht auf deinem Computer vorhanden ist, wird die ZIP-Datei von `services.gradle.org` heruntergeladen. Die Distribution enthält:
   - Gradle Binaries
   - Standard-Bibliotheken
   - Shell-Skripte und Batch-Dateien
   - Runtime JARs

   ```
   Downloading https://services.gradle.org/distributions/gradle-9.2.1-bin.zip
   ............10%.............20%.............30%...
   ```

3. **Er speichert die Installation in einem Benutzer-Cache**

   Die heruntergeladene Gradle-Distribution wird unter Linux/Mac hier abgelegt:

   ```
   ~/.gradle/wrapper/dists/gradle-9.2.1-bin/[random-hash]/gradle-9.2.1/
   ```

   Dieser Cache ist **global** auf deinem Computer – alle deine Projekte können diese Gradle-Installation wiederverwenden! Durch die `gradle-wrapper.properties` Datei, benutzt dein Projekt immer eine konsistente Gradle Version.

4. **Er startet Gradle mit dieser Installation**

   Sobald die Distribution bereit ist, wird Gradle mit der angegebenen Version gestartet.

### `gradlew.bat` (Windows Skript)

Das Gleiche wie `gradlew`, nur für Windows.

### `gradle/wrapper/gradle-wrapper.jar`

Die interne Logik des Wrappers. Nicht anfassen – wird automatisch generiert.

### `gradle/wrapper/gradle-wrapper.properties`

Die **Konfiguration** des Wrappers:

```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-9.2.1-bin.zip
```

**Das Wichtigste:** Die `distributionUrl` legt fest, welche Gradle-Version heruntergeladen wird.

Wenn du die Version ändern möchtest:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-9.2.2-bin.zip
```

Beim nächsten `./gradlew` Aufruf wird die neue Version heruntergeladen.

---

## `./gradlew` ausführen

Navigiere in dein Projekt-Verzeichnis:

```bash
cd MyApp/
./gradlew
```

**Das erste Mal:**
- Der Wrapper lädt Gradle herunter
- Entpackt es nach `~/.gradle/wrapper/dists/`
- Startet dann Gradle

Danach siehst du die Welcome-Meldung von Gradle mit vielen nützlichen Befehlen.

---

## Was passiert beim ersten `./gradlew` Start?

**Schritt 1: Download**
```
Downloading https://services.gradle.org/distributions/gradle-9.2.1-bin.zip
............10%.............20%.............30%...
```
Der Wrapper lädt Gradle herunter (aus `gradle-wrapper.properties`).

**Schritt 2: Entpacken**
Die ZIP-Datei wird nach `~/.gradle/wrapper/dists/gradle-9.2.1-bin/` entpackt.

**Schritt 3: Gradle Daemon startet**
```
Starting a Gradle Daemon (subsequent builds will be faster)
```
Gradle startet einen Hintergrund-Prozess für schnellere Builds.

**Schritt 4: Help-Task**
```
> Task :help

Welcome to Gradle 9.2.1.

To run a build, run gradlew <task> ...
To see a list of available tasks, run gradlew tasks
```

Da wir keine Task angegeben haben, zeigt Gradle die Help-Meldung.

**Schritt 5: Erfolg**
```
BUILD SUCCESSFUL in 39s
1 actionable task: 1 executed
```

---

## Was sind Gradle Tasks?

Tasks sind die kleinsten Bausteine in Gradle – sozusagen Befehle/Aktionen, die Gradle ausführen kann. Jeder Task ist eine definierte Aktion mit einem Namen. Beispiele:
- help – zeigt Hilfe
- build – kompiliert dein Projekt
- test – führt Tests aus
- clean – löscht Build-Dateien

## Warum wird der Help Task ausgeführt?

Wenn du `./gradlew` ohne Argumente aufrufst, führt Gradle automatisch den help Task aus. Das ist das Default-Verhalten.

Das siehst du in der Ausgabe:
```
> Task :help

Welcome to Gradle 9.2.1.
To run a build, run gradlew <task> ...
```

Die `> Task :help` Zeile zeigt dir, welcher Task gerade läuft.

## Wo ist dieser Task definiert?

Der help Task ist in Gradle selbst eingebaut – nicht von uns definiert. Er ist Teil der Gradle-Standard-Tasks. Gradle hat eine Reihe solcher eingebauten Tasks:

```bash
./gradlew tasks        # Zeigt alle verfügbaren Tasks
./gradlew help         # Explizit den help Task aufrufen
./gradlew build        # Tasks für Android-Projekte (definiert in build.gradle)
```

Wenn du mehrere Tasks hast, spezifizierst du sie: `./gradlew clean build` würde erst clean und dann build ausführen.

## Tasks in build.gradle definieren

Man definiert eigene Tasks in der `build.gradle` Datei. Gradle hat dafür seine eigene Sprache namens **Groovy** entwickelt.

Groovy ist eine JVM-Sprache (läuft auf der Java Virtual Machine), die auf Java basiert, aber viel flexibler und dynamischer ist. Gradle hat eine sogenannte DSL (Domain-Specific Language) gebaut – also eine spezialisierte Syntax auf Basis von Groovy, die perfekt für Build-Definitionen passt.

Groovy ist Java-ähnlich, aber einfacher:

```groovy
// Groovy – Gradle-Syntax
task hello {
    println 'Hallo'
}
```

## Kotlin DSL vs. Groovy DSL

In neueren Android-Projekten sieht man auch Kotlin DSL für Gradle:

```kotlin
tasks.register("hello") {
    doLast {
        println("Hallo")
    }
}
```

Das ist Kotlin statt Groovy – aber die Idee ist gleich.

Die meisten Android-Projekte nutzen aber noch Groovy für `build.gradle` Dateien. Kotlin DSL ist moderner, wird aber nicht überall genutzt.

---

## Das Android Gradle Plugin (AGP) – Was Gradle zu Android macht

Bisher haben wir Gradle als **generelles Build-Tool** gesehen. Aber Gradle allein kann noch nicht Android-Apps bauen – dafür brauchen wir ein spezialisiertes Plugin.

Das **Android Gradle Plugin (AGP)** ist die Brücke zwischen Gradle und Android.

---

## Ein Stück Geschichte: Wie AGP entstanden ist

### Das Android Build System vor Gradle: Apache Ant

Android hatte früher ein **primitives Build-System** basierend auf **Apache Ant**:

```xml
<!-- build.xml - Das alte Android Build System (vorher) -->
<project>
    <target name="compile">
        <javac srcdir="src" destdir="bin/classes" />
    </target>
    <target name="package">
        <aapt ... />
        <!-- Viel manuales Setup nötig -->
    </target>
</project>
```

**Probleme mit Ant:**
- ❌ Keine Dependency-Management (keine automatischen Library-Downloads)
- ❌ Alles musste **manuell konfiguriert** werden
- ❌ Mehrere Geräte/Versionen kompilieren = viel Boilerplate-Code
- ❌ Build-Scripts waren **nicht wiederverwendbar**
- ❌ Kein eingebautes Caching → lange Build-Zeiten
- ❌ Keine Standard-Struktur erzwungen (jedes Projekt ein Unikat)

Entwickler hatten es **schwer**, weil jedes Projekt anders aufgebaut war.

### Google adoptiert Gradle (2013)

Im Jahr **2013** kündigte Google auf der **Google I/O** Konferenz an:

> "We're moving away from Ant and Maven towards Gradle"

**Warum Gradle?**

#### 1. **Gradle wurde 2007 von Hans Dockter entwickelt**

Hans Dockter ist ein deutscher Software-Ingenieur, der frustriert über die Limitierungen von Maven und Ant war. Er entwickelte **Gradle als eine Alternative**:

- Gradle = **Groovy** + **Ant** + **Ivy** (best of all worlds)
- Basierend auf **JVM** (läuft überall, wo Java läuft)
- **DSL-basiert** statt XML (viel lesbarer und flexibler)
- **Plugin-System** (beliebig erweiterbar)

#### 2. **Gradle hatte genau das, was Android brauchte**

```groovy
// Gradle ist viel eleganter als Ant/Maven XML
dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
}

tasks.register('build') {
    // Gradle-Code ist lesbar und wartbar
}
```

Im Vergleich zu Maven:
```xml
<!-- Maven war zu verbose und starr -->
<dependencies>
    <dependency>
        <groupId>androidx.appcompat</groupId>
        <artifactId>appcompat</artifactId>
        <version>1.6.1</version>
    </dependency>
</dependencies>
```

#### 3. **Gradle hat ein eingebautes Plugin-System**

Google konnte ein **Android-spezifisches Plugin** schreiben, ohne Gradle selbst zu verändern. Das ist elegant:

```groovy
// Google schrieb das Android Gradle Plugin
plugins {
    id 'com.android.application'  // ← Google's Plugin
}

// Gradle führt es automatisch aus
```

#### 4. **Build-Varianten (Build Flavors) waren einfach**

Mit Gradle konnte Google **Debug vs. Release** elegantly handhaben:

```groovy
// Das war mit Ant/Maven schmerzhaft
android {
    buildTypes {
        debug { /* Debug-Konfiguration */ }
        release { /* Release-Konfiguration */ }
    }

    flavorDimensions = ['store']
    productFlavors {
        google { /* Google Play */ }
        amazon { /* Amazon Appstore */ }
    }
}
```

Das wäre mit Ant ein **Albtraum** gewesen.

### Die Entwicklung von AGP

Nach 2013 entwickelte Google das **Android Gradle Plugin** kontinuierlich weiter:

| Jahr | Meilenstein |
|------|------------|
| 2013 | Google I/O: Gradle als neues Build-System anngekündigt |
| 2014 | AGP 1.0 released |
| 2015-2017 | Android Studio wird Standard-IDE (mit Gradle eingebaut) |
| 2019 | AGP 3.0+ mit neuer Plugin-Architektur |
| 2021 | AGP 4.2+ mit Kotlin DSL Support |
| 2023 | AGP 8.0+ (modernes Gradle 8+) |
| 2024+ | AGP 8.2-8.4 (Unterstützung Java 21 LTS) |

**Heute** ist Gradle + AGP der **de-facto Standard** für Android-Entwicklung. Keine Alternative hat sich durchgesetzt.

---

## Warum hat Google sich für Gradle entschieden? (Die Gründe)

### 1. **Flexibilität über Konvention**

Maven sagt: "Mach es so!" Gradle sagt: "Mach es so, aber wenn du es anders willst, kein Problem!"

```groovy
// Gradle ist super flexibel
android {
    sourceSets {
        main {
            java.srcDirs = ['src/main/java', 'src/extra/java']  // Beliebig konfigurierbar
        }
    }
}
```

Das war wichtig, weil Android **sehr verschiedene Projekte** hat (Smartphones, Tablets, Wearables, TV, etc.)

### 2. **Performance durch Caching und Incrementales Compiling**

Gradle hat **eingebautes Caching** und weiß, was sich geändert hat:

```
Erstes Build:   5 Sekunden (alles wird kompiliert)
Zweites Build:  0.5 Sekunden (nur geänderte Dateien)
```

Mit Ant/Maven war jedes Build immer full.

### 3. **Das Plugin-System**

Google musste nicht **Gradle verändern**, sondern nur ein **Plugin schreiben**:

```java
// Google entwickelte com.android.gradle.application Plugin
// Das Plugin hooks sich in Gradles Build-Prozess ein
// Gradle bleibt sauber und unverstellt
```

Das ist sehr elegant und wartbar.

### 4. **Dependency Management**

Mit Gradle können Libraries automatisch heruntergeladen werden:

```groovy
dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    // Gradle downloaded das automatisch von Maven Central
}
```

Mit Ant musste man Libraries **manuell** herunterladen und ins Projekt packen.

### 5. **Der richtige Zeitpunkt**

2013 war **der richtige Moment**:
- Android wurde immer komplexer (viele Versionen, Devices)
- Entwickler brauchten bessere Tools
- Gradle war reif und bewährt (seit 2007)
- Gradle hatte eine aktive Community

---

## AGP heute: Von Google + Gradle Inc.

Das Android Gradle Plugin wird heute entwickelt von:

1. **Google** – definiert die Android-Anforderungen und Release-Roadmap
2. **Gradle Inc.** – unterstützt die Infrastruktur und das Plugin-System

Diese Zusammenarbeit funktioniert:
- Google bestimmt, was Android braucht
- Gradle Inc. macht es technisch möglich

**Ergebnis:** Ein **modernes**, **wartbares**, **performantes** Build-System.

---

## Was ist das Android Gradle Plugin?

### Gradle allein ist nur ein Build-Tool

Gradle ist ein universelles Build-Tool für beliebige Projekte:
- Java-Projekte
- C++-Projekte
- Datenbank-Projekte
- beliebig viele Sprachen

Gradle selbst weiß nichts über Android!

### AGP macht Gradle zu einem Android-Build-Tool

Das **Android Gradle Plugin** ist eine **massive Erweiterung** von Gradle, die Android-spezifische Funktionen hinzufügt:

- **Android kompilieren**: Java/Kotlin Code → DEX (Android Bytecode)
- **Ressourcen verarbeiten**: aapt verarbeitet Layouts, Strings, Bilder, etc.
- **Android-spezifische Tasks**: `assembleDebug`, `assembleRelease`, `installDebug`
- **AndroidManifest verarbeiten**: Merge Manifests, Prozessoren
- **Signing & Obfuskation**: Code-Obfuskation für Release-Builds
- **Emulator-Integration**: Test-Ausführung auf Gerät/Emulator
- **Build-Varianten**: Debug vs. Release, verschiedene Flavors
- **Ressourcen-Generierung**: R.java automatisch generiert

**Kurz:** AGP transformiert generisches Gradle in einen Android-speziellen Build-Engine.

### Offizielle Quelle:
> "The Android Gradle Plugin is the official build system for Android apps."
> — [Android Developers Dokumentation](https://developer.android.com/studio/build)

---

## Wo wird AGP definiert?

AGP wird an **drei Stellen** definiert und geladen. Das ist wichtig zu verstehen:

### 1. Version konfigurieren: `init-android-sdk-project-structure.sh:31`

```bash
AGP_VERSION="8.4.0"
```

Hier wird die **Version** als Variable festgelegt. Der Script nutzt diese Variable später, wenn er die `build.gradle` Dateien generiert.

---

### 2. Plugin laden: `build.gradle` (Root-Projekt)

Nach dem Script-Aufruf sieht das so aus:

```groovy
plugins {
    id 'com.android.application' version '8.4.0' apply false
}
```

**Was passiert hier?**

- `id 'com.android.application'` = Das ist die eindeutige ID des Android Gradle Plugins
- `version '8.4.0'` = Welche Version soll geladen werden?
- `apply false` = **WICHTIG:** Lade das Plugin, aber wende es im Root-Projekt nicht an!

**Warum `apply false`?**

Im Root-Projekt brauchen wir AGP nicht. Wir brauchen es nur in den **App-Modulen** (z.B. `app/`, später vielleicht `feature_module/`). Mit `apply false` sagen wir:

> "Lade AGP, damit alle Submodule es verwenden können, aber nicht hier im Root."

---

### 3. Plugin aktivieren: `app/build.gradle`

```groovy
plugins {
    id 'com.android.application'
}
```

**Hier wird AGP tatsächlich aktiviert.**

- `id 'com.android.application'` = Nutze das Plugin
- Keine `version` angegeben, weil sie vom Root kommt (Versionsweitergabe)
- Keine `apply false` – hier wird es angewendet!

**Struktur:**
```
build.gradle (Root)
    ↓
    apply false  ← Definition (wird NICHT angewendet)

    app/build.gradle
        ↓
        plugins { id 'com.android.application' }
        ↓
        apply true (implizit) ← Wird angewendet!
```

---

## Wie wird AGP geladen?

Gradle muss wissen, **wo es AGP finden kann**.

Das wird in `settings.gradle` konfiguriert:

```groovy
pluginManagement {
    repositories {
        gradlePluginPortal()        // Standard Gradle Plugins
        google()                    // ← HIER sitzt das Android Plugin!
        mavenCentral()              // Fallback
    }
}
```

**Der Ablauf beim ersten `./gradlew build`:**

1. **Gradle liest `settings.gradle`**
   - Sieht: `pluginManagement { repositories { google() ... } }`

2. **Gradle sucht in den Repositories**
   - Sucht nach: `com.android.application` Version `8.4.0`
   - Findet es in: `google()` (Google's Maven Repository)

3. **Gradle lädt AGP herunter**
   ```
   Downloading: com.android.gradle:gradle:8.4.0
   ......10%......20%......30%...
   ```

4. **Gradle speichert AGP im Cache**
   ```
   ~/.gradle/caches/modules-2/files-2.1/com.android.tools.build/gradle/8.4.0/
   ```

   Dieser Cache ist **global** – alle deine Projekte, die AGP 8.4.0 verwenden, teilen sich diese Installation!

5. **Gradle aktiviert AGP im App-Modul**
   - Alle Android-spezifischen Tasks stehen jetzt zur Verfügung
   - R.java wird generiert
   - AndroidManifest wird verarbeitet
   - etc.

---

## Was macht AGP konkret? Der Android Build-Prozess

Wenn du `./gradlew build` aufrufst, orchestriert AGP folgende Schritte:

```
1. Source Code Analysis
   ↓
2. Java/Kotlin Kompilierung
   src/main/java/*.java → *.class (Java Bytecode)
   ↓
3. Ressourcen-Verarbeitung (aapt)
   src/main/res/ → R.java + compiled resources
   ↓
4. DEX Konversion (d8)
   *.class + *.jar → *.dex (Android Bytecode)
   ↓
5. APK Packaging
   *.dex + compiled resources + AndroidManifest.xml
   → build/outputs/apk/debug/app-debug.apk
   ↓
6. Code Signing (Debug-Zertifikat)
   APK wird signiert
   ↓
7. APK-Output
   app/build/outputs/apk/debug/app-debug.apk ← Fertig!
```

### Die AGP-Tasks

AGP definiert viele Tasks automatisch. Einige wichtige:

```bash
./gradlew assembleDebug     # Baut die Debug-APK
./gradlew assembleRelease   # Baut die Release-APK
./gradlew installDebug      # Installiert APK auf Gerät
./gradlew tasks             # Zeigt alle AGP-Tasks
```

Diese Tasks existieren **nur, weil AGP sie definiert hat**. Ohne AGP gäbe es sie nicht.

---

## AGP-Versionen & Kompatibilität

AGP ist nicht isoliert – es muss zu anderen Komponenten passen:

```
AGP 8.4.0
    ↓
    ✅ Kompatibel mit Gradle 9.2
    ✅ Kompatibel mit Java 21
    ✅ Kompatibel mit Android API 29+
    ✅ Kompatibel mit AndroidX Libraries
```

### Warum ist das wichtig?

**Szenario:** Du versuchst, AGP 8.0 mit Java 21 zu verwenden:
```
❌ Fehler: AGP 8.0 unterstützt Java 21 nicht
✅ Lösung: Update zu AGP 8.2+
```

### Kompatibilitäts-Matrix in unserem Projekt

Schau in `init-android-sdk-project-structure.sh:22-34`:

```bash
COMPILE_SDK=29
MIN_SDK=29
TARGET_SDK=29
AGP_VERSION="8.4.0"     # ← Passt zu Java 21
GRADLE_VERSION="9.2"    # ← Passt zu AGP 8.4.0
```

**Diese Versionen sind nicht willkürlich gewählt – sie sind tested und kompatibel!**

### Wenn du AGP aktualisieren möchtest:

1. Ändere `AGP_VERSION` im Script
2. Prüfe Kompatibilität auf [Android Developers](https://developer.android.com/studio/releases/gradle-plugin)
3. Teste den Build
4. Aktualisiere auch `GRADLE_VERSION` falls nötig

---
