EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
inherit cmake python-r1

DESCRIPTION="FAISS - Facebook AI Similarity Search (CPU/GPU vector search library)"
HOMEPAGE="https://github.com/facebookresearch/faiss"
SRC_URI="https://github.com/facebookresearch/faiss/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="cuda"

RDEPEND="
    ${PYTHON_DEPS}
    dev-libs/boost:=
    sci-libs/openblas
    cuda? ( dev-util/nvidia-cuda-toolkit )
"

BDEPEND="
    ${PYTHON_DEPS}
    dev-util/cmake
"

src_configure() {
    local mycmakeargs=(
        -DFAISS_ENABLE_PYTHON=ON
        -DFAISS_ENABLE_GPU=$(usex cuda ON OFF)
        -DFAISS_ENABLE_C_API=ON
        -DBLAS_LIBRARIES=openblas
        -DPython_EXECUTABLE="${PYTHON}"
    )

    cmake_src_configure
}

src_compile() {
    cmake_src_compile
}

src_install() {
    cmake_src_install
}