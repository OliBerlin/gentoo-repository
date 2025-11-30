EAPI=8
inherit acct-group

DESCRIPTION="System group for Ollama service"
ACCT_GROUP_ID=-1   # -1 = automatisch freie GID wählen
ACCT_GROUP_NAME=ollama  # <--- das fehlt bei dir!

SLOT="0"
KEYWORDS="amd64 arm64"
