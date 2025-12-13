EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-single-r1 systemd

DESCRIPTION="MCP RAG Server using FAISS and SentenceTransformers"
HOMEPAGE="https://local"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
  acct-user/mcp-rag
  acct-group/mcp-rag
  ${PYTHON_DEPS}
  dev-python/fastapi[${PYTHON_SINGLE_USEDEP}]
  dev-python/uvicorn[${PYTHON_SINGLE_USEDEP}]
  dev-python/pydantic[${PYTHON_SINGLE_USEDEP}]
  dev-python/starlette[${PYTHON_SINGLE_USEDEP}]
  dev-python/anyio[${PYTHON_SINGLE_USEDEP}]
  dev-python/sniffio[${PYTHON_SINGLE_USEDEP}]
  dev-python/sentence-transformers[${PYTHON_SINGLE_USEDEP}]
  sci-libs/faiss
"

S="\${WORKDIR}"

src_install() {
  insinto /usr/libexec/mcp-rag
  doins "\${FILESDIR}/rag_server.py"
  fperms +x /usr/libexec/mcp-rag/rag_server.py

  keepdir /var/lib/mcp-rag
  fowners -R mcp-rag:mcp-rag /usr/libexec/mcp-rag /var/lib/mcp-rag

  systemd_douserunit "\${FILESDIR}/mcp-rag.service"
}

pkg_postinst() {
  elog "User-Service aktivieren mit:"
  elog "  systemctl --user enable mcp-rag.service"
  elog "  systemctl --user start mcp-rag.service"
}
