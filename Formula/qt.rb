class Qt < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.1/single/qt-everywhere-src-6.3.1.tar.xz"
  sha256 "51114e789485fdb6b35d112dfd7c7abb38326325ac51221b6341564a1c3cc726"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qt5.git", branch: "dev"

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "598f26ecb661f8d2168d99bb220254ed9f9c4f3cfd9b135b6aea8850ac6f5ecc"
    sha256 cellar: :any,                 arm64_big_sur:  "73f030e5a99b55383ad97d84b06758cb11680735bde53fdd48ae28d43a32471e"
    sha256 cellar: :any,                 monterey:       "2d04aa7359c57aafe4365152b3e72dd8e5d07f576daf5f3c4d735bf4a808c7d9"
    sha256 cellar: :any,                 big_sur:        "41578f0535af372530321e83c3845602c5d866ebd8a09afaf7f832f88ae9ecd6"
    sha256 cellar: :any,                 catalina:       "16e395a1529fc1e94be2e8fb72f80dd723934376c26ef38e9e832c8419041276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2544b56149acd73cf4de6a283a39186cc340d966812085194ab3301c14d18f65"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "ninja"      => :build
  depends_on "node"       => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "six" => :build
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
  depends_on "jpeg-turbo"
  depends_on "libb2"
  depends_on "libmng"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "md4c"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "perl"  => :build

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "at-spi2-core"
    # TODO: depends_on "bluez"
    # TODO: depends_on "ffmpeg"
    depends_on "fontconfig"
    depends_on "gcc"
    depends_on "gstreamer"
    # TODO: depends_on "gypsy"
    depends_on "harfbuzz"
    depends_on "libdrm"
    depends_on "libevent"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libvpx"
    depends_on "libxcomposite"
    depends_on "libxkbcommon"
    depends_on "libxkbfile"
    depends_on "libxrandr"
    depends_on "libxtst"
    depends_on "little-cms2"
    depends_on "mesa"
    depends_on "minizip"
    depends_on "nss"
    depends_on "opus"
    depends_on "pulseaudio"
    depends_on "re2"
    depends_on "sdl2"
    depends_on "snappy"
    depends_on "systemd"
    depends_on "xcb-util"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
    depends_on "wayland"
  end

  fails_with gcc: "5"

  resource("html5lib") do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource("webencodings") do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  # Remove symlink check causing build to bail out and fail.
  # https://gitlab.kitware.com/cmake/cmake/-/issues/23251
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c363f0edf9e90598d54bc3f4f1bacf95abbda282/qt/qt_internal_check_if_path_has_symlinks.patch"
    sha256 "1afd8bf3299949b2717265228ca953d8d9e4201ddb547f43ed84ac0d7da7a135"
    directory "qtbase"
  end

  # Apply patch to fix chromium build with glibc < 2.27. See here for details:
  # https://libc-alpha.sourceware.narkive.com/XOENQFwL/add-fcntl-sealing-interfaces-from-linux-3-17-to-bits-fcntl-linux-h
  patch :DATA

  def install
    # Install python dependencies for QtWebEngine
    venv = virtualenv_create(buildpath/"venv", "python3")
    resources.each do |r|
      venv.pip_install r
    end
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", buildpath/"venv/lib/python#{xy}/site-packages"
    ENV.prepend_path "PATH", Formula["python@3.10"].libexec/"bin"

    # FIXME: GN requires clang in clangBasePath/bin
    inreplace "qtwebengine/src/3rdparty/chromium/build/toolchain/apple/toolchain.gni",
       'rebase_path("$clang_base_path/bin/", root_build_dir)', '""'

    # FIXME: See https://bugreports.qt.io/browse/QTBUG-89559
    # and https://codereview.qt-project.org/c/qt/qtbase/+/327393
    # It is not friendly to Homebrew or macOS
    # because on macOS `/tmp` -> `/private/tmp`
    inreplace "qtwebengine/src/3rdparty/gn/src/base/files/file_util_posix.cc",
              "FilePath(full_path)", "FilePath(input)"
    %w[
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

    if OS.mac?
      config_args << "-sysroot" << MacOS.sdk_path.to_s
      # NOTE: `chromium` should be built with the latest SDK because it uses
      # `___builtin_available` to ensure compatibility.
      config_args << "-skip" << "qtwebengine" if DevelopmentTools.clang_build_version <= 1200
    end

    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST") + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}

      -DINSTALL_MKSPECSDIR=share/qt/mkspecs

      -DFEATURE_pkg_config=ON

      -DQT_FEATURE_avx2=OFF

      -DQT_FEATURE_webengine_proprietary_codecs=ON
      -DQT_FEATURE_webengine_kerberos=ON
    ]

    unless OS.mac?
      # Explicitly specify QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX so
      # that cmake does not think $HOMEBREW_PREFIX/lib is the install prefix.
      cmake_args << "-DQT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX=#{prefix}"

      # Currently we have to use vendored ffmpeg because the chromium copy adds a symbol not
      # provided by the brewed version.
      # See here for an explanation of why upstream ffmpeg does not want to add this:
      # https://www.mail-archive.com/ffmpeg-devel@ffmpeg.org/msg124998.html
      # The vendored copy of libjpeg is also used instead of the brewed copy, because the build
      # fails due to a missing symbol otherwise.
      # On macOS chromium will always use bundled copies and the QT_FEATURE_webengine_system_*
      # arguments are ignored.
      cmake_args += %w[
        -DQT_FEATURE_webengine_system_alsa=ON
        -DQT_FEATURE_webengine_system_icu=ON
        -DQT_FEATURE_webengine_system_libevent=ON
        -DQT_FEATURE_webengine_system_libpng=ON
        -DQT_FEATURE_webengine_system_libxml=ON
        -DQT_FEATURE_webengine_system_libwebp=ON
        -DQT_FEATURE_webengine_system_minizip=ON
        -DQT_FEATURE_webengine_system_opus=ON
        -DQT_FEATURE_webengine_system_poppler=ON
        -DQT_FEATURE_webengine_system_pulseaudio=ON
        -DQT_FEATURE_webengine_system_zlib=ON
      ]

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
--- a/qtwebengine/src/3rdparty/chromium/base/macros.h
+++ b/qtwebengine/src/3rdparty/chromium/base/macros.h
@@ -36,6 +36,17 @@
 // work around this bug, wrap the entire expression in this macro...
 #define CR_EXPAND_ARG(arg) arg

+// Add constants from linux/fcntl.h which were not copied to glibc
+// bits/fcntl-linux.h until glibc 2.27.
+#ifndef F_ADD_SEALS
+#define F_ADD_SEALS 1033
+#define F_GET_SEALS 1034
+#define F_SEAL_SEAL 0x0001
+#define F_SEAL_SHRINK 0x0002
+#define F_SEAL_GROW 0x0004
+#define F_SEAL_WRITE 0x0008
+#endif
+
 // Used to explicitly mark the return value of a function as unused. If you are
 // really sure you don't want to do anything with the return value of a function
 // that has been marked WARN_UNUSED_RESULT, wrap it with this. Example:
