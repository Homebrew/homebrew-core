class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.1/single/qt-everywhere-src-6.0.1.tar.xz"
  mirror "http://mirror.bit.edu.cn/qtproject/official_releases/qt/6.0/6.0.1/single/qt-everywhere-src-6.0.1.tar.xz"
  mirror "http://ftp.jaist.ac.jp/pub/qtproject/official_releases/qt/6.0/6.0.1/single/qt-everywhere-src-6.0.1.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/official_releases/qt/6.0/6.0.1/single/qt-everywhere-src-6.0.1.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/official_releases/qt/6.0/6.0.1/single/qt-everywhere-src-6.0.1.tar.xz"
  sha256 "d13cfac103cd80b216cd2f73d0211dd6b1a1de2516911c89ce9c5ed14d9631a8"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qt5.git", branch: "dev", shallow: false

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "049a78d3f84586a28d9d035bc5ff1a677b0dd9bd8c81b5775919591cde99f258"
    sha256 cellar: :any, big_sur:       "ac22ab5828d894518e42f00e254f1e36d5be4e5f3f1c08b3cd49b57819daaf2d"
    sha256 cellar: :any, catalina:      "51ab78a99ff3498a236d15d9bed92962ddd2499c4020356469f7ab1090cf6825"
    sha256 cellar: :any, mojave:        "25c4a693c787860b090685ac5cbeea18128d4d6361eed5b1bfed1b16ff6e4494"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build

  depends_on "assimp"
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
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "perl"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  resource "qtimageformats" do
    url "https://download.qt.io/official_releases/additional_libraries/qtimageformats/6.0/6.0.1/qtimageformats-everywhere-src-6.0.1.tar.xz"
    mirror "http://mirror.bit.edu.cn/qtproject/official_releases/additional_libraries/qtimageformats/6.0/6.0.1/qtimageformats-everywhere-src-6.0.1.tar.xz"
    mirror "http://ftp.jaist.ac.jp/pub/qtproject/official_releases/additional_libraries/qtimageformats/6.0/6.0.1/qtimageformats-everywhere-src-6.0.1.tar.xz"
    mirror "https://mirrors.dotsrc.org/qtproject/official_releases/additional_libraries/qtimageformats/6.0/6.0.1/qtimageformats-everywhere-src-6.0.1.tar.xz"
    mirror "https://mirrors.ocf.berkeley.edu/qt/official_releases/additional_libraries/qtimageformats/6.0/6.0.1/qtimageformats-everywhere-src-6.0.1.tar.xz"
    sha256 "27a9d6e85dcd56ad981ef2aac27844e782f8cce0598f83283e6fbbd2a3810105"
  end

  resource "qt3d" do
    url "https://download.qt.io/official_releases/additional_libraries/qt3d/6.0/6.0.1/qt3d-everywhere-src-6.0.1.tar.xz"
    mirror "http://mirror.bit.edu.cn/qtproject/official_releases/additional_libraries/qt3d/6.0/6.0.1/qt3d-everywhere-src-6.0.1.tar.xz"
    mirror "http://ftp.jaist.ac.jp/pub/qtproject/official_releases/additional_libraries/qt3d/6.0/6.0.1/qt3d-everywhere-src-6.0.1.tar.xz"
    mirror "https://mirrors.dotsrc.org/qtproject/official_releases/additional_libraries/qt3d/6.0/6.0.1/qt3d-everywhere-src-6.0.1.tar.xz"
    mirror "https://mirrors.ocf.berkeley.edu/qt/official_releases/additional_libraries/qt3d/6.0/6.0.1/qt3d-everywhere-src-6.0.1.tar.xz"
    sha256 "1234c6904ad13894fb1a798a5540317d241b5cbded70e980e929f477bc060f34"
  end

  resource "qtnetworkauth" do
    url "https://download.qt.io/official_releases/additional_libraries/qtnetworkauth/6.0/6.0.1/qtnetworkauth-everywhere-src-6.0.1.tar.xz"
    mirror "http://mirror.bit.edu.cn/qtproject/official_releases/additional_libraries/qtnetworkauth/6.0/6.0.1/qtnetworkauth-everywhere-src-6.0.1.tar.xz"
    mirror "http://ftp.jaist.ac.jp/pub/qtproject/official_releases/additional_libraries/qtnetworkauth/6.0/6.0.1/qtnetworkauth-everywhere-src-6.0.1.tar.xz"
    mirror "https://mirrors.dotsrc.org/qtproject/official_releases/additional_libraries/qtnetworkauth/6.0/6.0.1/qtnetworkauth-everywhere-src-6.0.1.tar.xz"
    mirror "https://mirrors.ocf.berkeley.edu/qt/official_releases/additional_libraries/qtnetworkauth/6.0/6.0.1/qtnetworkauth-everywhere-src-6.0.1.tar.xz"
    sha256 "7f348acedb24e7c33927bd475b87b3c0c9901122f2e11f8c8209de4497e36122"
  end

  def install
    resources.each { |addition| addition.stage buildpath/addition.name }

    config_args = %W[
      -release

      -prefix #{HOMEBREW_PREFIX}
      -extprefix #{prefix}

      -libexecdir share/qt/libexec
      -plugindir share/qt/plugins
      -qmldir share/qt/qml
      -docdir share/doc/qt
      -examplesdir share/qt/examples
      -testsdir share/qt/tests

      -libproxy
      -no-feature-relocatable
      -system-sqlite
    ]

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"]||s["CMAKE_FIND_FRAMEWORK"] } + %W[
      -DICU_ROOT=#{Formula["icu4c"].opt_prefix}

      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_FIND_FRAMEWORK=FIRST

      -DINSTALL_MKSPECSDIR=share/qt/mkspecs
      -DINSTALL_DESCRIPTIONSDIR=share/qt/modules
      -DINSTALL_TRANSLATIONSDIR=share/qt/translations

      -DFEATURE_pkg_config=ON
      -DFEATURE_qt3d_system_assimp=ON
      -DTEST_assimp=ON
    ]

    system "./configure", *config_args, "--", *cmake_args
    system "ninja"
    system "ninja", "install"

    rm bin/"qt-cmake-private-install.cmake"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", /.*set.__qt_initial_.*/, ""

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
      cmake_minimum_required(VERSION 3.19.0)

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

    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete "CPATH"
    system bin/"qmake", testpath/"test.pro"
    system "make"
    system "./test"
  end
end
