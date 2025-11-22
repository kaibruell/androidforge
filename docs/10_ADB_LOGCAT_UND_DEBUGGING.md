# 10\_ADB\_LOGCAT\_UND\_DEBUGGING.md: Die Essenz der Diagnose

## 1\. Warum `logcat` das wichtigste Werkzeug ist

Wenn Ihre App auf dem angeschlossenen Gerät abstürzt (*"force closes"*), ist die Reaktion eines IDE-Nutzers: *„Die IDE hat mir einen Fehler gemeldet.“* Die Reaktion eines CLI-Minimalisten ist: *„Ich sehe den Absturz im Logcat und lese die Ursache aus.“*

Die **Android Debug Bridge** (ADB) bietet über das Kommando **`logcat`** einen direkten, ungefilterten Blick in das interne Protokoll des Android-Betriebssystems (ähnlich dem Linux-Kernel-Log).

### Was ist `logcat`?

`logcat` ist eine Funktion der ADB, die alle vom System und allen Anwendungen geschriebenen **Protokollmeldungen** in Echtzeit ausgibt.

### Der Basis-Befehl

Stellen Sie sicher, dass Ihr Gerät angeschlossen ist (`adb devices` zeigt `device` an), und starten Sie den Log-Stream:

```bash
# Startet den Live-Stream aller Log-Meldungen
adb logcat
```

Die Ausgabe wird sofort beginnen, zu schnell, um sie zu lesen. Sie besteht aus Hunderten von Nachrichten pro Sekunde, da das gesamte System (Netzwerk, UI-Renderer, Hintergrunddienste) ständig Protokolle schreibt.

-----

## 2\. Die Anatomie einer Log-Meldung

Jede Zeile im Logcat folgt einem strikten Format, das Sie beherrschen müssen, um Informationen zu extrahieren.

| Feld | Abk. | Beispielwert | Bedeutung |
| :--- | :--- | :--- | :--- |
| Datum / Zeit | **-** | `11-21 16:03:00.123` | Timestamp (sehr nützlich, um den Absturzzeitpunkt zu finden). |
| Prozess-ID | **PID** | `304` | Die ID des Prozesses, der die Nachricht geschrieben hat (z.B. Ihre App). |
| Thread-ID | **TID** | `304` | Der Thread innerhalb des Prozesses (z.B. der UI-Thread). |
| **Log-Level** | **L** | `I` | Die Wichtigkeit der Nachricht (**I**nfo, **E**rror, **W**arn, etc.). |
| **Log-Tag** | **Tag** | `MainActivity` | Eine kurze Zeichenkette zur Identifizierung der Quelle (z.B. der Name Ihrer Klasse). |
| Nachricht | **M** | `onCreate called` | Die eigentliche, geschriebene Nachricht (z.B. ein Fehler oder eine Debug-Ausgabe). |

### Log-Levels: Die Wichtigkeit der Nachricht

Das **Log-Level** ist die wichtigste Information, um einen Fehler zu finden.

| Level | Abk. | Bedeutung | CLI-Relevanz |
| :--- | :--- | :--- | :--- |
| **V**erbose | `V` | Sehr detailliertes Protokoll (fast nie nützlich). | Kann ignoriert werden. |
| **D**ebug | `D` | Nützlich für Entwickler-Debugging. | Ihre eigenen Debug-Meldungen. |
| **I**nfo | `I` | Allgemeine Systemereignisse (z.B. App-Start). | Nützlich, um den Start Ihrer App zu sehen. |
| **W**arn | `W` | Potenziell unerwünschte, aber nicht fatale Probleme. | Sollte im Auge behalten werden. |
| **E**rror | `E` | Ein Problem, das zu einem Fehler geführt hat, aber nicht zum Absturz des gesamten Prozesses. | **Zentrale Fehlersuche.** |
| **A**ssert | `A` | Fataler Fehler (Die App/das System ist kurz davor abzustürzen). | **Der Absturz-Indikator.** |

-----

## 3\. Filtern des Logcat-Streams

Da der ungefilterte Logcat-Stream unlesbar ist, ist die Fähigkeit zu filtern absolut entscheidend.

### 3.1. Filterung nach Log-Level (Einfach)

Sie können `logcat` anweisen, nur Nachrichten ab einem bestimmten Level auszugeben. Da Fehler die höchste Priorität haben, beginnen Sie immer mit `Error` oder `Assert`.

```bash
# Zeigt nur ERROR- und ASSERT-Meldungen an
# Syntax: adb logcat *:<Level>
adb logcat *:E
```

### 3.2. Filterung nach dem eigenen Log-Tag (Der Pro-Weg)

Der beste Weg, Ihre App zu diagnostizieren, besteht darin, **Ihre eigenen Nachrichten** mit einem eindeutigen **Log-Tag** zu versehen.

#### Schritt A: Code-Anpassung (`MainActivity.java`)

In Ihrer `MainActivity.java` müssen Sie zwei Dinge tun:

1.  Die Klasse **`android.util.Log`** importieren.
2.  Einen statischen `TAG` für die Klasse definieren (z.B. den Klassennamen).
3.  Im `onCreate` eine Debug-Meldung schreiben.

<!-- end list -->

```java
// app/src/main/java/com/example/myapp/MainActivity.java

package com.example.myapp;

import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.TextView;
// NEU: Importiere die Log-Klasse
import android.util.Log; 

public class MainActivity extends AppCompatActivity {

    // NEU: Definiere einen statischen TAG
    private static final String TAG = "MyApp.Main"; 

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // NEU: Schreibe eine Info-Meldung in den Logcat-Stream
        Log.i(TAG, "MainActivity gestartet. UI wird geladen."); 

        TextView textView = new TextView(this);
        textView.setText("Hello World CLI!");
        setContentView(textView);
    }
}
```

#### Schritt B: Filtern in der CLI

Nachdem Sie den Code gebaut und installiert haben (`./gradlew installDebug`), können Sie den Logcat-Stream starten und nur nach Ihrem spezifischen `TAG` filtern:

```bash
# Syntax: adb logcat <TAG>:<Level> *:<andere-Levels>

# Zeigt NUR alle Meldungen von 'MyApp.Main' an
adb logcat MyApp.Main:I *:S
```

  * **`MyApp.Main:I`**: Zeige alle **Info-Meldungen** oder höher (Warnung, Error, Assert) mit dem Tag `MyApp.Main`.
  * **`*:S`**: **Suppressed** (Unterdrückt) – Verbirgt alle anderen Tags, um den Output sauber zu halten.

### 4\. Der Absturz (Crash) finden: `FATAL EXCEPTION`

Wenn Ihre App abstürzt, stoppt das Android-Betriebssystem den Prozess und schreibt einen detaillierten Fehlerbericht in den Logcat.

Suchen Sie immer nach dem String **`FATAL EXCEPTION`**.

```bash
# Sucht nur nach allen fatalen Abstürzen
adb logcat | grep "FATAL EXCEPTION"
```

Sobald Sie die Zeile `FATAL EXCEPTION` finden, scrollen Sie hoch und suchen Sie den **Stack Trace**, der genau zeigt, welche Zeile in Ihrem Java-Code den Absturz ausgelöst hat (z.B. `NullPointerException` in `com.example.myapp.MainActivity.onCreate(MainActivity.java:42)`).

-----

## Fazit: Die CLI-Kontrolle

Der **`adb logcat`**-Befehl ist die wahre Macht der Command Line. Während IDEs Ihnen die Logs grafisch aufbereiten, sehen Sie hier die **Rohdaten**. Ein echter Linux-Minimalist nutzt die Macht von **`grep`** und dem **Logcat-Filter-Format**, um die Diagnose präzise und effizient durchzuführen.