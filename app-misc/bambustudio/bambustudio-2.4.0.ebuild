EAPI=8

inherit cmake xdg

DESCRIPTION="BambuStudio – Slicer für BambuLab Drucker"
HOMEPAGE="https://github.com/bambulab/BambuStudio"
SRC_URI="https://github.com/bambulab/BambuStudio/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="cuda wayland X webkit gstreamer system-wxwidgets opencl"

DEPEND="
    dev-build/cmake
    sys-devel/clang
    sys-devel/llvm

    # X11 / Wayland
    X? (
        x11-libs/libX11
        x11-libs/libXext
        x11-libs/libXrender
        x11-libs/libXfixes
        x11-libs/libXcursor
        x11-libs/libXi
        x11-libs/libXrandr
        x11-libs/libXcomposite
        x11-libs/libXdamage
    )
    wayland? (
        dev-libs/wayland
        dev-libs/wayland-protocols
        x11-libs/libxkbcommon
    )

    # Mesa / GL
    media-libs/mesa[opengl,${X?X},${wayland?wayland}]
    media-libs/libglvnd
    media-libs/glew

    # GTK
    x11-libs/gtk+:3

    # WebKit (optional)
    webkit? (
        net-libs/libsoup:2.4
        net-libs/webkit-gtk:4
    )

    # GStreamer (optional)
    gstreamer? (
        media-libs/gstreamer
        media-libs/gst-plugins-base
        media-libs/gst-plugins-good
        media-libs/gst-plugins-bad
    )

    # Image libs
    media-libs/libjpeg-turbo
    media-libs/libpng
    media-libs/libtiff
    media-libs/libwebp
    media-libs/libogg
    media-libs/libvorbis

    # Fonts
    media-libs/freetype
    media-libs/fontconfig

    # Video
    media-video/ffmpeg
    media-libs/libx264

    # Misc
    dev-libs/boost
    dev-libs/openssl
    dev-libs/cairo
    dev-libs/nasm
    dev-libs/yasm

    # Optional acceleration
    cuda? ( dev-util/nvidia-cuda-toolkit )
    opencl? ( virtual/opencl )

    # wxWidgets (optional system version)
    system-wxwidgets? ( x11-libs/wxGTK:3.2 )
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/BambuStudio-${PV}"

src_prepare() {
    cmake_src_prepare
}

src_configure() {
    local mycmakeargs=(
        -DSLIC3R_STATIC=ON
        -DSLIC3R_GTK=3
        -DBBL_RELEASE_TO_PUBLIC=1
        -DDEP_WX_GTK3=1
        -DUSE_SYSTEM_WXWIDGETS=$(usex system-wxwidgets ON OFF)
        -DUSE_CUDA=$(usex cuda ON OFF)
        -DUSE_OPENCL=$(usex opencl ON OFF)
        -DUSE_GSTREAMER=$(usex gstreamer ON OFF)
        -DUSE_WEBKIT=$(usex webkit ON OFF)
    )

    cmake_src_configure
}

src_install() {
    cmake_src_install
}
