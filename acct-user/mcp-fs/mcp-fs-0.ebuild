EAPI=8

inherit acct-user

DESCRIPTION="User for MCP Filesystem Server"
ACCT_USER_ID=3002
ACCT_USER_GROUPS=( mcp-fs )
ACCT_USER_HOME="/usr/libexec/mcp-fs-server"
ACCT_USER_SHELL="/sbin/nologin"

SLOT="0"
KEYWORDS="~amd64"
