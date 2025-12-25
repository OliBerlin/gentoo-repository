EAPI=8

inherit cmake xdg git-r3
# Git-Repo 
EGIT_REPO_URI="https://github.com/bambulab/BambuStudio.git" # Tag automatisch aus PV erzeugen # PV = 02.02.02.56 → Tag = v02.02.02.56 
EGIT_TAG="v${PV}" 
LICENSE="AGPL-3" 
SLOT="0" 
KEYWORDS="~amd64"


IUSE="cuda wayland X webkit gstreamer system-wxwidgets opencl"

DEPEND="
    dev-build/cmake
    media-libs/glfw
    dev-libs/cereal
    sci-libs/nlopt
    sci-mathematics/cgal
    sci-libs/opencascade
    media-libs/opencv
    dev-cpp/tbb
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

    media-libs/mesa[opengl]
    X? ( media-libs/mesa[X] )
    wayland? ( media-libs/mesa[wayland] )

    media-libs/libglvnd
    media-libs/glew

    x11-libs/gtk+:3

    webkit? (
        net-libs/libsoup:2.4
        net-libs/webkit-gtk
    )

    gstreamer? (
        media-libs/gstreamer
        media-libs/gst-plugins-base
        media-libs/gst-plugins-good
        media-libs/gst-plugins-bad
    )

    media-libs/libjpeg-turbo
    media-libs/libpng
    media-libs/tiff     
    media-libs/libwebp
    media-libs/libogg
    media-libs/libvorbis

    media-libs/freetype
    media-libs/fontconfig

    media-video/ffmpeg
    media-libs/x264

    dev-libs/boost
    dev-libs/openssl
    x11-libs/cairo
    dev-lang/nasm
    dev-lang/yasm

    cuda? ( dev-util/nvidia-cuda-toolkit )
    opencl? ( virtual/opencl )
    system-wxwidgets? ( x11-libs/wxGTK )
"




RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

src_prepare() {
    eapply "${FILESDIR}/boost-shared.patch"
    eapply "${FILESDIR}/glew-shared.patch"
    eapply "${FILESDIR}/openvdb-optional.patch"
    eapply "${FILESDIR}/disable-ffmpeg-copy.patch"
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
        -DBoost_USE_STATIC_LIBS=OFF
        -DGLEW_USE_STATIC_LIBS=OFF
        -DGLEW_USE_STATIC_LIBS=OFF
        -DGLEW_LIBRARY=/usr/lib64/libGLEW.so
        -DGLEW_LIBRARIES=/usr/lib64/libGLEW.so
        -DGLEW_SHARED_LIBRARY=/usr/lib64/libGLEW.so)
    cmake_src_configure
}

src_install() {
    cmake_src_install
}
