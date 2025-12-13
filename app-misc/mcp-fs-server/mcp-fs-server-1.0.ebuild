EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-single-r1 systemd

DESCRIPTION="MCP Filesystem Server for Ollama (FastAPI-based), rooted at /home/oli/together"
HOMEPAGE="https://local"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
  acct-user/mcp-fs
  acct-group/mcp-fs
  ${PYTHON_DEPS}
  dev-python/fastapi[${PYTHON_SINGLE_USEDEP}]
  dev-python/uvicorn[${PYTHON_SINGLE_USEDEP}]
  dev-python/pydantic[${PYTHON_SINGLE_USEDEP}]
  dev-python/starlette[${PYTHON_SINGLE_USEDEP}]
  dev-python/anyio[${PYTHON_SINGLE_USEDEP}]
  dev-python/sniffio[${PYTHON_SINGLE_USEDEP}]
"

S="\${WORKDIR}"

src_install() {
  insinto /usr/libexec/mcp-fs-server
  doins "\${FILESDIR}/filesystem_mcp.py"
  fperms +x /usr/libexec/mcp-fs-server/filesystem_mcp.py
  fowners -R mcp-fs:mcp-fs /usr/libexec/mcp-fs-server

  systemd_douserunit "\${FILESDIR}/mcp-fs-server.service"
}

pkg_postinst() {
  elog "Stelle sicher, dass /home/oli/together für mcp-fs zugreifbar ist."
  elog "User-Service aktivieren mit:"
  elog "  systemctl --user enable mcp-fs-server.service"
  elog "  systemctl --user start mcp-fs-server.service"
}
