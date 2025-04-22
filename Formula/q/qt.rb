class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.0/single/qt-everywhere-src-6.9.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.0/single/qt-everywhere-src-6.9.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.0/single/qt-everywhere-src-6.9.0.tar.xz"
  sha256 "4f61e50551d0004a513fefbdb0a410595d94812a48600646fb7341ea0d17e1cb"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "LGPL-3.0-only",
  ]
  revision 1
  head "https://code.qt.io/qt/qt5.git", branch: "dev"

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "861acfe809369d19c8cbc923afa94c62f48784f087a150e09d3522e5eeb15f9e"
    sha256 cellar: :any, arm64_ventura: "f30408e5e2a56aef97597398e4d552da3286b9fb45ba040e405291584009bea8"
    sha256 cellar: :any, sonoma:        "1cb92af62ec86c41bd6901428356fc8908ab98706a1f4b1e7791f09fd6cad498"
    sha256 cellar: :any, ventura:       "3f55e107498966094f5b47f6e729728c7cc97d503f9deed8c59d87ca9f69cfa4"
    sha256               arm64_linux:   "0f25abc1c0b90ec910b12b3d5c4db85e77e5f0888a2a8446f2d2dc5c973ede78"
    sha256               x86_64_linux:  "0f25abc1c0b90ec910b12b3d5c4db85e77e5f0888a2a8446f2d2dc5c973ede78"
  end

  depends_on "cmake" => [:build, :test]
  depends_on maximum_macos: [:sonoma, :build] # https://bugreports.qt.io/browse/QTBUG-128900
  depends_on "pkgconf" => [:build, :test]
  depends_on "vulkan-headers" => [:build, :test]
  depends_on "vulkan-loader" => [:build, :test]
  depends_on xcode: :build

  depends_on "assimp"
  depends_on "brotli"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "hunspell"
  depends_on "icu4c@77"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "libb2"
  depends_on "libmng"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "md4c"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk" => [:build, :test]
    depends_on "ninja" => :build
  end

  on_linux do
    # TODO: depends_on "bluez"
    depends_on "ffmpeg"
    depends_on "fontconfig"
    depends_on "gdk-pixbuf"
    depends_on "gstreamer"
    depends_on "gtk+3"
    # TODO: depends_on "gypsy"
    depends_on "libdrm"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxext"
    depends_on "libxkbcommon"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "pango"
    depends_on "pulseaudio"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "xcb-util-cursor"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"

    on_intel do
      depends_on "ninja" => :build
    end
  end

  def install
    rm_r(%w[
      qt3d/src/3rdparty/assimp/src
      qtbase/src/3rdparty/blake2/src
      qtbase/src/3rdparty/double-conversion
      qtbase/src/3rdparty/freetype
      qtbase/src/3rdparty/harfbuzz-ng
      qtbase/src/3rdparty/libjpeg
      qtbase/src/3rdparty/libpng
      qtbase/src/3rdparty/md4c
      qtbase/src/3rdparty/pcre2
      qtbase/src/3rdparty/sqlite
      qtbase/src/3rdparty/xcb
      qtbase/src/3rdparty/zlib
      qtimageformats/src/3rdparty/libtiff
      qtimageformats/src/3rdparty/libwebp
      qtquick3d/src/3rdparty/assimp
      qtvirtualkeyboard/src/plugins/hunspell/3rdparty/hunspell
      qtwebengine
      qtwebview
    ])

    # Allow -march options to be passed through, as Qt builds
    # arch-specific code with runtime detection of capabilities:
    # https://bugreports.qt.io/browse/QTBUG-113391
    ENV.runtime_cpu_detection

    # Modify Assistant path as we manually move `*.app` bundles from `bin` to `libexec`.
    # This fixes invocation of Assistant via the Help menu of apps like Designer and
    # Linguist as they originally relied on Assistant.app being in `bin`.
    assistant_files = %w[
      qttools/src/designer/src/designer/assistantclient.cpp
      qttools/src/linguist/linguist/mainwindow.cpp
    ]
    inreplace assistant_files, '"Assistant.app/Contents/MacOS/Assistant"', '"Assistant"'

    # We disable clang feature to avoid linkage to `llvm`. This is how we have always
    # built on macOS and it prevents complicating `llvm` version bumps on Linux.
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST") + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DINSTALL_ARCHDATADIR=share/qt
      -DINSTALL_DATADIR=share/qt
      -DINSTALL_EXAMPLESDIR=share/qt/examples
      -DINSTALL_MKSPECSDIR=share/qt/mkspecs
      -DINSTALL_TESTSDIR=share/qt/tests

      -DBUILD_qtwebengine=OFF
      -DFEATURE_clang=OFF
      -DFEATURE_relocatable=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=OFF

      -DFEATURE_pkg_config=ON
      -DFEATURE_system_assimp=ON
      -DFEATURE_system_doubleconversion=ON
      -DFEATURE_system_freetype=ON
      -DFEATURE_system_harfbuzz=ON
      -DFEATURE_system_hunspell=ON
      -DFEATURE_system_jpeg=ON
      -DFEATURE_system_libb2=ON
      -DFEATURE_system_pcre2=ON
      -DFEATURE_system_png=ON
      -DFEATURE_system_sqlite=ON
      -DFEATURE_system_tiff=ON
      -DFEATURE_system_webp=ON
      -DFEATURE_system_zlib=ON
      -DQT_ALLOW_SYMLINK_IN_PATHS=ON
    ]

    cmake_args += if OS.mac?
      %W[
        -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}.0
        -DFEATURE_ffmpeg=OFF
      ]
    else
      %w[
        -DFEATURE_xcb=ON
        -DFEATURE_system_xcb_xinput=ON
      ]
    end

    cmake_args += ["-G", "Ninja"] if OS.mac? || Hardware::CPU.intel?

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", "#{Superenv.shims_path}/", ""

    # Install a qtversion.xml to ease integration with QtCreator
    # As far as we can tell, there is no ability to make the Qt buildsystem
    # generate this and it's in the Qt source tarball at all.
    # Multiple people on StackOverflow have asked for this and it's a pain
    # to add Qt to QtCreator (the official IDE) without it.
    # Given Qt upstream seems extremely unlikely to accept this: let's ship our
    # own version.
    # If you read this and you can eliminate it or upstream it: please do!
    # More context in https://github.com/Homebrew/homebrew-core/pull/124923
    (share/"qtcreator/QtProject/qtcreator/qtversion.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE QtCreatorQtVersions>
      <qtcreator>
      <data>
        <variable>QtVersion.0</variable>
        <valuemap type="QVariantMap">
        <value type="int" key="Id">1</value>
        <value type="QString" key="Name">Qt %{Qt:Version} (#{HOMEBREW_PREFIX})</value>
        <value type="QString" key="QMakePath">#{opt_bin}/qmake</value>
        <value type="QString" key="QtVersion.Type">Qt4ProjectManager.QtVersion.Desktop</value>
        <value type="QString" key="autodetectionSource"></value>
        <value type="bool" key="isAutodetected">false</value>
        </valuemap>
      </data>
      <data>
        <variable>Version</variable>
        <value type="int">1</value>
      </data>
      </qtcreator>
    XML

    return unless OS.mac?

    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      # Some dependents' test use include path (e.g. `gecode` and `qwt`)
      include.install_symlink f/"Headers" => f.stem
    end

    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexec/app.basename/"Contents/MacOS"/app.stem
    end
  end

  def caveats
    <<~EOS
      You can add Homebrew's Qt to QtCreator's "Qt Versions" in:
        Preferences > Qt Versions > Link with Qt...
      pressing "Choose..." and selecting as the Qt installation path:
        #{HOMEBREW_PREFIX}

      Qt WebEngine is now in the `qt-webengine` formula.
      Qt WebView is now in the `qt-webview` formula.
    EOS
  end

  test do
    modules = %w[Core Gui Widgets Sql Concurrent 3DCore Svg Quick3D Network NetworkAuth]

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 REQUIRED COMPONENTS #{modules.join(" ")})
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::#{modules.join(" Qt6::")})
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT += #{modules.join(" ").downcase}
      TARGET = test
      CONFIG += console
      CONFIG -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
      INCLUDEPATH += #{Formula["vulkan-headers"].opt_include}
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QCoreApplication>
      #include <Qt3DCore>
      #include <QtQuick3D>
      #include <QImageReader>
      #include <QtNetworkAuth>
      #include <QtSql>
      #include <QtSvg>
      #include <QDebug>
      #include <QVulkanInstance>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        QCoreApplication app(argc, argv);
        QSvgGenerator generator;
        auto *handler = new QOAuthHttpServerReplyHandler();
        delete handler; handler = nullptr;
        auto *root = new Qt3DCore::QEntity();
        delete root; root = nullptr;
        Q_ASSERT(QSqlDatabase::isDriverAvailable("QSQLITE"));
        const auto &list = QImageReader::supportedImageFormats();
        QVulkanInstance inst;
        // See https://github.com/actions/runner-images/issues/1779
        // if (!inst.create())
        //   qFatal("Failed to create Vulkan instance: %d", inst.errorCode());
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
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_VULKAN_LIB"] = Formula["vulkan-loader"].opt_lib/shared_library("libvulkan")
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6#{modules.join(" Qt6")}").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"

    # Check QT_INSTALL_PREFIX is HOMEBREW_PREFIX to support split `qt-*` formulae
    assert_equal HOMEBREW_PREFIX.to_s, shell_output("#{bin}/qmake -query QT_INSTALL_PREFIX").chomp
  end
end
