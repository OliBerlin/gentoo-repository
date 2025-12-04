# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Free/Libre build of Microsoft's VSCode editor"
HOMEPAGE="https://vscodium.com"
SRC_URI="https://github.com/VSCodium/vscodium/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Abhängigkeiten laut VSCodium Build-Doku + jq für get_repo.sh
DEPEND="
    app-misc/jq
    dev-lang/node:20
    dev-lang/python:3.11
    dev-lang/rust
    dev-vcs/git
    sys-devel/gcc
    sys-devel/make
    sys-devel/pkgconfig
    x11-libs/libX11
    x11-libs/libxkbfile
    app-crypt/libsecret
    virtual/krb5
    app-arch/rpm
    app-arch/dpkg
    media-gfx/imagemagick
"
RDEPEND="${DEPEND}"

src_prepare() {
    default
}

src_compile() {
    export SHOULD_BUILD="yes"
    export CI_BUILD="no"
    export OS_NAME="linux"
    export VSCODE_ARCH="x64"
    export VSCODE_QUALITY="stable"
    export RELEASE_VERSION="${PV}"

    # Hole VSCode-Repo und baue
    ./get_repo.sh || die "get_repo.sh fehlgeschlagen – prüfe jq und Internetzugang"
    ./build.sh || die "build.sh fehlgeschlagen"
}

src_install() {
    dodir /opt/vscodium
    cp -r vscode-linux-x64/* "${D}/opt/vscodium/" || die "Kopieren fehlgeschlagen"

    dosym /opt/vscodium/codium /usr/bin/codium
}
