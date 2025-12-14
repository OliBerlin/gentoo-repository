EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Sentence Embeddings using Transformers"
HOMEPAGE="https://www.sbert.net/ https://github.com/UKPLab/sentence-transformers"
SRC_URI="https://github.com/UKPLab/sentence-transformers/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

# Optional heavy deps
IUSE="+transformers +torch +scikit-learn"

RDEPEND="
    dev-python/numpy[${PYTHON_USEDEP}]
    dev-python/scipy[${PYTHON_USEDEP}]
    dev-python/tqdm[${PYTHON_USEDEP}]
    dev-python/pyyaml[${PYTHON_USEDEP}]
    sci-ml/huggingface_hub[${PYTHON_USEDEP}]
    dev-python/regex[${PYTHON_USEDEP}]
    dev-python/requests[${PYTHON_USEDEP}]

    scikit-learn? ( dev-python/scikit-learn[${PYTHON_USEDEP}] )
    transformers? ( dev-python/transformers[${PYTHON_USEDEP}] )
    torch? ( dev-python/torch[${PYTHON_USEDEP}] )
"

BDEPEND="
    dev-python/hatchling[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest