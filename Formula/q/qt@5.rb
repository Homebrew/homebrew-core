# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class QtAT5 < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  # NOTE: Use *.diff for GitLab/KDE patches to avoid their checksums changing.
  url "https://download.qt.io/official_releases/qt/5.15/5.15.13/single/qt-everywhere-opensource-src-5.15.13.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.15/5.15.13/single/qt-everywhere-opensource-src-5.15.13.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.15/5.15.13/single/qt-everywhere-opensource-src-5.15.13.tar.xz"
  sha256 "9550ec8fc758d3d8d9090e261329700ddcd712e2dda97e5fcfeabfac22bea2ca"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  revision 1

  livecheck do
    url "https://download.qt.io/official_releases/qt/5.15/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a497f2b6e427f72c52e52e979f655cea54e0d6eddffd1fbf3c4a25bb5eae101"
    sha256 cellar: :any,                 arm64_ventura:  "a5098835cade678eb6d9193d393c3f7d0cbec5aa4f1833184fba56c13161a097"
    sha256 cellar: :any,                 arm64_monterey: "02fff8012c9cba1d9a6e79bc500289c79fa1d64b345533b6e5ea5855d322875a"
    sha256 cellar: :any,                 sonoma:         "5ab138b788d6fa1aeb7f5b1b3c041161efaeb6298771312628a4357fce0dc86f"
    sha256 cellar: :any,                 ventura:        "2057642d6105bcf0d34c08dc1393be18e41ee36feb5aa48746f7a2d8c7920c28"
    sha256 cellar: :any,                 monterey:       "f185f54474461f6d408f75a85afb25411b9a06409f2a29b97e3d2e069b7891c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "792f32f138188fca968478186b361ca74b95770afd8066ee19275616d65a6e00"
  end

  keg_only :versioned_formula

  depends_on "node" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build # NOTE: Python 3.12+ would need additional backports due to imp usage
  depends_on xcode: :build
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on macos: :sierra
  depends_on "pcre2"
  depends_on "webp"

  uses_from_macos "gperf" => :build
  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "krb5"
  uses_from_macos "libxslt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "alsa-lib"
    depends_on "at-spi2-core"
    depends_on "fontconfig"
    depends_on "harfbuzz"
    depends_on "icu4c"
    depends_on "libdrm"
    depends_on "libevent"
    depends_on "libice"
    depends_on "libproxy"
    depends_on "libsm"
    depends_on "libvpx"
    depends_on "libxcomposite"
    depends_on "libxkbcommon"
    depends_on "libxkbfile"
    depends_on "libxrandr"
    depends_on "libxtst"
    depends_on "mesa"
    depends_on "minizip"
    depends_on "nss"
    depends_on "opus"
    depends_on "pulseaudio"
    depends_on "sdl2"
    depends_on "snappy"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "xcb-util"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
    depends_on "zstd"
  end

  fails_with gcc: "5"

  resource "qtwebengine" do
    url "https://code.qt.io/qt/qtwebengine.git",
        tag:      "v5.15.16-lts",
        revision: "224806a7022eed6d5c75b486bec8715a618cb314"

    # Fix libxml2 2.12 compatibility
    # https://codereview.qt-project.org/c/qt/qtwebengine-chromium/+/525714
    # Remove with 5.15.17-lts
    patch do
      url "https://github.com/qt/qtwebengine-chromium/commit/c98d28f2f0f23721b080c74bc1329871a529efd8.patch?full_index=1"
      sha256 "bcb946524e203ac7b8f7a681b3288a2da7ee1c18f440cb34cbf5849f22b7d649"
      directory "src/3rdparty"
    end

    # Add Python 3 support to qt-webengine-chromium.
    # Submitted upstream here: https://codereview.qt-project.org/c/qt/qtwebengine-chromium/+/416534
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/7ae178a617d1e0eceb742557e63721af949bd28a/qt5/qt5-webengine-chromium-python3.patch?full_index=1"
      sha256 "a93aa8ef83f0cf54f820daf5668574cc24cf818fb9589af2100b363356eb6b49"
      directory "src/3rdparty"
    end

    # Add Python 3 support to qt-webengine.
    # Submitted upstream here: https://codereview.qt-project.org/c/qt/qtwebengine/+/416535
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/a6f16c6daea3b5a1f7bc9f175d1645922c131563/qt5/qt5-webengine-python3.patch?full_index=1"
      sha256 "398c996cb5b606695ac93645143df39e23fa67e768b09e0da6dbd37342a43f32"
    end

    # Use Debian patch to support Python 3.11:
    # * tools/grit/grit/util.py changes are part of upstream commit
    #   Ref: https://chromium.googlesource.com/chromium/src/+/0991fc6acd3c85472000f2055af542515c3c6297
    # * tools/metrics/ukm/ukm_model.py changes are part of upstream commit
    #   Ref: https://chromium.googlesource.com/chromium/src/+/f90f49df8db04dcb72f7ce0c4d0b2fe329bab00c
    # * tools/metrics/structured/model.py was refactored in Chromium 90
    #   Ref: https://chromium.googlesource.com/chromium/src/+/1219c5a8e1e6d11adb3e098f1a983b8cd8f5932f
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/9758d3dd8ace5aaa9d6720b2e2e8ea1b863658d5/qt5/qtwebengine-py3.11.patch"
      sha256 "652a612144ef4d87b6b2a4098f56ba6db1201e1a241259d0a227123cb0e566a2"
    end

    # Fix ffmpeg build with binutils
    # https://www.linuxquestions.org/questions/slackware-14/regression-on-current-with-ffmpeg-4175727691/
    patch do
      url "https://github.com/FFmpeg/FFmpeg/commit/effadce6c756247ea8bae32dc13bb3e6f464f0eb.patch?full_index=1"
      sha256 "9800c708313da78d537b61cfb750762bb8ad006ca9335b1724dbbca5669f5b24"
      directory "src/3rdparty/chromium/third_party/ffmpeg"
    end

    # Use Gentoo's patch for ICU 74 support
    patch do
      url "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-qt/qtwebengine/files/qtwebengine-6.5.3-icu74.patch?id=ba397fa71f9bc9a074d9c65b63759e0145bb9fa0"
      sha256 "ceee91eb3161b385f54c0070f0e4800202b0674c63c40c8556cb69ac522e6999"
    end
  end

  # Update catapult to a revision that supports Python 3.
  resource "catapult" do
    url "https://chromium.googlesource.com/catapult.git",
        revision: "5eedfe23148a234211ba477f76fc2ea2e8529189"
  end

  # Fix build with Xcode 14.3.
  # https://bugreports.qt.io/browse/QTBUG-112906
  patch do
    url "https://invent.kde.org/qt/qt/qtlocation-mapboxgl/-/commit/5a07e1967dcc925d9def47accadae991436b9686.diff"
    sha256 "4f433bb009087d3fe51e3eec3eee6e33a51fde5c37712935b9ab96a7d7571e7d"
    directory "qtlocation/src/3rdparty/mapbox-gl-native"
  end

  # Fix qmake with Xcode 15.
  # https://bugreports.qt.io/browse/QTBUG-117225
  # Likely can remove with 5.15.16.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/086e8cf/qt5/qt5-qmake-xcode15.patch"
    sha256 "802f29c2ccb846afa219f14876d9a1d67477ff90200befc2d0c5759c5081c613"
  end

  # Fix qtmultimedia build with Xcode 15
  # https://bugreports.qt.io/browse/QTBUG-113782
  # https://github.com/hmaarrfk/qt-main-feedstock/blob/0758b98854a3a3b9c99cded856176e96c9b8c0c5/recipe/patches/0014-remove-usage-of-unary-operator.patch
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3f509180/qt5/qt5-qtmultimedia-xcode15.patch"
    sha256 "887d6cb4fd115ce82323d17e69fafa606c51cef98c820b82309ab38288f21e08"
  end

  # Fix use of macOS 14 only memory_resource on macOS 13
  # The `_cpp_lib_memory_resource` feature test macro should be sufficient but a bug in the SDK means
  # the extra checks are required. This part of the patch will likely be fixed in a future SDK.
  # https://bugreports.qt.io/browse/QTBUG-114316
  # This can likely be removed in 5.15.16.
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/56a9af76a6bcecc3d12c3a65f2465c25e05f2559/aqua/qt5/files/patch-qtbase-memory_resource.diff"
    sha256 "87967d685b08f06e91972a6d8c5e2e1ff672be9a2ba1d7d7084eba1413f641d5"
    directory "qtbase"
  end

  # CVE-2023-32573
  # Original (malformed with CRLF): https://download.qt.io/official_releases/qt/5.15/CVE-2023-32573-qtsvg-5.15.diff
  # Remove with Qt 5.15.14
  patch do
    url "https://invent.kde.org/qt/qt/qtsvg/-/commit/5b1b4a99d6bc98c42a11b7a3f6c9f0b0f9e56f34.diff"
    sha256 "0a978cac9954a557dde7f0c01e059a227f2e064fe6542defd78f37a9f7dd7a3d"
    directory "qtsvg"
  end

  # CVE-2023-32762
  # Original (malformed with CRLF): https://download.qt.io/official_releases/qt/5.15/CVE-2023-32762-qtbase-5.15.diff
  # Remove with Qt 5.15.14
  patch do
    url "https://invent.kde.org/qt/qt/qtbase/-/commit/1286cab2c0e8ae93749a71dcfd61936533a2ec50.diff"
    sha256 "2fba1152067c60756162b7ad7a2570d55c9293dd4a53395197fd31ab770977d7"
    directory "qtbase"
  end

  # CVE-2023-32763
  # Original (malformed with CRLF): https://download.qt.io/official_releases/qt/5.15/CVE-2023-32763-qtbase-5.15.diff
  # Remove with Qt 5.15.15
  patch do
    url "https://invent.kde.org/qt/qt/qtbase/-/commit/deb7b7b52b6e6912ff8c78bc0217cda9e36c4bba.diff"
    sha256 "ceafd01b3e2602140bfe8b052a5ad80ec2f3b3b21aed1e2d6f27cd50b9fb60b7"
    directory "qtbase"
  end

  # CVE-2023-33285
  # Original (malformed with CRLF): https://download.qt.io/official_releases/qt/5.15/CVE-2023-33285-qtbase-5.15.diff
  # Remove with Qt 5.15.14
  patch do
    url "https://invent.kde.org/qt/qt/qtbase/-/commit/21f6b720c26705ec53d61621913a0385f1aa805a.diff"
    sha256 "d2cb352a506a30fa4f4bdf41f887139d8412dfe3dc87e8b29511bd0c990839c5"
    directory "qtbase"
  end

  # CVE-2023-34410
  # Original (malformed with CRLF): https://download.qt.io/official_releases/qt/5.15/CVE-2023-34410-qtbase-5.15.diff
  # KDE patch excludes Windows-specific fixes
  # Remove with Qt 5.15.15
  patch do
    url "https://invent.kde.org/qt/qt/qtbase/-/commit/2ad1884fee697e0cb2377f3844fc298207e810cc.diff"
    sha256 "70496a602600a7133f5f10d8a7554efd7bcbe4d1998b16486da8fb82070b0138"
    directory "qtbase"
  end

  # CVE-2023-37369
  # Remove with Qt 5.15.15
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/CVE-2023-37369-qtbase-5.15.diff"
    sha256 "279c520ec96994d2b684ddd47a4672a6fdfc7ac49a9e0bdb719db1e058d9e5c0"
    directory "qtbase"
  end

  # CVE-2023-38197
  # Remove with Qt 5.15.15
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/CVE-2023-38197-qtbase-5.15.diff"
    sha256 "382c10ec8f42e2a34ac645dc4f57cd6b717abe6a3807b7d5d9312938f91ce3dc"
    directory "qtbase"
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

  def install
    (buildpath/"qtwebengine").rmtree
    (buildpath/"qtwebengine").install resource("qtwebengine")

    (buildpath/"qtwebengine/src/3rdparty/chromium/third_party/catapult").rmtree
    (buildpath/"qtwebengine/src/3rdparty/chromium/third_party/catapult").install resource("catapult")

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
      -system-libpng
      -system-pcre
      -system-zlib
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

    ENV.prepend_path "PATH", Formula["python@3.11"].libexec/"bin"
    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # Remove reference to shims directory
    inreplace prefix/"mkspecs/qmodule.pri",
              /^PKG_CONFIG_EXECUTABLE = .*$/,
              "PKG_CONFIG_EXECUTABLE = #{Formula["pkg-config"].opt_bin}/pkg-config"

    # Fix find_package call using QtWebEngine version to find other Qt5 modules.
    inreplace Dir[lib/"cmake/Qt5WebEngine*/*Config.cmake"],
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
    qtversion_xml = share/"qtcreator/QtProject/qtcreator/qtversion.xml"
    qtversion_xml.dirname.mkpath
    qtversion_xml.write <<~XML
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

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete "CPATH"

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert_predicate testpath/"hello", :exist?
    assert_predicate testpath/"main.o", :exist?
    system "./hello"
  end
end
