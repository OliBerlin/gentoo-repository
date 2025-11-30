EAPI=8

inherit acct-user

DESCRIPTION="System user for Ollama service"

# UID automatisch vergeben
ACCT_USER_ID=-1

# Home-Verzeichnis
ACCT_USER_HOME=/var/lib/ollama

# Shell
ACCT_USER_SHELL=/bin/false

# Primäre Gruppe
ACCT_USER_GROUPS=( ollama )

SLOT="0"
KEYWORDS="amd64 arm64"

# WICHTIG: dieser Aufruf muss im globalen Bereich stehen
acct-user_add_deps
