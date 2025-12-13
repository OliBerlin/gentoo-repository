EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-single-r1 systemd

DESCRIPTION="MCP Log Server for Ollama (FastAPI-based)"
HOMEPAGE="https://example.local"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
    ${PYTHON_DEPS}
    dev-python/fastapi[${PYTHON_SINGLE_USEDEP}]
    dev-python/uvicorn[${PYTHON_SINGLE_USEDEP}]
    dev-python/pydantic[${PYTHON_SINGLE_USEDEP}]
    dev-python/starlette[${PYTHON_SINGLE_USEDEP}]
    dev-python/anyio[${PYTHON_SINGLE_USEDEP}]
    dev-python/sniffio[${PYTHON_SINGLE_USEDEP}]
"

S="${WORKDIR}"

src_install() {
    insinto /usr/libexec/mcp-log-server
    doins "${FILESDIR}/log_mcp.py"
    doins "${FILESDIR}/allowed_paths.json"

    fperms +x /usr/libexec/mcp-log-server/log_mcp.py

    systemd_douserunit "${FILESDIR}/mcp-log-server.service"
}

pkg_postinst() {
    elog "Enable the MCP Log Server with:"
    elog "  systemctl --user enable mcp-log-server.service"
    elog "  systemctl --user start mcp-log-server.service"
}

