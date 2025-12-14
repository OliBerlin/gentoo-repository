EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
DISTUTILS_UPSTREAM_PEP517=pdm-backend
PYPROJECT_BACKEND=pdm.backend

PYTHON_COMPAT=( python3_{11..14} )

inherit python-single-r1 systemd
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DESCRIPTION="FastAPI framework, high performance, easy to learn"
HOMEPAGE="https://fastapi.tiangolo.com/"
SRC_URI="https://files.pythonhosted.org/packages/source/f/fastapi/fastapi-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
  ${PYTHON_DEPS}
  dev-python/starlette
  dev-python/pydantic
  dev-python/anyio
  dev-python/sniffio
"