EAPI=8

inherit acct-user

DESCRIPTION="User for MCP Log Server"

ACCT_USER_ID=-1
ACCT_USER_GROUPS=( mcp-log )
ACCT_USER_HOME="/usr/libexec/mcp-log-server"
ACCT_USER_SHELL="/sbin/nologin"

SLOT="0"
KEYWORDS="amd64"

# WICHTIG: dieser Aufruf muss im globalen Bereich stehen
acct-user_add_deps