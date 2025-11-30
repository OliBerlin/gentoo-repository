EAPI=8

inherit systemd

DESCRIPTION="Ollama - local LLM runtime"
HOMEPAGE="https://github.com/ollama/ollama"
SRC_URI="https://github.com/ollama/ollama/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE="+cpu -cuda -rocm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64"

DEPEND="
    dev-lang/go
    cuda? ( dev-util/nvidia-cuda-toolkit )
    rocm? ( dev-libs/rocm )"

RDEPEND="${DEPEND}
    acct-user/ollama
    acct-group/ollama"

src_compile() {
    local tags="cpu"
    use cuda && tags+=" cuda"
    use rocm && tags+=" rocm"

    cd "${S}" || die
    env GOFLAGS="-mod=mod" go build -tags "${tags}" -o ollama .
}

src_install() {
    dobin ollama
    dodoc README.md

    keepdir /var/lib/ollama/models
    fowners ollama:ollama /var/lib/ollama /var/lib/ollama/models
    fperms 0750 /var/lib/ollama /var/lib/ollama/models

    systemd_dounit "${FILESDIR}/ollama.service"
}

src_unpack() {
    default
}
