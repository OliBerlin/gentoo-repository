# homeassistant-2025.8.2.ebuild

EAPI=8

PYTHON_COMPAT=( python3_11 )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 systemd user
DESCRIPTION="Open source home automation platform"
HOMEPAGE="https://www.home-assistant.io/"
SRC_URI="https://github.com/home-assistant/core/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

inherit distutils-r1 systemd user

DEPEND="
    dev-python/setuptools[${PYTHON_USEDEP}]
    dev-python/wheel[${PYTHON_USEDEP}]
"

RDEPEND="${DEPEND}
    dev-python/requests[${PYTHON_USEDEP}]
    dev-python/aiohttp[${PYTHON_USEDEP}]
    dev-python/voluptuous[${PYTHON_USEDEP}]
    dev-python/jinja2[${PYTHON_USEDEP}]
    dev-python/pytz[${PYTHON_USEDEP}]
    dev-python/sqlalchemy[${PYTHON_USEDEP}]
    dev-python/pyopenssl[${PYTHON_USEDEP}]
    dev-python/cryptography[${PYTHON_USEDEP}]
    dev-python/attrs[${PYTHON_USEDEP}]
    dev-python/async-timeout[${PYTHON_USEDEP}]
    dev-python/pyyaml[${PYTHON_USEDEP}]
    dev-python/zeroconf[${PYTHON_USEDEP}]
"

S="${WORKDIR}/core-${PV}"

python_install_all() {
    distutils-r1_python_install_all
}

pkg_setup() {
    enewgroup homeassistant
    enewuser homeassistant -1 /var/lib/homeassistant /bin/false homeassistant
}
