EAPI=8
inherit cargo git-r3

DESCRIPTION="Open source Spotify client library (librespot)"
HOMEPAGE="https://github.com/librespot-org/librespot"
EGIT_REPO_URI="https://github.com/librespot-org/librespot.git"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

LICENSE="MIT"
IUSE="alsa pulseaudio jack +pipewire examples"

DEPEND="dev-lang/rust dev-util/cargo-c sys-devel/gcc dev-libs/openssl dev-vcs/git"
RDEPEND="${DEPEND}
    media-libs/alsa-lib 
    media-libs/libpulse
    media-sound/jack
    media-video/pipewire
"

src_compile() {
    export CARGO_HOME="${WORKDIR}/.cargo"
    cd "${S}" || die "cannot enter source dir"

    # Mappe USE flags auf gewünschte Feature-Namen (links USE, rechts gewünschter cargo-feature-name)
    declare -A MAP
    MAP[alsa]="alsa-backend"
    MAP[pulseaudio]="pulseaudio-backend"
    MAP[pipewire]="pipewire-backend"
    MAP[jack]="jack-backend"

    # Lese verfügbare Features aus Cargo.toml
    local available_features
    available_features=$(sed -n '/^

\[features\]

/,/^

\[/{/^

\[features\]

/d;p}' Cargo.toml | sed 's/ *=.*//g' | tr -d ' ' | tr '\n' ' ')
    # available_features enthält z.B. "default alsa-backend pulseaudio-backend"

    local cargo_features=""
    for useflag in alsa pulseaudio pipewire jack; do
        if use "${useflag}"; then
            local want="${MAP[${useflag}]}"
            # prüfe, ob das gewünschte Feature in Cargo.toml vorhanden ist
            if echo "${available_features}" | grep -qw "${want}"; then
                cargo_features+=" ${want}"
            else
                ewarn "Requested USE=${useflag} but cargo feature '${want}' not found; skipping"
            fi
        fi
    done

    # Trim leading whitespace
    cargo_features="${cargo_features## }"

    if [ -n "${cargo_features}" ]; then
        cargo build --release --features="${cargo_features}"
    else
        cargo build --release
    fi
}


src_install() {
    dodir /usr/bin
    dobin target/release/librespot
}
