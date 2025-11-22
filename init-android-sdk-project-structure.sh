#!/bin/bash

# =============================================================================
# Java Android Project Scaffolder (CLI only)
# =============================================================================

set -e

# Argumente prüfen (wie zuvor)
if [ "$#" -ne 2 ]; then
    echo "❌ Fehler: Falsche Anzahl an Argumenten."
    echo "Nutzung: $0 [ProjektName] [PackageName]"
    exit 1
fi

APP_NAME=$1
PACKAGE_NAME=$2
# Ersetzt Punkte durch Slashes für den Ordnerpfad (com.x.y -> com/x/y)
PACKAGE_PATH="${PACKAGE_NAME//.//}" 

# Konfigurations-Variablen
COMPILE_SDK=29
MIN_SDK=29
TARGET_SDK=29
# AGP = Android Gradle Plugin: Das ist das offizielle Plugin von Google, das Gradle um Android-spezifische Features erweitert
# AGP-Version sollte nach der verfügbaren Java SDK Version ausgewählt werden!
# Da wir Java 21 haben: AGP 8.2.2+ funktioniert sehr gut mit Java 21
# Nicht alle AGP-Versionen funktionieren mit allen Gradle-Versionen!
# Kompatibilität prüfen unter: https://developer.android.com/build/gradle-plugin-migration
# AGP 8.2.2 ist kompatibel mit Gradle 8.7 (LTS)
AGP_VERSION="8.4.0"
# Gradle = Das eigentliche Build-Tool (von Gradle Inc.)
# Der Wrapper ermöglicht es, dass alle Entwickler die gleiche Gradle-Version nutzen
GRADLE_VERSION="9.2"

# Erkenne aktive Java-Version automatisch
detect_java_version() {
    if ! command -v java &> /dev/null; then
        echo "❌ Fehler: Java nicht installiert oder nicht in PATH"
        exit 1
    fi

    java -version 2>&1 | grep -oP '(?<=version ")[^"]*' | cut -d. -f1
}

JAVA_VERSION=$(detect_java_version)
JAVA_CLASS_VERSION="VERSION_${JAVA_VERSION}"

echo "🚀 Starte Java Android-Projekt Generierung für '$APP_NAME'..."
echo "☕ Erkannte Java-Version: $JAVA_VERSION"
echo ""

echo "📁 Erstelle Projekt-Struktur..."
echo "   \$ mkdir -p $APP_NAME"
mkdir -p "$APP_NAME"
echo "   \$ cd $APP_NAME"
cd "$APP_NAME"
echo "   \$ mkdir -p gradle/wrapper"
mkdir -p gradle/wrapper
echo "   \$ mkdir -p app/src/main/java/$PACKAGE_PATH"
mkdir -p app/src/main/java/$PACKAGE_PATH
echo "   \$ mkdir -p app/src/main/res/{layout,values,drawable,mipmap-hdpi,xml}"
mkdir -p app/src/main/res/{layout,values,drawable,mipmap-hdpi,xml}
echo ""

# 1. .gitignore & settings.gradle
echo "📝 Erstelle .gitignore..."
echo "   \$ cat > .gitignore"
cat > .gitignore <<EOF
# Gradle build directories
.gradle/ # Gradle Cache (wird beim build erstellt)
/build/ # Build-Ordner (wird im Projekt-Hauptordner erstellt)
/app/build/ # Build-Ordner (wird im app-Modul-Ordner erstellt)

# Gradle properties
/local.properties # Systembezogene Gradle Konfiguration (Umgebungsspezifisch, jeder Dev/Rechner muss seine eigene Config konfigurieren)
EOF

echo "📝 Erstelle settings.gradle..."
echo "   \$ cat > settings.gradle"
cat > settings.gradle <<EOF
// ============================================================================
// pluginManagement = Verwaltet, WOHER Gradle seine Plugins (z.B. AGP) lädt
// ============================================================================
pluginManagement {
    repositories {
        // gradlePluginPortal() = Das Standard-Registry für Gradle Plugins
        //   - Hier sind offizielle Gradle Plugins registriert
        //   - Z.B. com.gradle.*, org.gradle.* Plugins
        //   - WICHTIG: Enthält aber NICHT das Android Gradle Plugin!
        gradlePluginPortal()

        // google() = Google's Maven Repository für Android-spezifische Plugins/Libraries
        //   - MUSS sein, damit Gradle das 'com.android.application' Plugin findet
        //   - Enthält auch AndroidX Libraries, Material Design Components, etc.
        //   - Ohne google() => "Plugin was not found" Fehler!
        google()

        // mavenCentral() = Das größte Open-Source Java Library Repository
        //   - Fallback für Plugins, die nicht bei Google oder Gradle Portal sind
        //   - Meist nicht nötig für AGP, aber Good Practice für Dependencies
        mavenCentral()
    }
}

// ============================================================================
// dependencyResolutionManagement = Verwaltet, WOHER Gradle seine Libraries lädt
// ============================================================================
dependencyResolutionManagement {
    // repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    // = STRENG: Nur diese Repositories verwenden, keine anderen erlaubt
    // = Verhindert Fehler durch unterschiedliche Repos in verschiedenen Modulen
    // = Alle Dependencies (z.B. androidx.appcompat) müssen aus diesen Repos kommen
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)

    repositories {
        // Same Repositories wie oben - müssen hier wiederholt werden
        google()   // Für AndroidX, Material Design, Google Libraries
        mavenCentral()  // Für Standard Java Libraries
    }
}

rootProject.name = "$APP_NAME"
include ':app'
EOF

# 2. build.gradle (Projekt-Hauptordner) - NUR Android Plugin Definition
echo "📝 Erstelle build.gradle (Root)..."
echo "   \$ cat > build.gradle"
cat > build.gradle <<EOF
plugins {
    id 'com.android.application' version '$AGP_VERSION' apply false
}
EOF

# 3. app/build.gradle (im app-Modul-Ordner) - App Konfiguration - MINIMAL
echo "📝 Erstelle app/build.gradle..."
echo "   \$ cat > app/build.gradle"
cat > app/build.gradle <<EOF
plugins {
    id 'com.android.application'
}

android {
    namespace = '$PACKAGE_NAME'
    compileSdk = $COMPILE_SDK

    defaultConfig {
        applicationId = "$PACKAGE_NAME"
        minSdk = $MIN_SDK
        targetSdk = $TARGET_SDK
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.$JAVA_CLASS_VERSION
        targetCompatibility = JavaVersion.$JAVA_CLASS_VERSION
    }
}

dependencies {
    // AppCompatActivity wird in unserem App Entry Point verwendet (MainActivity.java)
    // Die Dependency ist minimal notwendig für eine funktionsfähige App
    // Es ist eine Google-Best-Practice für Android-Entwicklung
    // Es bietet Rückwärts-Kompatibilität für ältere Android-Versionen
    // https://developer.android.com/reference/androidx/appcompat/app/AppCompatActivity
    //
    // Wie funktioniert ein Dependency:
    // implementation 'androidx.appcompat:appcompat:1.6.1'
    //     ↓
    // Gradle sagt: "Besorge mir diese Library und füge sie in mein Projekt ein"
    //     ↓
    // Gradle lädt die Library herunter (von Maven Central Repository)
    //     ↓
    // AGP nutzt die Library beim Kompilieren der App
    //
    // Hinweis: Die Library-Version muss passen zu:
    // unserem AGP 8.2.2, Gradle 8.7, Java 21 und minSdk 24
    // Kompatibilität auf mvnrepository.com checken bevor updaten!

    implementation 'androidx.appcompat:appcompat:1.6.1'
}
EOF

# 4. AndroidManifest.xml - MINIMAL VERSION
# Dies ist die minimale AndroidManifest.xml für eine funktionsfähige App
# Sie definiert nur das Notwendigste: Paketname, App-Label und MainActivity als Entry Point
# Weitere Details (Permissions, Features, etc.) werden später in der Dokumentation behandelt
echo "📝 Erstelle app/src/main/AndroidManifest.xml..."
echo "   \$ cat > app/src/main/AndroidManifest.xml"
cat > app/src/main/AndroidManifest.xml <<EOF
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application android:label="@string/app_name">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

# 5. Ressourcen-Dateien - z.B strings.xml (MINIMAL)
# Das sind die Ressourcen-Dateien der App. Hier wird alles gelagert, das nicht Code ist.
#
# strings.xml - String-Ressourcen
# Das speichert Texte/Strings, die in der App verwendet werden:
# - app_name = Der Name der App (wird im Manifest und in der UI angezeigt)
# - Statt android:label="MyApp" nutzt man android:label="@string/app_name"
#
# Vorteile:
# - Du kannst den Text zentral ändern
# - Mehrsprachigkeit später einfach (z.B. strings_de.xml für Deutsch, strings_en.xml für Englisch)
echo "📝 Erstelle app/src/main/res/values/strings.xml..."
echo "   \$ cat > app/src/main/res/values/strings.xml"
cat > app/src/main/res/values/strings.xml <<EOF
<resources>
    <string name="app_name">$APP_NAME</string>
</resources>
EOF
# ... weitere Ressourcen hier einfügen ...

# 6. MainActivity.java erstellen
# MainActivity ist der Startbildschirm deiner App (der erste Bildschirm, den der Nutzer sieht)
# Die Datei wird im package-Ordner erstellt (z.B. com/example/myapp/MainActivity.java)
echo "📝 Erstelle app/src/main/java/$PACKAGE_PATH/MainActivity.java..."
echo "   \$ cat > app/src/main/java/$PACKAGE_PATH/MainActivity.java"
cat > app/src/main/java/$PACKAGE_PATH/MainActivity.java <<EOF
package $PACKAGE_NAME;

// AppCompatActivity ist eine Basis-Klasse von Google
// Sie macht die App auf älteren Android-Versionen kompatibel und bietet Material Design
import androidx.appcompat.app.AppCompatActivity;

// Bundle wird für Daten verwendet (z.B. wenn die App neu startet)
import android.os.Bundle;

// TextView ist ein UI-Element für Text-Anzeige
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    @Override
    // onCreate() wird aufgerufen, wenn diese Activity gestartet wird
    // super.onCreate() ist wichtig - es muss immer als Erstes aufgerufen werden
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Erstelle einen TextView direkt im Code
        TextView textView = new TextView(this);
        textView.setText("Hello World!");

        // setContentView() zeigt den TextView auf dem Bildschirm
        setContentView(textView);
    }
}
EOF

# 7. Gradle Wrapper einrichten
# Der Gradle Wrapper ermöglicht es, dass alle Entwickler die gleiche Gradle-Version nutzen
# Dadurch funktioniert der Build auf jedem Computer gleich
echo ""
echo "🐘 Richte Gradle Wrapper ein (Version $GRADLE_VERSION)..."
echo "   \$ gradle wrapper --gradle-version $GRADLE_VERSION --warning-mode all"
gradle wrapper --gradle-version "$GRADLE_VERSION" --warning-mode all

echo ""
echo "✅ Projekt '$APP_NAME' erfolgreich mit Java erstellt!"
