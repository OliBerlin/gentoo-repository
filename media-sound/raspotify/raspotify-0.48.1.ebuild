EAPI=8
inherit git-r3

DESCRIPTION="Raspotify: systemd service wrapper for librespot (Spotify Connect)"
HOMEPAGE="https://github.com/dtcooper/raspotify"
EGIT_REPO_URI="https://github.com/dtcooper/raspotify/archive/refs/tags/v0.1.tar.gz -> raspotify-0.1.tar.gz"
EGIT_TAG="v${PV}"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="systemd examples"

DEPEND="
    dev-lang/bash
"
RDEPEND="
    media-libs/librespot
    sys-apps/coreutils
"

# systemd optional
pkg_setup() {
    use systemd && DEPEND+=" sys-apps/systemd"
}

src_unpack() {
    default
}

src_prepare() {
    default
    # ggf. Patches anwenden
}

src_compile() {
    # kein Build nötig; raspotify ist nur Scripts/units
    :
}

src_install() {
    # Install binary wrapper (calls system librespot)
    dodir /usr/bin
    cat > "${ED}"/usr/bin/raspotify << 'EOF'
#!/bin/sh
# Simple wrapper to run system librespot with config from /etc/raspotify
CONF=/etc/raspotify/config
[ -f "$CONF" ] && . "$CONF"
# Defaults
: "${LIBRESPOT_BIN:=/usr/bin/librespot}"
: "${NAME:=raspotify}"
: "${BITRATE:=160}"
: "${BACKEND:=alsa}"
exec "${LIBRESPOT_BIN}" --name "${NAME}" --bitrate "${BITRATE}" --backend "${BACKEND}" "$@"
EOF
    chmod 0755 "${ED}"/usr/bin/raspotify

    # Install default config
    dodir /etc/raspotify
    cat > "${ED}"/etc/raspotify/config << 'EOF'
# /etc/raspotify/config
# Example settings:
LIBRESPOT_BIN=/usr/bin/librespot
NAME="raspotify on gentoo"
BITRATE=160
BACKEND=alsa
# Add extra args: EXTRA_ARGS="--device hw:0"
EOF
    chmod 0644 "${ED}"/etc/raspotify/config

    if use systemd; then
   systemd_dounit "${FILESDIR}/ollama.service"
   fi
    # docs/examples
    if use examples; then
        dodir /usr/share/doc/${PF}
        insinto /usr/share/doc/${PF}
        doins README.md
    fi
}

pkg_postinst() {
    # create user/group if needed (systemd user may be different)
    if use systemd; then
        elog "Enable the service with: systemctl enable --now raspotify.service"
    else
        elog "Start raspotify with: /usr/bin/raspotify &"
    fi
}
