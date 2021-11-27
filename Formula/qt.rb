class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.1/single/qt-everywhere-src-6.2.1.tar.xz"
  sha256 "e03fffc5c3b5fea09dcc161444df7dfbbe24e8a8ce9377014ec21b66f48d43cd"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qt5.git", branch: "dev"

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5ad884d3bedbf5542c52a80bf152f54745ffe380031f14434a8182bc74cbdb28"
    sha256 cellar: :any,                 arm64_big_sur:  "364565426ee2c9705605b0399b380c294e9fa9950ec53532fe7f9f10842c7c17"
    sha256 cellar: :any,                 monterey:       "395e2d015c222231f7b98a9dba9f807b0bae45136018ba06a6b1198e857a8e9c"
    sha256 cellar: :any,                 big_sur:        "9fab2511823cbd1c1b725055a62de9b330ae8cbd6df705195dbbeadb242de6a8"
    sha256 cellar: :any,                 catalina:       "948e7e7b155f2f3f876d9b879deee284d7a080d6016cb87e54c905b0cd0ec6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62a0afcb76f2b19351886a01515a97a300451372e37ad452e0dea230423f68f0"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "ninja"      => :build
  depends_on "node"       => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build

  depends_on "assimp"
  depends_on "brotli"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "hunspell"
  depends_on "icu4c"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libb2"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "md4c"
  depends_on "pcre2"
  depends_on "python@3.9"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "perl"  => :build

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "at-spi2-core"
    # TODO: depends_on "bluez"
    # TODO: depends_on "ffmpeg"
    depends_on "fontconfig"
    depends_on "gcc"
    depends_on "gperf"
    depends_on "gstreamer"
    # TODO: depends_on "gypsy"
    depends_on "harfbuzz"
    # TODO: depends_on "libevent"
    depends_on "libxkbcommon"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libxcomposite"
    depends_on "libdrm"
    # TODO: depends_on "libvpx"
    # TODO: depends_on "little-cms2"
    depends_on "mesa"
    # TODO: depends_on "minizip"
    # TODO: depends_on "opus"
    depends_on "pulseaudio"
    # TODO: depends_on "re2"
    depends_on "sdl2"
    # TODO: depends_on "snappy"
    depends_on "systemd"
    depends_on "xcb-util"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
    depends_on "wayland"
  end

  fails_with gcc: "5"

  # Fix build with assimp 5.1.
  # Remove with 6.3.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0bfbbefc45142ec9be248ed66229782138bc7bc1/qt/qtquick3d-assimp-5.1.patch"
    sha256 "31ae338ebcea3e423f3f10b9bc470ba3b46b0e35dd2b5ae1c067025f6bc0c109"
    directory "qtquick3d"
  end

  # Fix build with Xcode 13+ and a performance regression. Already merged and should be removed in next release.
  patch :DATA

  def install
    # FIXME: GN requires clang in clangBasePath/bin
    inreplace "qtwebengine/src/3rdparty/chromium/build/toolchain/mac/BUILD.gn",
        'rebase_path("$clang_base_path/bin/", root_build_dir)', '""'
    # FIXME: See https://bugreports.qt.io/browse/QTBUG-89559
    # and https://codereview.qt-project.org/c/qt/qtbase/+/327393
    # It is not friendly to Homebrew or macOS
    # because on macOS `/tmp` -> `/private/tmp`
    inreplace "qtwebengine/src/3rdparty/gn/src/base/files/file_util_posix.cc",
              "FilePath(full_path)", "FilePath(input)"
    %w[
      qtbase/CMakeLists.txt
      qtwebengine/cmake/Gn.cmake
      qtwebengine/cmake/Functions.cmake
      qtwebengine/src/core/api/CMakeLists.txt
      qtwebengine/src/CMakeLists.txt
      qtwebengine/src/gn/CMakeLists.txt
      qtwebengine/src/process/CMakeLists.txt
    ].each { |s| inreplace s, "REALPATH", "ABSOLUTE" }

    config_args = %W[
      -release

      -prefix #{HOMEBREW_PREFIX}
      -extprefix #{prefix}

      -archdatadir share/qt
      -datadir share/qt
      -examplesdir share/qt/examples
      -testsdir share/qt/tests

      -no-feature-relocatable
      -system-sqlite

      -no-sql-mysql
      -no-sql-odbc
      -no-sql-psql
    ]

    config_args << "-sysroot" << MacOS.sdk_path.to_s if OS.mac?
    # TODO: Enable qtwebengine on Linux when qt's chromium >= 93
    # NOTE: `chromium` should be built with the latest SDK because it uses
    # `___builtin_available` to ensure compatibility.
    config_args << "-skip" << "qtwebengine" if OS.linux? || (DevelopmentTools.clang_build_version <= 1200)

    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST") + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}

      -DINSTALL_MKSPECSDIR=share/qt/mkspecs

      -DFEATURE_pkg_config=ON
    ]

    if OS.linux?
      # Explicitly specify QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX so
      # that cmake does not think $HOMEBREW_PREFIX/lib is the install prefix.
      cmake_args << "-DQT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX=#{prefix}"

      # Change default mkspec for qmake on Linux to use brewed GCC
      inreplace "qtbase/mkspecs/common/g++-base.conf", "$${CROSS_COMPILE}gcc", ENV.cc
      inreplace "qtbase/mkspecs/common/g++-base.conf", "$${CROSS_COMPILE}g++", ENV.cxx
    end

    system "./configure", *config_args, "--", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    rm bin/"qt-cmake-private-install.cmake"

    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", Superenv.shims_path, ""

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    # Tracking issues:
    # https://bugreports.qt.io/browse/QTBUG-86080
    # https://gitlab.kitware.com/cmake/cmake/-/merge_requests/6363
    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
    end

    if OS.mac?
      bin.glob("*.app") do |app|
        libexec.install app
        bin.write_exec_script libexec/app.basename/"Contents/MacOS"/app.stem
      end
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Core Widgets Sql Concurrent
        3DCore Svg Quick3D Network NetworkAuth REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::Widgets
        Qt6::Sql Qt6::Concurrent Qt6::3DCore Qt6::Svg Qt6::Quick3D
        Qt6::Network Qt6::NetworkAuth
      )
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core svg 3dcore network networkauth quick3d \
        sql
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #undef QT_NO_DEBUG
      #include <QCoreApplication>
      #include <Qt3DCore>
      #include <QtQuick3D>
      #include <QImageReader>
      #include <QtNetworkAuth>
      #include <QtSql>
      #include <QtSvg>
      #include <QDebug>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        QSvgGenerator generator;
        auto *handler = new QOAuthHttpServerReplyHandler();
        delete handler; handler = nullptr;
        auto *root = new Qt3DCore::QEntity();
        delete root; root = nullptr;
        Q_ASSERT(QSqlDatabase::isDriverAvailable("QSQLITE"));
        const auto &list = QImageReader::supportedImageFormats();
        for(const char* fmt:{"bmp", "cur", "gif",
          #ifdef __APPLE__
            "heic", "heif",
          #endif
          "icns", "ico", "jp2", "jpeg", "jpg", "pbm", "pgm", "png",
          "ppm", "svg", "svgz", "tga", "tif", "tiff", "wbmp", "webp",
          "xbm", "xpm"}) {
          Q_ASSERT(list.contains(fmt));
        }
        return 0;
      }
    EOS

    system "cmake", testpath
    system "make"
    system "./test"

    ENV.delete "CPATH" unless MacOS.version <= :mojave
    system bin/"qmake", testpath/"test.pro"
    system "make"
    system "./test"
  end
end

__END__
diff --git a/qtbase/src/plugins/platforms/cocoa/qiosurfacegraphicsbuffer.h b/src/plugins/platforms/cocoa/qiosurfacegraphicsbuffer.h
index 5d4b6d6a71..cc7193d8b7 100644
--- a/qtbase/src/plugins/platforms/cocoa/qiosurfacegraphicsbuffer.h
+++ b/qtbase/src/plugins/platforms/cocoa/qiosurfacegraphicsbuffer.h
@@ -43,6 +43,7 @@
 #include <qpa/qplatformgraphicsbuffer.h>
 #include <private/qcore_mac_p.h>
 
+#include <CoreGraphics/CGColorSpace.h>
 #include <IOSurface/IOSurface.h>
 
 QT_BEGIN_NAMESPACE

---
 qtbase/src/widgets/widgets/qscrollarea.cpp | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/qtbase/src/widgets/widgets/qscrollarea.cpp b/src/widgets/widgets/qscrollarea.cpp
index f880240ea72..e8fdadb6483 100644
--- a/qtbase/src/widgets/widgets/qscrollarea.cpp
+++ b/qtbase/src/qtbase/widgets/widgets/qscrollarea.cpp
@@ -203,10 +203,13 @@ void QScrollAreaPrivate::updateScrollBars()
             if (vbarpolicy == Qt::ScrollBarAsNeeded) {
                 int vbarWidth = vbar->sizeHint().width();
                 QSize m_hfw = m.expandedTo(min).boundedTo(max);
-                while (h > m.height() && vbarWidth) {
-                    --vbarWidth;
-                    --m_hfw.rwidth();
-                    h = widget->heightForWidth(m_hfw.width());
+                // is there any point in searching?
+                if (widget->heightForWidth(m_hfw.width() - vbarWidth) <= m.height()) {
+                    while (h > m.height() && vbarWidth) {
+                        --vbarWidth;
+                        --m_hfw.rwidth();
+                        h = widget->heightForWidth(m_hfw.width());
+                    }
                 }
                 max = QSize(m_hfw.width(), qMax(m_hfw.height(), h));
             }
