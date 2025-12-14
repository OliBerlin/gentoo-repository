EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit python-single-r1 systemd
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DESCRIPTION="MCP Log Server for Ollama (FastAPI-based), with /var/log and /etc access"
HOMEPAGE="https://local"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND="  acct-group/mcp-log
  acct-user/mcp-log"

RDEPEND="

  ${PYTHON_DEPS}
  dev-python/fastapi[${PYTHON_SINGLE_USEDEP}]
  dev-python/uvicorn
  dev-python/pydantic
  dev-python/starlette
  dev-python/anyio
  dev-python/sniffio
"

S="${WORKDIR}"

src_install() {
  insinto /usr/libexec/mcp-log-server
  doins "${FILESDIR}/log_mcp.py"
  doins "${FILESDIR}/allowed_paths.json"
  fperms +x /usr/libexec/mcp-log-server/log_mcp.py
  fowners -R mcp-log:mcp-log /usr/libexec/mcp-log-server

  insinto /etc/sudoers.d
  newins "${FILESDIR}/mcp-log-sudo" mcp-log
  fperms 0440 /etc/sudoers.d/mcp-log

  systemd_douserunit "${FILESDIR}/mcp-log-server.service"
}


pkg_postinst() {
  elog "User-Service aktivieren mit:"
  elog "  systemctl --user enable mcp-log-server.service"
  elog "  systemctl --user start mcp-log-server.service"
}
