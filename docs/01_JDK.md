
-----

# 🚀 JDK 21 Installation für Android-Entwicklung (Arch Linux)

## 📋 Übersicht

Für die **Android-Entwicklung** auf **Arch Linux** empfehlen wir die Verwendung von **OpenJDK 21** (eine LTS-Version, unterstützt bis 2031).

  * ✅ Unterstützt moderne **Android Gradle Plugin** (AGP) Versionen.
  * ✅ Abwärtskompatibel mit bestehendem JDK 17 Code.
  * ✅ Gewährleistet problemlosen Support für Android 7+ Geräte.

-----

## 🛠️ Installation auf Arch Linux

### OpenJDK 21 installieren

Das Paket `jdk-openjdk` installiert automatisch die neueste LTS-Version, welche derzeit **OpenJDK 21** ist, und registriert es als Standard-Java-Umgebung.

```bash
# OpenJDK 21 installieren (wird als "jdk-openjdk" bereitgestellt)
sudo pacman -S jdk-openjdk
```

### Optional: JDK 17 als Fallback

Falls Sie eine alternative Version für spezielle Kompatibilitätsanforderungen benötigen, können Sie JDK 17 als Fallback installieren:

```bash
sudo pacman -S jdk17-openjdk
```

-----

## 🔄 Mehrere JDK-Versionen verwalten

Arch Linux verwendet das `archlinux-java`-Tool, um zwischen verschiedenen installierten Java-Versionen zu wechseln.

### Verfügbare Versionen anzeigen

Zeigen Sie alle auf Ihrem System installierten Java-Umgebungen an und prüfen Sie, welche Version aktuell aktiv ist:

```bash
archlinux-java status
```

> **Beispiel-Ausgabe**:
>
> ```
> Available Java environments:
>  java-21-openjdk (default)
>  java-17-openjdk
> ```

### Die Standard-Java-Version wechseln

Verwenden Sie den Befehl `archlinux-java set`, um die globale Standard-Java-Installation zu ändern.

```bash
# Beispiel: Temporär auf JDK 17 wechseln
sudo archlinux-java set java-17-openjdk

# Zurück zur empfohlenen Version JDK 21 wechseln
sudo archlinux-java set java-21-openjdk
```

-----

## ⚙️ Umgebungsvariablen konfigurieren: $JAVA\_HOME

Das `archlinux-java`-Tool setzt die wichtige Umgebungsvariable `JAVA_HOME` **nicht** automatisch. Diese muss manuell in Ihrer Shell-Konfigurationsdatei (`.bashrc`, `.zshrc`, etc.) eingerichtet werden.

### Aktuellen Java-Pfad ermitteln

Der Pfad wird auf den Standard-Symlink (`/usr/lib/jvm/default`) verweisen, der durch `archlinux-java` gesetzt wird.

```bash
# Methode 1: Über das Symlink
readlink -f /usr/lib/jvm/default

# Methode 2: Mit archlinux-java (zeigt den Namen der Umgebung)
java_env=$(archlinux-java get)
echo /usr/lib/jvm/$java_env
```

### $JAVA\_HOME persistent setzen

Fügen Sie die folgenden Zeilen zu Ihrer Shell-Konfigurationsdatei hinzu (z.B. `~/.bashrc` oder `~/.zshrc`), um `JAVA_HOME` auch nach einem Neustart verfügbar zu machen.

**Für Bash (`~/.bashrc`):**

```bash
export JAVA_HOME=$(readlink -f /usr/lib/jvm/default)
export PATH=$PATH:$JAVA_HOME/bin
```

Nach dem Hinzufügen müssen Sie die Konfigurationsdatei neu laden:

```bash
source ~/.bashrc
```

> **Wichtig**: Nur das Setzen der Variable in der aktuellen Terminal-Session (ohne die Konfigurationsdatei) geht beim Schließen des Terminals verloren.

-----

## ✅ Installation verifizieren

Prüfen Sie, ob die korrekte Version aktiv ist und `JAVA_HOME` richtig gesetzt wurde.

| Befehl | Zweck | Erwartete Ausgabe (Beispiel) |
| :--- | :--- | :--- |
| `java -version` | Prüft die Runtime-Version (JRE) | `openjdk version "21.0.x" ...` |
| `javac -version` | Prüft die Compiler-Version | `javac 21.0.x` |
| `echo $JAVA_HOME` | Prüft die Umgebungsvariable | `/usr/lib/jvm/java-21-openjdk` |

Wenn alle Befehle die erwarteten Ergebnisse liefern, ist Ihre Umgebung erfolgreich für die Android-Entwicklung eingerichtet\!

-----
