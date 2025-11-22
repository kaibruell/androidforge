# JDK 21 Installation für Android-Entwicklung (Arch Linux)

## Übersicht

Für Android-Entwicklung auf **Arch Linux** empfehlen wir **OpenJDK 21** (LTS bis 2031).

- ✅ Unterstützt moderne Android Gradle Plugin Versionen
- ✅ Abwärtskompatibel mit JDK 17 Code
- ✅ Ermöglicht Android 7+ Support ohne Probleme

---

## Installation auf Arch Linux

### OpenJDK 21 installieren

```bash
# OpenJDK 21 installieren
sudo pacman -S jdk-openjdk
```

Das Paket `jdk-openjdk` installiert automatisch OpenJDK 21 und registriert es als Standard-Java-Installation.

### Optional: JDK 17 als Fallback

Falls Sie ein Fallback benötigen:

```bash
sudo pacman -S jdk17-openjdk
```

---

## Mehrere JDK-Versionen verwalten

### Verfügbare Versionen anzeigen

```bash
archlinux-java status
```

Diese Ausgabe zeigt alle auf dem System installierten Java-Versionen an und markiert die aktuell aktive Version.

**Beispiel-Ausgabe**:
```
Available Java environments:
  java-21-openjdk (default)
  java-17-openjdk
```

### Die Standard-Java-Version wechseln

```bash
# Beispiel: auf JDK 17 wechseln
sudo archlinux-java set java-17-openjdk

# Zurück zu JDK 21
sudo archlinux-java set java-21-openjdk
```

Der Befehl `archlinux-java set` ändert die globale Standard-Java-Installation. Dies betrifft alle Programme auf Ihrem System, die Java verwenden.

---

## Umgebungsvariablen konfigurieren

`JAVA_HOME` wird durch `archlinux-java` **nicht** automatisch gesetzt. Sie müssen dies manuell in Ihrer Shell-Konfiguration tun.

Den aktuellen Java-Pfad ermitteln Sie mit:

```bash
# Methode 1: Über das symlink
readlink -f /usr/lib/jvm/default

# Methode 2: Mit archlinux-java
java_env=$(archlinux-java get)
echo /usr/lib/jvm/$java_env
```

Um `JAVA_HOME` persistent zu setzen (auch nach Neustart), fügen Sie folgende Zeilen zu Ihrer Shell-Konfiguration hinzu:

**Für Bash** (`~/.bashrc`):
```bash
export JAVA_HOME=$(readlink -f /usr/lib/jvm/default)
export PATH=$PATH:$JAVA_HOME/bin
```

Nach dem Hinzufügen:
```bash
source ~/.bashrc
```

**Für andere Shells** (Zsh, Fish, etc.):
Bitte suchen Sie online nach der korrekten Syntax für Ihre Shell (z.B. "Zsh .zshrc environment variables" oder "Fish config.fish export").

**Hinweis**: Wenn Sie nur `export JAVA_HOME=...` in der aktuellen Terminal-Session eingeben, ist es nicht persistent und geht beim Schließen des Terminals verloren.

---

## Installation verifizieren

```bash
# Java-Version prüfen
java -version

# Erwartete Ausgabe:
# openjdk version "21.0.x" 2024-xx-xx
# OpenJDK Runtime Environment (build 21.0.x+xx)
# OpenJDK 64-Bit Server VM (build 21.0.x+xx, mixed mode)

# Java-Compiler prüfen
javac -version

# Erwartete Ausgabe:
# javac 21.0.x

# JAVA_HOME prüfen
echo $JAVA_HOME

# Erwartete Ausgabe:
# /usr/lib/jvm/java-21-openjdk (oder ähnlich)
```

---
