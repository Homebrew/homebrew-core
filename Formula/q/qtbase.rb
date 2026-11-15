class Qtbase < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qmake
    "BSD-3-Clause", # *.cmake
    "GFDL-1.3-no-invariants-only", # *.qdoc
  ]
  revision 2
  compatibility_version 1
  head "https://code.qt.io/qt/qtbase.git", branch: "dev"

  stable do
    url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtbase-everywhere-src-6.12.0.tar.xz"
    mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtbase-everywhere-src-6.12.0.tar.xz"
    mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtbase-everywhere-src-6.12.0.tar.xz"
    sha256 "a951bd163c7b80fc6b8c88d7668fb56abf91c152373e13c10666763238131307"

    # Backport to support md4c 0.6.0
    patch do
      url "https://github.com/qt/qtbase/commit/032643f99e090e0304ef935c2ee11c109d55c8a1.patch?full_index=1"
      sha256 "6870a711a6fb7ce6367f541e10ec9fe2785bd7d7484a2b1759b8d1f082a3f09f"
      type :backport
    end

    # Fix `#include_next` forwarding headers when the framework path precedes them
    patch do
      url "https://github.com/qt/qtbase/commit/8c260a771ab1ed7d6cdb5f221854ee470e5790a6.patch?full_index=1"
      sha256 "07742a103f8928457f7df8140a0f88589980f81670ab0b6c646b19dc8cc36344"
      type :cherry_pick
      resolves "https://codereview.qt-project.org/c/qt/qtbase/+/776003"
    end
  end

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "178ff42e7d82f5ed7c6164f6c7c4e8b735e03a4b61bd96eb970341f7329214fb"
    sha256 cellar: :any, arm64_tahoe:       "27e5c88a59fa45e3b8b5628d739d64a7bbd57c384db9501936ddefaf6352e08a"
    sha256 cellar: :any, arm64_sequoia:     "78614b676f994884c49c04f304fabb9320221adbb6769f64b02c3e5cca788edc"
    sha256 cellar: :any, arm64_linux:       "89245deeafff3534c572db16a65f594d63b91d8c2ddf6157b1194272feb3389b"
    sha256 cellar: :any, x86_64_linux:      "9e9e6d80b450c24ea3d924543016d50d59936e6d7803c200ea2b044de1d4dda0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vulkan-headers" => [:build, :test]

  depends_on "brotli"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "icu4c@79"
  depends_on "jpeg-turbo"
  depends_on "libb2"
  depends_on "libpng"
  depends_on "md4c"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "molten-vk" => :build
  end

  on_linux do
    depends_on "fontconfig"
    depends_on "gdk-pixbuf"
    depends_on "gtk+3"
    depends_on "libdrm"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "pango"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "xcb-util-cursor"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
    depends_on "zlib-ng-compat"

    # https://github.com/orgs/Homebrew/discussions/6468#discussioncomment-14687372
    pour_bottle? only_if: :default_prefix
  end

  conflicts_with "qt@5", because: "both link conflicting binaries"

  deny_network_access!

  def install
    # Allow -march options to be passed through, as Qt builds
    # arch-specific code with runtime detection of capabilities:
    # https://bugreports.qt.io/browse/QTBUG-113391
    ENV.runtime_cpu_detection

    # Remove bundled libraries
    rm_r(%w[
      src/3rdparty/double-conversion
      src/3rdparty/freetype
      src/3rdparty/harfbuzz-ng
      src/3rdparty/libjpeg
      src/3rdparty/libpng
      src/3rdparty/md4c
      src/3rdparty/pcre2
      src/3rdparty/sqlite
      src/3rdparty/xcb
      src/3rdparty/zlib
    ])

    # The install prefix is HOMEBREW_PREFIX so that modules can be installed in separate formulae
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST") + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DINSTALL_ARCHDATADIR=share/qt
      -DINSTALL_DATADIR=share/qt
      -DINSTALL_EXAMPLESDIR=share/qt/examples
      -DINSTALL_MKSPECSDIR=share/qt/mkspecs
      -DINSTALL_TESTSDIR=share/qt/tests

      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=OFF

      -DFEATURE_openssl_linked=ON
      -DFEATURE_pkg_config=ON
      -DFEATURE_system_doubleconversion=ON
      -DFEATURE_system_freetype=ON
      -DFEATURE_system_harfbuzz=ON
      -DFEATURE_system_jpeg=ON
      -DFEATURE_system_libb2=ON
      -DFEATURE_system_pcre2=ON
      -DFEATURE_system_png=ON
      -DFEATURE_system_sqlite=ON
      -DFEATURE_system_zlib=ON
      -DQT_ALLOW_SYMLINK_IN_PATHS=ON
    ]

    cmake_args += if OS.mac?
      # Workaround to support relocatable installs in Homebrew's symlink directory structure.
      inreplace "cmake/QtQmakeHelpers.cmake",
                'set(QT_CONFIGURE_LIBLOCATION_TO_PREFIX_PATH "${from_lib_location_to_prefix}")',
                "set(QT_CONFIGURE_LIBLOCATION_TO_PREFIX_PATH \"#{HOMEBREW_PREFIX.relative_path_from(lib)}\")"

      # Avoid opportunistic linkage to `at-spi2-core`. The AT-SPI bridge is
      # Linux-only and fails to build on macOS if `at-spi2-core` is installed.
      %w[
        -DFEATURE_relocatable=ON
        -DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON
        -DFEATURE_accessibility_atspi_bridge=OFF
      ]
    else
      # FIXME: Unable to use workaround for relocatable installs as paths are resolved relative
      # to absolutePath() rather than canonicalPath(). This can break based on order of RPATH.
      # https://github.com/qt/qtbase/blob/v6.9.2/src/corelib/global/qlibraryinfo.cpp#L304
      %w[
        -DFEATURE_relocatable=OFF
        -DFEATURE_xcb=ON
        -DFEATURE_system_xcb_xinput=ON
      ]
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?

    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", "#{Superenv.shims_path}/", ""

    # CMake finds the `pkg-config` shim first, which Qt records in `qmodule.pri` (macOS only).
    inreplace share/"qt/mkspecs/qmodule.pri", "#{Superenv.shims_path}/", "#{HOMEBREW_PREFIX}/bin/" if OS.mac?

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
  end

  def caveats
    <<~CAVEATS
      You can add Homebrew's Qt to QtCreator's "Qt Versions" in:
        Preferences > Qt Versions > Link with Qt...
      pressing "Choose..." and selecting as the Qt installation path:
        #{HOMEBREW_PREFIX}
    CAVEATS
  end

  test do
    modules = %w[Core Gui Widgets Sql Concurrent Network]
    vulkan_include = formula_opt_include("vulkan-headers")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)
      find_package(Qt6 REQUIRED COMPONENTS #{modules.join(" ")})
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::#{modules.join(" Qt6::")})
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += #{modules.join(" ").downcase}
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
      INCLUDEPATH += #{vulkan_include}
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QCoreApplication>
      #include <QImageReader>
      #include <QtSql>
      #include <QVulkanInstance>

      int main(int argc, char *argv[]) {
        QCoreApplication app(argc, argv);
        Q_ASSERT(QSqlDatabase::isDriverAvailable("QSQLITE"));
        const auto &list = QImageReader::supportedImageFormats();
        QVulkanInstance inst;
        // See https://github.com/actions/runner-images/issues/1779
        // if (!inst.create())
        //   qFatal("Failed to create Vulkan instance: %d", inst.errorCode());
        for (const char* fmt : {"bmp", "cur", "gif", "ico", "jpeg", "jpg", "pbm", "pgm", "png", "ppm", "xbm", "xpm"}) {
          Q_ASSERT(list.contains(fmt));
        }
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
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

    # Test compiler and linker flags work separately
    cflags = shell_output("pkgconf --cflags Qt6#{modules.join(" Qt6")}").chomp.split
    ldflags = shell_output("pkgconf --libs Qt6#{modules.join(" Qt6")}").chomp.split
    system ENV.cxx, "-std=c++17", "-c", "main.cpp", "-o", "main.o", "-I#{vulkan_include}", *cflags
    system ENV.cxx, "main.o", "-o", "test", *ldflags
    system "./test"

    # Check QT_INSTALL_PREFIX is HOMEBREW_PREFIX to support split formulae
    assert_equal HOMEBREW_PREFIX.to_s, shell_output("#{bin}/qmake -query QT_INSTALL_PREFIX").chomp
  end
end
