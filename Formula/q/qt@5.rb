# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class QtAT5 < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  # NOTE: Use *.diff for GitLab/KDE patches to avoid their checksums changing.
  url "https://download.qt.io/official_releases/qt/5.15/5.15.16/single/qt-everywhere-opensource-src-5.15.16.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.15/5.15.16/single/qt-everywhere-opensource-src-5.15.16.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.15/5.15.16/single/qt-everywhere-opensource-src-5.15.16.tar.xz"
  sha256 "efa99827027782974356aceff8a52bd3d2a8a93a54dd0db4cca41b5e35f1041c"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  revision 2

  livecheck do
    url "https://download.qt.io/official_releases/qt/5.15/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a661d1f9b62c9fff165ace3821f3befeb65620166b63d8795301f132cc9aeb50"
    sha256 cellar: :any,                 arm64_sonoma:  "1902b5b126785f33ff1fdd612c458a0dd2cca205c925f4c04fc5ef4e6b7d5517"
    sha256 cellar: :any,                 arm64_ventura: "61a83675a351069af55b9ab8cc62962fbf1e763cb5abb8ee2a63102de9c4d438"
    sha256 cellar: :any,                 sonoma:        "d86069ffb50778801427abd0574ef955e2377d777d251b496bf38c732ebcf6c4"
    sha256 cellar: :any,                 ventura:       "3a50379f30ae54952e5860dfb1a624e903db7b63a420af76a90aa0e0fdc3d3e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b1afcefd9c62dae5bf3aadf26d9a25e3ed9c8855bb8b979a1fe1cdb0484dd3c"
  end

  keg_only :versioned_formula

  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on xcode: :build
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on macos: :sierra
  depends_on "md4c"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "at-spi2-core"
    depends_on "dbus"
    depends_on "double-conversion"
    depends_on "expat"
    depends_on "fontconfig"
    depends_on "harfbuzz"
    depends_on "icu4c@77"
    depends_on "libdrm"
    depends_on "libevent"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libvpx"
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxcomposite"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "libxkbfile"
    depends_on "libxml2"
    depends_on "libxrandr"
    depends_on "libxslt"
    depends_on "libxtst"
    depends_on "llvm"
    depends_on "mesa"
    depends_on "minizip"
    depends_on "nspr"
    depends_on "nss"
    depends_on "opus"
    depends_on "pulseaudio"
    depends_on "sdl2"
    depends_on "snappy"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
  end

  resource "qtwebengine" do
    url "https://code.qt.io/qt/qtwebengine.git",
        tag:      "v5.15.18-lts",
        revision: "87ceb6a2ef5ee25d56f765dc533728c4ca4787e0"

    # Use Debian patches for ICU 75+, brew Ninja and Python 3.13
    patch do
      url "https://deb.debian.org/debian/pool/main/q/qtwebengine-opensource-src/qtwebengine-opensource-src_5.15.18+dfsg-2.debian.tar.xz"
      sha256 "2d2d671c26a94ec1ec9d5fb3cbe57b3ec0ed98a2e5cc7471c573b763d8e098e6"
      apply "patches/build-with-c++17.patch",
            "patches/ninja-1.12.patch",
            "patches/python3.12-imp.patch",
            "patches/python3.12-six.patch",
            "patches/python3.13-pipes.patch"
    end
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  # Fix build with ICU 75
  patch do
    on_linux do
      url "https://invent.kde.org/qt/qt/qtlocation-mapboxgl/-/commit/35d566724c48180c9a372c2ed50a253871a51574.diff"
      sha256 "9e61d46c0a8ae39903cbcbb228e384f2878a06e50448f3bba60ec65fe2890081"
      directory "qtlocation/src/3rdparty/mapbox-gl-native"
    end
  end

  # Fix build with Xcode 14.3.
  # https://bugreports.qt.io/browse/QTBUG-112906
  patch do
    url "https://invent.kde.org/qt/qt/qtlocation-mapboxgl/-/commit/5a07e1967dcc925d9def47accadae991436b9686.diff"
    sha256 "4f433bb009087d3fe51e3eec3eee6e33a51fde5c37712935b9ab96a7d7571e7d"
    directory "qtlocation/src/3rdparty/mapbox-gl-native"
  end

  # CVE-2023-51714
  # Remove with Qt 5.15.17
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/0001-CVE-2023-51714-qtbase-5.15.diff"
    sha256 "2129058a5e24d98ee80a776c49a58c2671e06c338dffa7fc0154e82eef96c9d4"
    directory "qtbase"
  end
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/0002-CVE-2023-51714-qtbase-5.15.diff"
    sha256 "99d5d32527e767d6ab081ee090d92e0b11f27702619a4af8966b711db4f23e42"
    directory "qtbase"
  end

  # CVE-2024-25580
  # Remove with Qt 5.15.17
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/CVE-2024-25580-qtbase-5.15.diff"
    sha256 "7cc9bf74f696de8ec5386bb80ce7a2fed5aa3870ac0e2c7db4628621c5c1a731"
    directory "qtbase"
  end

  # CVE-2024-36048
  # Remove with Qt 5.15.17
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/CVE-2024-36048-qtnetworkauth-5.15.diff"
    sha256 "e5d385d636b5241b59ac16c4a75359e21e510506b26839a4e2033891245f33f9"
    directory "qtnetworkauth"
  end

  # CVE-2024-39936
  # Remove with Qt 5.15.18
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/CVE-2024-39936-qtbase-5.15.patch"
    sha256 "2cc23afba9d7e48f8faf8664b4c0324a9ac31a4191da3f18bd0accac5c7704de"
    directory "qtbase"
  end

  # CVE-2025-23050
  # Remove with Qt 5.15.19
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/CVE-2025-23050-qtconnectivity-5.15.diff"
    sha256 "76e303b6465babb6d0d275792f7f3c41e3df87a6a17992e8b7b8e47272682ce7"
    directory "qtconnectivity"
  end

  def install
    # Install python dependencies for QtWebEngine
    venv = virtualenv_create(buildpath/"venv", "python3.13")
    venv.pip_install resources.reject { |r| r.name == "qtwebengine" }
    ENV.prepend_path "PATH", venv.root/"bin"

    rm_r(buildpath/"qtwebengine")
    (buildpath/"qtwebengine").install resource("qtwebengine")

    # FIXME: GN requires clang in clangBasePath/bin
    inreplace "qtwebengine/src/3rdparty/chromium/build/toolchain/mac/BUILD.gn",
              'rebase_path("$clang_base_path/bin/", root_build_dir)', '""'

    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -nomake examples
      -nomake tests
      -pkg-config
      -dbus-runtime
      -proprietary-codecs
      -system-freetype
      -system-libjpeg
      -system-libmd4c
      -system-libpng
      -system-pcre
      -system-sqlite
      -system-zlib
      -webengine-python-version python3
    ]

    if OS.mac?
      args << "-no-rpath"
      args << "-no-assimp" if Hardware::CPU.arm?

      # Modify Assistant path as we manually move `*.app` bundles from `bin` to `libexec`.
      # This fixes invocation of Assistant via the Help menu of apps like Designer and
      # Linguist as they originally relied on Assistant.app being in `bin`.
      assistant_files = %w[
        qttools/src/designer/src/designer/assistantclient.cpp
        qttools/src/linguist/linguist/mainwindow.cpp
      ]
      inreplace assistant_files, '"Assistant.app/Contents/MacOS/Assistant"', '"Assistant"'
    else
      args << "-R#{lib}"
      # https://bugreports.qt.io/browse/QTBUG-71564
      args << "-no-avx2"
      args << "-no-avx512"
      args << "-no-sql-mysql"

      # Use additional system libraries on Linux.
      # Currently we have to use vendored ffmpeg because the chromium copy adds a symbol not
      # provided by the brewed version.
      # See here for an explanation of why upstream ffmpeg does not want to add this:
      # https://www.mail-archive.com/ffmpeg-devel@ffmpeg.org/msg124998.html
      # On macOS chromium will always use bundled copies and the webengine_*
      # arguments are ignored.
      args += %w[
        -system-doubleconversion
        -system-harfbuzz
        -webengine-alsa
        -webengine-icu
        -webengine-kerberos
        -webengine-opus
        -webengine-pulseaudio
        -webengine-webp
      ]

      # Homebrew-specific workaround to ignore spurious linker warnings on Linux.
      inreplace "qtwebengine/src/3rdparty/chromium/build/config/compiler/BUILD.gn",
                "fatal_linker_warnings = true",
                "fatal_linker_warnings = false"
    end

    # Work around Clang failure in bundled Boost and V8:
    # error: integer value -1 is outside the valid range of values [0, 3] for this enumeration type
    if DevelopmentTools.clang_build_version >= 1500
      args << "QMAKE_CXXFLAGS+=-Wno-enum-constexpr-conversion"
      inreplace "qtwebengine/src/3rdparty/chromium/build/config/compiler/BUILD.gn",
                /^\s*"-Wno-thread-safety-attributes",$/,
                "\\0 \"-Wno-enum-constexpr-conversion\","
    end

    # Work around Clang failure in bundled freetype: error: unknown type name 'Byte'
    # https://gitlab.freedesktop.org/freetype/freetype/-/commit/a25e85ed95dc855e42e6bb55138e27d362c5ea1e
    if DevelopmentTools.clang_build_version >= 1600
      inreplace "qtwebengine/src/3rdparty/chromium/third_party/freetype/src/src/gzip/ftzconf.h",
                "#if !defined(MACOS) && !defined(TARGET_OS_MAC)", "#if !defined(__MACTYPES__)"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # Remove reference to shims directory
    inreplace prefix/"mkspecs/qmodule.pri",
              /^PKG_CONFIG_EXECUTABLE = .*$/,
              "PKG_CONFIG_EXECUTABLE = #{Formula["pkgconf"].opt_bin}/pkg-config"

    # Fix find_package call using QtWebEngine version to find other Qt5 modules.
    inreplace lib.glob("cmake/Qt5WebEngine*/*Config.cmake"),
              " #{resource("qtwebengine").version} ", " #{version} "

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
        <value type="QString" key="Name">Qt %{Qt:Version} (#{opt_prefix})</value>
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

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
    end

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexec/app.basename/"Contents/MacOS"/app.stem
    end
  end

  def caveats
    <<~EOS
      We agreed to the Qt open source license for you.
      If this is unacceptable you should uninstall.

      You can add Homebrew's Qt to QtCreator's "Qt Versions" in:
        Preferences > Qt Versions > Link with Qt...
      pressing "Choose..." and selecting as the Qt installation path:
        #{opt_prefix}
    EOS
  end

  test do
    (testpath/"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET    = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE  = app
      SOURCES  += main.cpp
    EOS

    (testpath/"main.cpp").write <<~CPP
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    CPP

    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete "CPATH"

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert_path_exists testpath/"hello"
    assert_path_exists testpath/"main.o"
    system "./hello"
  end
end
