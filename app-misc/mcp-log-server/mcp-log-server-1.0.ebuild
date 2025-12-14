EAPI=8

PYTHON_COMPAT=( python3_12 )
inherit python-single-r1 systemd

DESCRIPTION="MCP Log Server (FastAPI)"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
    ${PYTHON_DEPS}
    dev-python/virtualenv[${PYTHON_SINGLE_USEDEP}]
"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
    # Install your script
    insinto /usr/libexec/mcp-log-server
    doins "${FILESDIR}/log_mcp.py"

    # Install systemd unit
    systemd_dounit "${FILESDIR}/mcp-log-server.service"
}

pkg_postinst() {
    einfo "Creating virtualenv in final target path..."
    /usr/bin/python3.12 -m venv /usr/libexec/mcp-log-server/venv || die

    einfo "Installing FastAPI + uvicorn into venv..."
    /usr/libexec/mcp-log-server/venv/bin/pip install --no-cache-dir fastapi uvicorn || die

    einfo "MCP Log Server venv created successfully."
}