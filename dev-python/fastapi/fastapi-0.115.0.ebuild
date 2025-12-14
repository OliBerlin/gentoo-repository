EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
DISTUTILS_UPSTREAM_PEP517=pdm-backend
PYPROJECT_BACKEND=pdm.backend

PYTHON_COMPAT=( python3_{10..14} )

inherit python-single-r1 

DESCRIPTION="FastAPI framework, high performance, easy to learn"
HOMEPAGE="https://fastapi.tiangolo.com/"
SRC_URI="https://files.pythonhosted.org/packages/source/f/fastapi/fastapi-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
  ${PYTHON_DEPS}
  dev-python/starlette[${PYTHON_SINGLE_USEDEP}]
  dev-python/pydantic[${PYTHON_SINGLE_USEDEP}]
  dev-python/anyio[${PYTHON_SINGLE_USEDEP}]
  dev-python/sniffio[${PYTHON_SINGLE_USEDEP}]
"