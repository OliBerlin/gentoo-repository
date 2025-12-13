EAPI=8

inherit acct-user

DESCRIPTION="User for MCP RAG Server"
ACCT_USER_ID=3003
ACCT_USER_GROUPS=( mcp-rag )
ACCT_USER_HOME="/usr/libexec/mcp-rag"
ACCT_USER_SHELL="/sbin/nologin"

SLOT="0"
KEYWORDS="~amd64"
