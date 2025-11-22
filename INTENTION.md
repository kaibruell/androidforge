# Intention 

## Philosophie dieses Projekts

Dieses Projekt **verzichtet bewusst auf IDEs** wie Android Studio und setzt auf **Command-Line basierte Entwicklung** mit modernen Text-Editoren (z.B. Neovim/nvim).

---

## Warum kein Android Studio?

### ❌ Probleme mit IDEs

**Android Studio Nachteile:**
- Zu viele Knöpfe, Menüs und versteckte Funktionen
- "Black Box" - man weiß nicht, was unter der Haube passiert
- Schwer, fundamentale Konzepte zu verstehen
- Viel zu schwer für Anfänger, zu viel Overhead
- Zwingt dich in einen bestimmten Workflow
- Ressourcen-Hunger (RAM, CPU)

### ✅ Command-Line Vorteile

**Command-Line Entwicklung:**
- Volle Kontrolle und Verständnis über jeden Schritt
- Transparenz - du siehst genau was passiert
- Flexibilität - du nutzt deine liebsten Tools (nvim, Bash, etc.)
- Leichtgewichtig - kein IDE-Overhead
- Besseres Verständnis der Android-Architektur
- Reproduzierbar und skriptbar
- Besseres Lernen - nicht blind copy-paste

---

## Unser Ansatz

### 1. **Verstehen statt Copy-Paste**

Jede Dokumentation erklärt **WARUM** wir etwas tun, nicht nur **WIE**:
- Wozu dient ein Tool?
- Wie funktioniert es intern?
- Welche Entscheidungen gibt es?
- Was sind die Konsequenzen?

### 2. **User macht bewusste Entscheidungen**

Der Entwickler soll **eigenständig denken**:
- User legt die Projektstruktur nach der Standard Konvention selber an.
- Verständnis für die Projektstruktur.
- Tools bewusst konfigurieren (nicht Defaults blind übernehmen)

### 3. **Command-Line Tools**

Alle Entwicklung basiert auf CLI-Tools:
- **Gradle** - Build-System
- **adb** - Gerätekommunikation
- **sdkmanager** - SDK Verwaltung

### 4. **Weitere Prinzipien**

- Keine 100 Seiten für "Hallo Welt"
- Aber ausführliche Erklärungen von Konzepten
- Praktikal und direkt anwendbar
- Fokus auf Verstehen, nicht auf schnelle Ergebnisse

---

## Typischer Entwicklungs-Workflow

```
1. Code schreiben 
   └─ src/main/java/...
   └─ src/main/res/...
   └─ AndroidManifest.xml
   └─ build.gradle

2. Build mit Gradle (Command-Line)
   └─ gradle build

3. APK auf Gerät (adb)
   └─ adb install app.apk

4. Debuggen (adb logcat, adb shell)
   └─ adb logcat
   └─ adb shell
```

Kein IDE, kein GUI - nur die essentiellen Tools.

---

## Target Audience

Dieses Projekt ist für:

✅ **Anfänger**, die **verstehen** wollen, nicht nur "es funktioniert"
✅ **Entwickler**, die Command-Line lieben und IDEs hassen
✅ **Linux-User** - I use Arch btw
✅ **Minimalisten** - weniger ist mehr
✅ **Lernende** - die Android-Architektur wirklich verstehen wollen

---

## Langfristiges Ziel

Nach diesem Setup sollte der Entwickler in der Lage sein:

✅ Android-Apps von Hand zu schreiben und zu kompilieren
✅ Build-Prozess zu verstehen und anpassen zu können
✅ Mit adb und Command-Line Tools sicher zu arbeiten
✅ Probleme selbst zu debuggen und zu lösen
✅ Nicht abhängig von IDEs sein
✅ Android-Architektur wirklich verstehen
✅ Sein Setup automatisieren (Bash-Scripts)

---

## Fazit

**Dieser Weg ist anstrengender am Anfang, aber deutlich lohnender langfristig.**

Man lernt nicht nur "wie man eine App macht", sondern **WIE ANDROID WIRKLICH FUNKTIONIERT**.
