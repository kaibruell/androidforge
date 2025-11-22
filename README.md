# Android Development ohne die Blackbox – Ein CLI-Manifest

**Status:** 🚧 Im aktiven Aufbau – Dieses Projekt wächst kontinuierlich

---

## Worum geht's hier?

Ich möchte für mein Smartphone Android-Apps entwickeln. Punkt. Aber **nicht** mit Android Studio. Das Ding ist für mich eine Blackbox – und ich bin ein Mensch, der es hasst, wenn er nicht versteht, was unter der Haube passiert.

Dieses Projekt ist mein persönliches **Manifest gegen Bloatware** und **für echte Kontrolle**.

---

## Die unbequeme Wahrheit über Android Studio

Ich sitze auf einem **Thinkpad X270** mit **8 GB RAM** und einem **Intel Core i5**. Kein Gaming-Rig, kein High-End-Setup. Das ist meine Realität, und ich liebe diese Hardware. Warum? Sie ist zuverlässig, minimal, und tut das, was sie soll. Ein neues Motherboard kostet 60€ und ich bin gezwungen das maximale aus meinem System rauszuholen. Das ist meine Philosophie. 

Ich habe mich von Anfang an GEGEN Android Studio entschieden: Android Studio fühlt hört sich so an, wie ein riesen großer Haufen Bloatware - ohne Kontrolle. Außerdem kommen für mich nur zwei IDE's in frage: VsCodium mit Vim Motions und langfristig Neovim, weil ich meine LSPs gerne selber konfigurieren will. ALLES will ich selber machen... Ich bin einfach so eingestellt... Ich mag es nicht wenn an mir Magic API's aufschwätzen will.  

Aber das ist noch nicht das Problem.

Das Problem ist: **Ich weiß nicht, was Android Studio macht.**

Das fühlt sich an wie **Bevormundung**. Wie wenn man mit mir spricht wie mit einem Kind, das keine Verantwortung für seinen Computer haben darf.

Das tut in der Seele weh.

---

## Meine Welt: Linux, Arch, Minimalismus

Ich nutze **Arch Linux**. Nicht aus Hipster-Gründen, sondern weil Arch mir Kontrolle gibt. Ich sehe, was installiert wird. Ich sehe, was lädt. Ich kann jederzeit alles verstehen und anpassen.

Meine Umgebung ist minimalistisch:
- **VsCodium** als Editor
- **Bash** als Shell
- **Git** für Versionskontrolle
- Command-Line Tools, die genau das tun, was sie sollen

Alles andere ist Noise.

---

## Das Manifest: Warum ich dieses Projekt gestartet habe

Ich wollte Android entwickeln können, **ohne** mich an die Behinderungen und das Theater von Android Studio anzupassen.

### Was mir wichtig ist:

✅ **Volle Kontrolle** – Ich verstehe jeden Schritt des Build-Prozesses
✅ **Transparenz** – Keine Magie, keine versteckten Operationen
✅ **Effizienz** – Mein Setup frisst keine Ressourcen
✅ **Flexibilität** – Ich nutze die Tools, die mir gefallen (mein Editor, meine Shell)
✅ **Verständnis** – Ich lerne nicht "wie man einen Button drückt", sondern **wie Android wirklich funktioniert**
✅ **Reproduzierbarkeit** – Alles läuft gleich auf jedem Computer (Linux)

### Was mir egal ist:

❌ Bunte GUI-Fenster
❌ Unzählige Menü-Items
❌ IDE-spezifische Lock-ins
❌ 4 GB RAM für syntaktisches Highlighting
❌ "One-Click Magic Buttons"

---

## Was ist in diesem Projekt?

Hier dokumentiere ich, wie man **von Hand** und **Automatisiert** eine Android-App baut – nicht mit IDE-Zauberei, sondern mit echten Tools:

### Die Werkzeuge
- **JDK 21** – Die Java-Runtime
- **Android SDK Command-Line Tools** – sdkmanager, Platform Tools, Build Tools
- **Gradle** – Das eigentliche Build-System (mit Wrapper für Reproduzierbarkeit)
- **adb** – Die Android Debug Bridge (pure CLI-Power)
- **Text-Editor meiner Wahl** – VsCodium

### Die Dokumentation
Ich dokumentiere:

1. **JDK Setup** – Welche Version, warum, wie man sie konfiguriert
2. **SDK Setup** – Was der sdkmanager macht, welche Komponenten man braucht
3. **Projekt-Struktur** – Warum die Android Konvention so aussieht, wie sie aussieht
4. **Gradle** – Das Build-System verstehen, und die Tools unter der Haube (aapt2, javaac, d8 etc.)
5. **Der Build-Prozess** – Was passiert von Java zum APK? Step by Step.
6. **AndroidManifest** – Die wichtigste Datei, was sie bedeutet
7. **Ressourcen & R.java** – Die Magie dahinter, entmystifiziert
8. **adb & Debugging** – Wie man mit echten Command-Line Tools debuggt

**Jedes Kapitel erklärt nicht nur "wie", sondern "warum".**

---

## Der typische Workflow

```bash
# 1. Projekt initialisieren (mit meinem Script)
./init-android-sdk-project-structure.sh MyApp com.example.myapp

# 2. Code schreiben (in Neovim oder deinem Editor)
nvim app/src/main/java/com/example/myapp/MainActivity.java

# 3. Bauen
./gradlew assembleDebug

# 4. Installieren & Debuggen
adb install app/build/outputs/apk/debug/app-debug.apk
adb logcat MyApp.Main:I *:S

# 5. Änderungen machen, wiederholen
```

**Kein Klicken. Keine Fenster. Nur reine CLI-Power. Ich selber erschaffe meinen Workflow**

---

## Wofür ist dieses Projekt?

**Für wen ist das gedacht?**

✅ Entwickler, die **verstehen** wollen, nicht nur Buttons drücken
✅ CLI-Fans und Minimalisten
✅ Nur Linux-User
✅ Menschen, die auf älterer Hardware arbeiten
✅ Anfänger, die wirklich lernen wollen


**Nicht für:**
❌ Windows / MacOS User

---

## Der Status: Work in Progress

Dieses Projekt ist **noch im Aufbau**. Ich schreibe hier auf, was ich lerne, während ich es selbst nutze.

---

## Wie ich dieses Projekt nutze

Ich selbst entwickle dieses Setup / Workflow auf meinem Thinkpad. Es ist erstmal nur der Entrypoint für CLI Driven Android Entwicklung. Ich weiß noch nicht was hier entsteht. Ich denke aber das ich es noch auf englisch übersetze. Und dann wird der nächste Schritt sein LSPs zu konfigurieren... Und vielleicht sinnvolle Plugins für VsCodium und der gleichen. Ich muss noch herausfinden was ich für Android Entwicklung in meiner IDE brauche... Ansonten ist aber alles da!  

---

## Die Philosophie dahinter

> **"Ein Computer sollte Dir dienen, nicht Dich bevormunden."**

Ich bin kein Fan von:
- Black Boxes
- "Trust me, I know what I'm doing" APIs
- Unnötiger Abstraktion
- Ressourcen-Verschwendung

Ich bin ein Fan von:
- Transparenz
- Minimalen Abhängigkeiten
- Selbstbestimmung
- **Echtem Verständnis**
---

## Wie du das Projekt nutzen kannst

1. **Schau dir die Docs an** – Beginne mit `01_JDK.md`
2. **Folge dem Setup-Script** – `init-android-sdk-project-structure.sh`
3. **Experimentiere** – Baue deine erste App
4. **Erweitere** – Passe es an wie du es brauchst 
5. **Nutze es als Referenz** – Wenn du etwas vergisst

Viel Spaß! 

---

## Kontakt & Feedback

Dieses Projekt ist persönlich. Es ist mein Weg zu arbeiten. Es darf mehr daraus werden.

---

**Gebaut mit Liebe für Command Line und Linux. Ohne Bloatware. Ohne Kompromisse.**
