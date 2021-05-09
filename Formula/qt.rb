class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.0/single/qt-everywhere-src-6.1.0.tar.xz"
  sha256 "326a710b08b0973bb4f5306a786548d8b8dd656db75ce9f3f85ea32680d3c88a"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  revision 1
  head "https://code.qt.io/qt/qt5.git", branch: "dev", shallow: false

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d92bf028663a2d629ac6529de4132afcf22d33a6566419a963cc2fd4d10da38c"
    sha256 cellar: :any, big_sur:       "95a562a475ec0e0655c4b4b97d88c71e683b2f655bb430f39f18341d46d704fa"
    sha256 cellar: :any, catalina:      "0f2078af99de0d7b30a9bcd318d5505a8a14b819c0372bd2392edccb858d3900"
    sha256 cellar: :any, mojave:        "10948f967cc80adb8f03cce3b12514cbf46e2cf62b979d930ae5ab6e5e2a907c"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "ninja"      => :build
  depends_on "pkg-config" => :build
  depends_on xcode: [:build, :test] if MacOS.version <= :mojave

  depends_on "assimp"
  depends_on "brotli"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libb2"
  depends_on "libpng"
  depends_on "libproxy"
  depends_on "libtiff"
  depends_on "pcre2"
  depends_on "python@3.9"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  # TODO: remove them after 6.1.1
  # macdeployqt: Fix plugin resolution bugs for non-standard installs
  patch do
    url "https://code.qt.io/cgit/qt/qttools.git/patch/?id=03abcbabbd4caa11048d19d95b23f165cd7a5361"
    sha256 "b219a0e782b30b6942eed8ad5b0a5cf3be3dae08542a999e7c6f162cca24c4db"
    directory "qttools"
  end

  # macdeployqt: Fix bug parsing otool output when deploying plugins
  patch do
    url "https://code.qt.io/cgit/qt/qttools.git/patch/?id=7f3bcf85f1041e7e56dba37593dcd80f2054c221"
    sha256 "c34f4ef4d0047c7b60ec7ea40847bbfc3f8fa9a63a2f5ea9a38199caffdc7647"
    directory "qttools"
  end

  def install
    # FIXME: See https://bugreports.qt.io/browse/QTBUG-89559
    # and https://codereview.qt-project.org/c/qt/qtbase/+/327393
    # It is not friendly to Homebrew or macOS
    # because on macOS `/tmp` -> `/private/tmp`
    inreplace "qtbase/CMakeLists.txt", "FATAL_ERROR", ""

    config_args = %W[
      -release

      -prefix #{HOMEBREW_PREFIX}
      -extprefix #{prefix}
      -sysroot #{MacOS.sdk_path}

      -archdatadir share/qt
      -datadir share/qt
      -examplesdir share/qt/examples
      -testsdir share/qt/tests

      -libproxy
      -no-feature-relocatable
      -system-sqlite

      -no-sql-mysql
      -no-sql-odbc
      -no-sql-psql
    ]

    # TODO: remove `-DFEATURE_qt3d_system_assimp=ON`
    # and `-DTEST_assimp=ON` when Qt 6.2 is released.
    # See https://bugreports.qt.io/browse/QTBUG-91537
    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"]||s["CMAKE_FIND_FRAMEWORK"] } + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_FIND_FRAMEWORK=FIRST

      -DINSTALL_MKSPECSDIR=share/qt/mkspecs

      -DFEATURE_pkg_config=ON
      -DFEATURE_qt3d_system_assimp=ON
      -DTEST_assimp=ON
    ]

    system "./configure", *config_args, "--", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    rm bin/"qt-cmake-private-install.cmake"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", HOMEBREW_SHIMS_PATH/"mac/super", "/usr/bin"

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    mkdir libexec
    Pathname.glob("#{bin}/*.app") do |app|
      mv app, libexec
      bin.write_exec_script "#{libexec/app.stem}.app/Contents/MacOS/#{app.stem}"
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
        for(const char* fmt:{"bmp", "cur", "gif", "heic", "heif",
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
