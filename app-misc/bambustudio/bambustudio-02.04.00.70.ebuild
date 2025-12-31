EAPI=8

inherit cmake xdg git-r3
# Git-Repo 
EGIT_REPO_URI="https://github.com/bambulab/BambuStudio.git" # Tag automatisch aus PV erzeugen # PV = 02.02.02.56 → Tag = v02.02.02.56 
EGIT_TAG="v${PV}" 
LICENSE="AGPL-3" 
SLOT="0" 
KEYWORDS="~amd64"


IUSE="opencv"

DEPEND="
    dev-build/cmake
media-libs/opencv[contrib]
    media-video/ffmpeg
    dev-cpp/tbb
    media-libs/glew
    media-libs/glfw
    dev-libs/cereal
    sci-libs/nlopt
    media-gfx/openvdb
    sci-mathematics/cgal
    sci-libs/opencascade
    x11-libs/wxGTK
    media-libs/qhull
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

src_prepare() {
        filter-flags -Werror -Werror=return-type
    # apply OpenVDB patch always
    eapply "${FILESDIR}/openvdb-optional.patch"
    eapply "${FILESDIR}/disable-internal-qhull.patch"
    #eapply "${FILESDIR}/disable-werror-return-type.patch"
    #eapply "${FILESDIR}/disable-werror-clipper2.patch" 
    #eapply "${FILESDIR}/disable-werror-earcut.patch"
    #eapply "${FILESDIR}/compat-cgal.patch"
    
    eapply "${FILESDIR}/disable-ffmpeg-copy.patch"
    
    perl -0777 -pe 's/(property_map<[^>]+>\([^)]*\))\.first/$1.value()/g' -i src/libslic3r/CutSurface.cpp 
    perl -0777 -pe 's/\bCGAL::AABB_traits\b/CGAL::AABB_traits_3/g' -i src/libslic3r/CutSurface.cpp
    cmake_src_prepare
}

src_configure() {
    $(cmake_use_find_package opencv opencv)
    local mycmakeargs=(
        -DSLIC3R_STATIC=OFF
        -DSLIC3R_GUI=1
        -DSLIC3R_FHS=1
        -DSLIC3R_WX_STABLE=0
        -DSLIC3R_GTK=3
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        -DwxWidgets_CONFIG_EXECUTABLE=/usr/bin/wx-config-3.2 
    #    -DwxWidgets_USE_UNICODE=ON 
     #   -DwxWidgets_USE_STATIC=OFF 
     #   -DwxWidgets_COMPONENTS="core;base;html;xrc;net;xml"
     #   -DOpenCV_INCLUDE_DIRS=/usr/include/opencv4
     #   -DOpenCV_DIR=/usr/lib64/cmake/opencv4
 
    )
    cmake_src_configure
}

src_install() {
    cmake_src_install
}
