class Qtbase < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtbase-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtbase-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtbase-everywhere-src-6.9.3.tar.xz"
  sha256 "c5a1a2f660356ec081febfa782998ae5ddbc5925117e64f50e4be9cd45b8dc6e"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qmake
    "BSD-3-Clause", # *.cmake
    "GFDL-1.3-no-invariants-only", # *.qdoc
  ]
  head "https://code.qt.io/qt/qtbase.git", branch: "dev"

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "031dc8feea7e91068bad640f2384309b5d73983f5e13b63fd41019a492365d6a"
    sha256 cellar: :any,                 arm64_sequoia: "f81cd92620f9a76049a118e983b68141d469825828fbc317e04c4449c3e7066d"
    sha256 cellar: :any,                 arm64_sonoma:  "73404da080f30f866f0edd489527ed879a06a2a956f59c6ed52d47c7e32668f5"
    sha256 cellar: :any,                 sonoma:        "6a51ae0cf024a196bba21a5ba75bf7d4c35aedcdae23476ff2f948cecb3602a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28447cd1dc3f8930358e067866bc3b68c24f26ab5a19ba7bd7d22e8978924a42"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vulkan-headers" => [:build, :test]
  depends_on xcode: :build

  depends_on "brotli"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
  depends_on "jpeg-turbo"
  depends_on "libb2"
  depends_on "libpng"
  depends_on "md4c"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

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
    depends_on "xcb-util-cursor"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
  end

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

      # Cannoy deploy to version later than 14, due to functions obsoleted in macOS 15.0
      # https://bugreports.qt.io/browse/QTBUG-128900
      deploy = [MacOS.version, MacOSVersion.from_symbol(:sonoma)].min

      %W[
        -DCMAKE_OSX_DEPLOYMENT_TARGET=#{deploy}.0
        -DFEATURE_relocatable=ON
        -DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON
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
      INCLUDEPATH += #{Formula["vulkan-headers"].opt_include}
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

    flags = shell_output("pkgconf --cflags --libs Qt6#{modules.join(" Qt6")}").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"

    # Check QT_INSTALL_PREFIX is HOMEBREW_PREFIX to support split formulae
    assert_equal HOMEBREW_PREFIX.to_s, shell_output("#{bin}/qmake -query QT_INSTALL_PREFIX").chomp
  end
end
