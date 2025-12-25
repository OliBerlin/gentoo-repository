# Copyright 2025
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="BambuStudio – Slicer für BambuLab Drucker"
HOMEPAGE="https://github.com/bambulab/BambuStudio"
EGIT_REPO_URI="https://github.com/bambulab/BambuStudio.git"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="cuda"

# Abhängigkeiten laut Linux-Compile-Guide
# Quelle: https://github.com/bambulab/BambuStudio/wiki/Linux-Compile-Guide
DEPEND="
    dev-util/cmake
    sys-devel/clang
    sys-devel/llvm
    dev-vcs/git
    x11-libs/libX11
    x11-libs/libXext
    x11-libs/libXrender
    x11-libs/libXfixes
    x11-libs/libXcursor
    x11-libs/libXi
    x11-libs/libXrandr
    x11-libs/libXcomposite
    x11-libs/libXdamage
    media-libs/mesa
    media-libs/mesa[egl,wayland,X]
    media-libs/libglvnd
    dev-libs/wayland
    dev-libs/wayland-protocols
    dev-libs/libxkbcommon
    x11-libs/gtk+:3
    net-libs/libsoup:2.4
    net-libs/webkit-gtk:4
    media-libs/gstreamer
    media-libs/gst-plugins-base
    media-libs/gst-plugins-good
    media-libs/gst-plugins-bad
    media-libs/libjpeg-turbo
    media-video/ffmpeg
    media-libs/libx264
    media-libs/glew
    media-libs/libpng
    media-libs/libtiff
    media-libs/libwebp
    media-libs/libogg
    media-libs/libvorbis
    media-libs/freetype
    media-libs/fontconfig
    dev-libs/boost
    dev-libs/openssl
    dev-libs/cairo
    dev-libs/nasm
    dev-libs/yasm
    cuda? ( dev-util/nvidia-cuda-toolkit )
"

RDEPEND="${DEPEND}"

src_prepare() {
    cmake_src_prepare
}

src_configure() {
    local mycmakeargs=(
        -DSLIC3R_STATIC=ON
        -DSLIC3R_GTK=3
        -DBBL_RELEASE_TO_PUBLIC=1
        -DDEP_WX_GTK3=1
    )

    if use cuda; then
        mycmakeargs+=( -DUSE_CUDA=ON )
    else
        mycmakeargs+=( -DUSE_CUDA=OFF )
    fi

    cmake_src_configure
}

src_install() {
    cmake_src_install
}
