EAPI=8
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="FastAPI framework, high performance, easy to learn"
HOMEPAGE="https://fastapi.tiangolo.com/"
SRC_URI="https://files.pythonhosted.org/packages/source/f/fastapi/fastapi-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
  dev-python/starlette[${PYTHON_USEDEP}]
  dev-python/pydantic[${PYTHON_USEDEP}]
  dev-python/anyio[${PYTHON_USEDEP}]
  dev-python/sniffio[${PYTHON_USEDEP}]
"