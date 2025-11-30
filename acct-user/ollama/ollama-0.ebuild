EAPI=8

inherit acct-user

DESCRIPTION="System user for Ollama service"
ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/ollama
ACCT_USER_SHELL=/bin/false
ACCT_USER_GROUPS=( ollama )
SLOT="0"
KEYWORDS="amd64 arm64"

# WICHTIG: dieser Aufruf muss im globalen Bereich stehen
acct-user_add_deps
