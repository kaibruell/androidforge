# Android Projekt-Struktur verstehen

## Warum ist die Android Projekt-Struktur so streng?

Android hat eine **strikte Projekt-Struktur**. Das ist nicht willkürlich - es gibt konkrete Gründe.

### Mit Android Studio (Der Konventionelle Weg)

Wenn du **Android Studio** verwendest, wird die Projekt-Struktur **automatisch erstellt**:

> "When you start a new project, Android Studio creates the necessary structure for all your files and makes them visible in the Project window in Android Studio."
> — [Offizielle Android Developer Dokumentation](https://developer.android.com/studio/projects)

Die IDE erstellt also alle Ordner, Dateien und Konfigurationen für dich.

### Ohne IDE (Unser Ansatz)

Wir arbeiten **ohne IDE** – mit Command-Line Tools und Text-Editor. Das bedeutet:
- **Wir müssen die Struktur SELBST erstellen und verstehen**
- **Dieses Verständnis ist fundamental für unseren Ansatz**

**Hinweis:** Du wirst später ein Tool namens **Gradle** kennenlernen (ein Build-System von Hans Dockter welches Google für Android Entwicklung nutzt (durch das Android Gradle Plugin). Es baut auf build-system auf). Diese Projekt-Struktur ist wichtig, weil Gradle diese Standards erwartet.

### 1. Android definiert eine Standard-Projekt-Struktur

Google und die Android-Community haben sich auf eine **einheitliche Struktur** geeinigt:
- Java Code geht in `src/main/java/`
- Android Ressourcen gehen in `src/main/res/`
- AndroidManifest.xml liegt in `src/main/`
- Tests gehen in `src/test/` und `src/androidTest/`

Diese Konvention ist dokumentiert in der offiziellen Android Developer Dokumentation

### 2. Warum brauchen wir diese Standard-Struktur?

Mit einer einheitlichen Struktur können Tools (wie das spätere Build-System Gradle) automatisch wissen:
- Wo ist der Code? → suche in `src/main/java/`
- Wo sind die Ressourcen? → suche in `src/main/res/`
- Wo ist das Manifest? → suche in `src/main/`

Wenn jedes Projekt eine andere Struktur hätte, müsste jedes Projekt separat konfiguriert werden. Mit der Standard-Struktur funktioniert alles "automatisch".

### 3. Build Tools brauchen klare Strukturen

Die **Build Tools** unter der Haube von Gradle (d8, aapt, etc.) müssen wissen:
- Wo ist der Quellcode? → `src/main/java/`
- Wo sind Ressourcen? → `src/main/res/`
- Wo ist das Manifest? → `src/main/AndroidManifest.xml`

Die Struktur ermöglicht es, dass der Build-Prozess **reproduzierbar** ist.

### 4. Multiple Build-Varianten (Debug, Release, etc.)

Mit dieser Struktur kannst du verschiedene Versionen bauen:
```
src/main/        ← Code für beide Versionen
src/debug/       ← Nur für Debug-Build
src/release/     ← Nur für Release-Build
src/test/        ← Unit-Tests
src/androidTest/ ← Instrumentierte Tests (auf Gerät)
```

---

## Die Standard Android Projekt-Struktur

### Vollständige Struktur

```
MyApp/                                    # Projekt Root
├── app/                                  # App-Modul (Hauptprogramm)
│   ├── src/
│   │   ├── main/                         # Hauptprogramm (Debug + Release)
│   │   │   ├── java/                     # Java/Kotlin Quellcode
│   │   │   │   └── com/example/myapp/
│   │   │   │       ├── MainActivity.java
│   │   │   │       └── Utils.java
│   │   │   │
│   │   │   ├── res/                      # Android Ressourcen
│   │   │   │   ├── layout/               # UI Layout XML
│   │   │   │   │   ├── activity_main.xml
│   │   │   │   │   └── activity_settings.xml
│   │   │   │   │
│   │   │   │   ├── values/               # Konstanten (Strings, Colors, etc.)
│   │   │   │   │   ├── strings.xml       # Text-Konstanten
│   │   │   │   │   ├── colors.xml        # Farben
│   │   │   │   │   └── styles.xml        # UI-Stile
│   │   │   │   │
│   │   │   │   ├── drawable/             # Bilder und Grafiken
│   │   │   │   │   ├── ic_launcher.png
│   │   │   │   │   └── background.xml
│   │   │   │   │
│   │   │   │   ├── menu/                 # Menü-Definitionen
│   │   │   │   │   └── menu_main.xml
│   │   │   │   │
│   │   │   │   └── mipmap/               # App-Icons (verschiedene Auflösungen)
│   │   │   │       ├── ic_launcher_round.png
│   │   │   │       └── ic_launcher_foreground.png
│   │   │   │
│   │   │   └── AndroidManifest.xml       # App-Manifest (wichtigste Datei!)
│   │   │
│   │   ├── debug/                        # Debug-spezifisch
│   │   │   ├── java/
│   │   │   ├── res/
│   │   │   └── AndroidManifest.xml       # Optional: Debug-spezifisches Manifest
│   │   │
│   │   ├── release/                      # Release-spezifisch
│   │   │   ├── java/
│   │   │   ├── res/
│   │   │   └── AndroidManifest.xml       # Optional: Release-spezifisches Manifest
│   │   │
│   │   ├── test/                         # Unit-Tests (nicht auf Gerät)
│   │   │   └── java/
│   │   │       └── com/example/myapp/
│   │   │           └── MainActivityTest.java
│   │   │
│   │   └── androidTest/                  # Instrumented Tests (auf Gerät)
│   │       └── java/
│   │           └── com/example/myapp/
│   │               └── MainActivityInstrumentedTest.java
│   │
│   ├── build/                            # Build-Output (AUTO-GENERATED)
│   │   ├── intermediates/
│   │   ├── outputs/
│   │   │   └── apk/
│   │   │       ├── debug/
│   │   │       │   └── app-debug.apk
│   │   │       └── release/
│   │   │           └── app-release-unsigned.apk
│   │   └── ...
│   │
│   ├── build.gradle                      # App-Modul Konfiguration
│   ├── proguard-rules.pro                # Code-Obfuskation (nur Release)
│   └── libs/                             # Lokale JAR-Dependencies (optional)
│       └── custom-library.jar
│
├── gradle/                               # Gradle Wrapper
│   └── wrapper/
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
│
├── build.gradle                          # Root Projekt Konfiguration
├── settings.gradle                       # Projekt-Einstellungen (Module)
├── gradlew                               # Gradle Wrapper (Linux/Mac)
├── gradlew.bat                           # Gradle Wrapper (Windows)
├── .gitignore                            # Git Ignorieren
└── README.md                             # Projekt-Dokumentation
```

---

## Detaillierte Erklärung jeder Komponente

### src/ - Quellcode und Ressourcen

Das `src/` Verzeichnis ist das **Herzstück** des Projekts. Android erwartet diese Struktur:

```
src/
├── main/     ← Wird immer kompiliert (Hauptprogramm)
├── debug/    ← Nur für Debug-Build
├── release/  ← Nur für Release-Build
├── test/     ← Unit-Tests
└── androidTest/  ← Tests auf echtem Gerät
```

---

### src/main/java/ - Quellcode

```
src/main/java/
└── com/example/myapp/      # Package-Name (WICHTIG!)
    ├── MainActivity.java     # Activities
    ├── LoginActivity.java
    ├── Utils.java            # Utility-Klassen
    ├── adapter/              # Sub-packages für Organisation
    │   ├── UserAdapter.java
    │   └── ItemAdapter.java
    ├── model/
    │   ├── User.java
    │   └── Post.java
    └── network/
        ├── ApiClient.java
        └── ApiService.java
```

**Wichtig:** Der Package-Name muss mit der `applicationId` in `build.gradle` übereinstimmen!

```gradle
android {
    defaultConfig {
        applicationId "com.example.myapp"  ← Muss passen!
    }
}
```

**Warum?** Android kennt deine App über die `applicationId`. Der Package-Name ist die eindeutige Identifier.

---

### src/main/res/ - Ressourcen

Ressourcen sind **alles außer Code**: Layouts, Bilder, Strings, Farben, etc.

#### res/layout/ - UI Layouts (XML)

```xml
<!-- activity_main.xml -->
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">

    <TextView
        android:id="@+id/textView"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/app_name" />

</LinearLayout>
```

**Warum ist das organisiert?**
- `aapt` (Android Asset Packaging Tool) sucht Layouts im `res/layout/` Verzeichnis
- Wenn du deine Layout-Datei woanders ablegen würdest, weiß Gradle nicht, dass es eine Ressource ist

#### res/values/ - Konstanten und Strings

```xml
<!-- strings.xml -->
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">My App</string>
    <string name="hello">Hello World!</string>
    <string name="button_submit">Submit</string>
</resources>
```

```xml
<!-- colors.xml -->
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="primary">#FF6200EE</color>
    <color name="secondary">#FF03DAC5</color>
</resources>
```

```xml
<!-- styles.xml -->
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="AppTheme" parent="Theme.AppCompat.Light">
        <item name="colorPrimary">@color/primary</item>
        <item name="colorSecondary">@color/secondary</item>
    </style>
</resources>
```

**Warum strings.xml?**
- Strings sind zentral in einer Datei → einfacher zu pflegen
- Ermöglicht Lokalisierung (strings-de.xml für Deutsch, strings-es.xml für Spanisch)
- Verhindert hartcodierte Strings im Code (Best Practice)

**Offizielle Quelle:** [App Resources - Strings](https://developer.android.com/guide/topics/resources/string-resource)

#### res/drawable/ - Bilder und Grafiken

```
res/drawable/
├── ic_launcher.png          # PNG-Bild
├── ic_menu_home.png
├── ic_menu_settings.png
├── background.xml           # Drawable als XML (Vektor-Grafik)
└── button_background.xml    # Gradient, Shape, etc.
```

**drawable vs. mipmap?**
- `drawable/`: Allgemeine Bilder (Icons, Grafiken, Hintergründe)
- `mipmap/`: App-Icons (werden speziell vom Launcher verwendet)

#### res/mipmap/ - App-Icons

```
res/mipmap-ldpi/     ← Low Density (alte Geräte, 120dpi)
res/mipmap-mdpi/     ← Medium Density (normal, 160dpi)
res/mipmap-hdpi/     ← High Density (besser, 240dpi)
res/mipmap-xhdpi/    ← Extra High (noch besser, 320dpi)
res/mipmap-xxhdpi/   ← Very High (sehr gut, 480dpi)
res/mipmap-xxxhdpi/  ← Ultra High (sehr gut, 640dpi)
```

**Warum verschiedene Auflösungen?**
- Alte Geräte haben 160dpi (niedrig)
- Neue Smartphones haben 480-640dpi (hoch)
- Android wählt das beste Icon für die Geräte-Auflösung
- Eine PNG-Datei würde auf alten Geräten pixelig aussehen oder auf neuen Geräten zu klein sein

**Offizielle Quelle:** [App Resources - Providing Multiple Screen Densities](https://developer.android.com/training/multiscreen/screendensities)

---

### AndroidManifest.xml - Die wichtigste Datei

Die `AndroidManifest.xml` ist das **Herzstück** jeder Android-App. Sie definiert:
- Was die App ist
- Welche Activities, Services, etc. sie hat
- Welche Permissions sie braucht
- Welche Android-Version sie unterstützt

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.myapp">

    <!-- Permissions die die App braucht -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

    <!-- App-Konfiguration -->
    <application
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher"
        android:theme="@style/AppTheme">

        <!-- Activities (Bildschirme) -->
        <activity android:name=".MainActivity"
            android:exported="true">
            <!-- Intent Filter = "Das ist der Startpunkt der App" -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <activity android:name=".SettingsActivity" />
        <activity android:name=".LoginActivity" />

        <!-- Services (Hintergrund-Prozesse) -->
        <service android:name=".MyBackgroundService" />

        <!-- Broadcast Receiver -->
        <receiver android:name=".MyBroadcastReceiver" />

    </application>

</manifest>
```

**Warum ist das wichtig?**
- Android liest diese Datei beim Install
- Sie teilt Android mit: "Hier sind alle Komponenten dieser App"
- Ohne Manifest kann die App nicht installiert werden
- `aapt` (Build Tools) verarbeitet diese Datei und packt sie in die APK

**Offizielle Quelle:** [Android Manifest Overview](https://developer.android.com/guide/topics/manifest/manifest-intro)

---

### build/ - Build-Output (NICHT manuell bearbeiten!)

Das `build/` Verzeichnis ist **auto-generated** von Gradle:

```
build/
├── intermediates/     ← Zwischenprodukte (kompilierter Code, DEX, etc.)
├── outputs/          ← Finale APK
│   └── apk/
│       ├── debug/
│       │   └── app-debug.apk         ← Diese installierst du auf dein Gerät!
│       └── release/
│           └── app-release-unsigned.apk
└── ...
```

**Wichtig:** Dieses Verzeichnis gehört in `.gitignore` - du commitest das nicht!

---

## Wie passt die Struktur zum Build-Prozess?

### Der Build-Prozess nutzt diese Struktur:

```
1. Gradle startet
   ↓
2. Liest app/build.gradle
   ↓
3. Sucht Java-Code in src/main/java/
   → Kompiliert mit javac → .class Dateien
   ↓
4. Sucht Ressourcen in src/main/res/
   → Verarbeitet mit aapt → R.java (Auto-generated!)
   ↓
5. Konvertiert .class zu DEX (mit d8)
   ↓
6. Packt alles in APK:
   - Code (DEX)
   - Ressourcen (res/)
   - AndroidManifest.xml
   ↓
7. Signiert die APK
   ↓
8. Output: app/build/outputs/apk/debug/app-debug.apk
```

**Was passiert, wenn die Struktur falsch ist?**

```
❌ Falsch: src/java/MainActivity.java
Gradle sucht in src/main/java/ → NICHT GEFUNDEN → Kompilierung schlägt fehl

❌ Falsch: res/layouts/activity_main.xml
Gradle sucht in src/main/res/layout/ → NICHT GEFUNDEN → Ressource wird ignoriert

✅ Richtig: src/main/java/com/example/myapp/MainActivity.java
✅ Richtig: src/main/res/layout/activity_main.xml
```

---

## Die R.java Datei - Auto-Generated!

**Das ist wichtig zu verstehen:**

Android generiert automatisch die `R.java` Datei basierend auf deine Ressourcen:

```java
// Auto-generated by Android Build Tools
public final class R {
    public static final class layout {
        public static final int activity_main = 0x7f030001;
        public static final int activity_settings = 0x7f030002;
    }

    public static final class string {
        public static final int app_name = 0x7f040000;
        public static final int hello = 0x7f040001;
    }

    public static final class drawable {
        public static final int ic_launcher = 0x7f020000;
    }
}
```

In deinem Code nutzt du das so:

```java
public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);  ← Nutzt R.java!

        TextView textView = findViewById(R.id.textView);
        textView.setText(R.string.hello);  ← Auch hier!
    }
}
```

**Warum ist das cool?**
- Keine hartcodierten Strings
- Type-safe (der Compiler prüft, ob die Ressource existiert)
- Wenn du eine Ressource änderst, wird R.java automatisch aktualisiert

---

## Zusammenfassung: Warum diese strikte Struktur?

| Grund | Erklärung |
|-------|-----------|
| **Android Gradle Plugin** | Definiert diese Struktur als Standard |
| **Build Tools** | Suchen Dateien an vordefinierten Orten |
| **Reproduzierbarkeit** | Jeder Entwickler hat die gleiche Struktur |
| **Automation** | Gradle kann ohne Konfiguration arbeiten |
| **Best Practices** | Google empfiehlt diese Struktur |
| **Tooling** | IDEs, Linters, etc. erwarten diese Struktur |

---

---

## Automatisierung: init-android-sdk-project-structure.sh

Anstatt die gesamte Projekt-Struktur manuell zu erstellen, steht Ihnen das Shell-Script `init-android-sdk-project-structure.sh` zur Verfügung.

### Warum das Script verwenden?

Das Script dient als:
1. **Automatisierung** - Erstellt die komplette Struktur mit einem Befehl
2. **Lebendige Dokumentation** - Der Code zeigt exakt, wie jede Datei erstellt wird
3. **Anpassbare Grundlage** - Kann nach Bedarf erweitert werden

### Script verwenden

```bash
# Syntax
./init-android-sdk-project-structure.sh [ProjektName] [PackageName]

# Beispiel
./init-android-sdk-project-structure.sh MyApp com.example.myapp
```

Das Script erstellt automatisch:
- Projekt-Verzeichnisstruktur (`app/src/main/java/`, `res/`, etc.)
- Alle Konfigurationsdateien (`build.gradle`, `settings.gradle`, `.gitignore`)
- `AndroidManifest.xml`
- `MainActivity.java`
- `strings.xml`
- Gradle Wrapper

### Script als Dokumentation

**Wichtig:** Das Script ist nicht nur ein Tool, sondern auch eine Referenz. Öffnen Sie es und lesen Sie die Kommentare - es erklärt jeden Schritt und jede Konfiguration im Detail. Es erstellt die **MINIMALE** Projektstruktur und Konfiguration. 

```bash
# Script anschauen
cat init-android-sdk-project-structure.sh
```

Alle Werte (AGP-Version, Gradle-Version, SDK-Versionen, Java-Version) sind dort dokumentiert und konfigurierbar.

---
