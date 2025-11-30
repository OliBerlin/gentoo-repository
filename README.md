# gentoo-repo

Dieses Repository ist ein privates Gentoo-Overlay mit Beispiel-Ebuilds, Metadaten und Repo-Profilen. Es dient als Entwicklungs- und Test-Overlay — nicht als vollständiges, production-ready Gentoo-Overlay. Einige Ebuilds wurden aus Gründen der Einfachheit vereinfacht und sind nicht zwangsläufig von Gentoo offiziell unterstützt.

Wichtiger Hinweis (Disclaimer)
- Die hier enthaltenen Ebuilds sind vorrangig für Entwicklung und Tests gedacht. Sie entsprechen nicht notwendigerweise allen Gentoo-QA-Standards (Abhängigkeiten, Keywords, Maskierung, etc.).
- Verwende die Pakete nur in einer Test-/Entwicklungsumgebung und prüfe Abhängigkeiten sowie QA-Checks vor einem produktiven Einsatz.

Inhaltsverzeichnis
- Repository-Aufbau
- Sandbox / package.env (wichtig)
- Installation als Overlay
- Nutzung / Paket installieren
- Entwickler-Workflow
- Tests & Validierung
- Bekannte Einschränkungen
- Contributing
- Lizenz & Kontakt

Repository-Aufbau
Das Repository enthält (Auswahl):
- Kategorien: acct-group/, acct-user/, dev-ai/ (z. B. dev-ai/ollama/ollama-0.13.0.ebuild)
- metadata/: layout.conf, metadata.xml
- profiles/: repo_name
- package.env/: Zuordnung von Paketen zu build-Umgebungen

Hinweis: Git trackt keine leeren Verzeichnisse. Falls bestimmte Ordner gebraucht werden, lege Platzhalter (.gitkeep) an.

Sandbox / package.env (wichtig)
Manche Ebuilds in diesem Overlay sind so angelegt, dass sie in einer restriktiven Build-Sandbox laufen. Für Tests oder spezielle Builds kann es nötig sein, die Netzwerk-Sandbox lokal auf dem System zu deaktivieren. Vorgehen (auf dem Zielsystem, als root):

1) Erstelle die Env-Datei unter /etc/portage/env:

Datei: /etc/portage/env/no-network-sandbox.conf
Inhalt (Beispiel):
FEATURES="-network-sandbox"

Hinweis: Diese Datei ändert die FEATURES-Variable nur für Builds, die auf diese Env-Datei referenzieren.

2) Weise die Env-Datei dem Paket über package.env im Overlay zu:

Datei im Repo: package.env/package.env
Beispielzeile (bereits im Repo vorgesehen):
dev-ai/ollama no-network-sandbox.conf

Damit wird beim emerge von dev-ai/ollama die oben definierte Env angewendet und die Netzwerk-Sandbox für diesen Build deaktiviert.

Sicherheits-Hinweis: Das Deaktivieren der Netzwerk-Sandbox erlaubt Netzwerkzugriffe während des Builds. Setze diese Maßnahme nur in kontrollierten Testumgebungen ein.

# Installation / Einbinden als Overlay 
Wichtig: Es ist nicht nötig, das Repo manuell per git clone in /var/db/repos zu kopieren. Verwende stattdessen eselect-repository, um das Overlay sauber und Portage-kompatibel hinzuzufügen.

## eselect repository
### eselect-repository installieren (falls noch nicht vorhanden)
   ```bash
   sudo emerge --ask app-eselect/eselect-repository
   ```
### Repository hinzufügen
   ```bash
   sudo eselect repository add gentoo-repo git https://github.com/OliBerlin/gentoo-repo.git
   sudo emerge --sync gentoo-repo

   ```

Hinweis: Die genauen Befehle hängen von deiner eselect-repository-Version ab; siehe `eselect repository --help` für Details.

## manuell
Lege eine Datei `/etc/portage/repos.conf/gentoo-repo.conf` an mit z. B.:
   ```bash
   [gentoo-repo]
   location = /var/db/repos/gentoo-repo
   sync-type = git
   sync-uri = https://github.com/OliBerlin/gentoo-repo.git
   ```
Nutzung / Paket installieren
- Simulation:
  emerge -pv dev-ai/ollama
- Installation:
  emerge -av dev-ai/ollama
Entwickler-Workflow
- Neue Ebuilds hinzufügen:
  1. Lege category/package/ an.
  2. Erstelle das ebuild (z. B. package-1.0.ebuild).
  3. Erzeuge/aktualisiere das Manifest: repoman manifest  (oder ebuild <ebuild> manifest)
  4. Commit: git add … && git commit -m "Add <category>/<package>-<version>" && git push origin main

- Wichtiger Hinweis: Dateien müssen committet sein, damit sie beim git push auf origin sichtbar werden. "A ..." in git status bedeutet: gestaged, aber noch nicht committed.

Tests & Validierung
- Manifest erzeugen / aktualisieren:
  repoman manifest
- Linting / QA:
  repoman full
- Teste Builds zuerst im "pretend"-Modus:
  emerge -pv <category>/<package>

Bekannte Einschränkungen
- Keine Garantie für vollständige Gentoo-Unterstützung: Abhängigkeiten, USE-Flags und Arch-Keywords können unvollständig sein.
- Leere Verzeichnisse werden nicht getrackt.
- Verschachtelte .git-Ordner in Unterverzeichnissen führen zu Submodule-ähnlichem Verhalten.
- Vermeide große Binaries (>100 MB); nutze ggf. Git LFS.

Contributing
- Vorher: Fork → Feature-Branch → Änderungen lokal testen (repoman/manifest)
- Commit mit aussagekräftiger Nachricht → Push → Pull Request
- Beschreibe im PR welche Tests/Plattformen du verwendet hast.

Lizenz & Kontakt
- Dieses Repository ist privat. Trage hier bei Bedarf eine Lizenz ein (z. B. MIT, GPL-2.0) oder belasse es privat.
- Kontakt: OliBerlin (GitHub: @OliBerlin)
