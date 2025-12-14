# Copyright ...
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit python-single-r1 systemd

DESCRIPTION="MCP Log Server (FastAPI)"
HOMEPAGE="https://example.com"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
    ${PYTHON_DEPS}
    dev-python/virtualenv
"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
    # Install program files
    insinto /usr/libexec/mcp-log-server
    doins "${FILESDIR}/log_mcp.py"

    # Create venv
    einfo "Creating virtualenv..."
    python_fix_shebang "${ED}"
    "${PYTHON}" -m venv "${ED}/usr/libexec/mcp-log-server/venv" || die

    # Install minimal dependencies
    einfo "Installing FastAPI + deps into venv..."
    "${ED}/usr/libexec/mcp-log-server/venv/bin/pip" install --no-cache-dir \
        fastapi uvicorn || die

    # Install systemd unit
    systemd_dounit "${FILESDIR}/mcp-log-server.service"
}

pkg_postinst() {
    einfo "Creating virtualenv..."
    /usr/bin/python3.12 -m venv /usr/libexec/mcp-log-server/venv

    einfo "Installing FastAPI + uvicorn..."
    /usr/libexec/mcp-log-server/venv/bin/pip install fastapi uvicorn
}