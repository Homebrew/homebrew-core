# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class QtAT5 < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  # NOTE: Use *.diff for GitLab/KDE patches to avoid their checksums changing.
  url "https://download.qt.io/official_releases/qt/5.15/5.15.11/single/qt-everywhere-opensource-src-5.15.11.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.15/5.15.11/single/qt-everywhere-opensource-src-5.15.11.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.15/5.15.11/single/qt-everywhere-opensource-src-5.15.11.tar.xz"
  sha256 "7426b1eaab52ed169ce53804bdd05dfe364f761468f888a0f15a308dc1dc2951"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/qt/5.15/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ee532c84fea881a898959e3c72648b47096f289d257c0be6798c224ade85958b"
    sha256 cellar: :any,                 arm64_ventura:  "873565f70ab43294a41232d351581cdab946a01642594861e027ad3ca1c30a75"
    sha256 cellar: :any,                 arm64_monterey: "7db8c1cf0376bbdcb40e525bf22dcf0edec3cdcc754b98a425dd67b51020784d"
    sha256 cellar: :any,                 sonoma:         "2069aeddf10173c866e95300b7a194e98b4637ad8a056ad9595c98bc1a6303b8"
    sha256 cellar: :any,                 ventura:        "627691d0c1a2a669353f70bc4cd6a1b3c9f2e3c066ce36aa6fffa9e1eb7cd05c"
    sha256 cellar: :any,                 monterey:       "7100c3dff9f19ffec9e3b7bca021fd2e04f6ff22a79efe1f83962d01d8e2bb32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "075572b8e632200d5f4ef2d13aef3205b3dd4ab5ca1c88d5e475d092f2fd5afe"
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

    # Backport Chromium changes for libxml 2.12 compatibility
    # https://chromium.googlesource.com/chromium/src/+/871f8ae9b65ce2679b0bc0be36902d65edf0c1e4
    on_linux do
      patch do
        url "https://chromium-review.googlesource.com/changes/chromium%2Fsrc~4985186/revisions/4/patch?zip&path=third_party%2Fblink%2Frenderer%2Fcore%2Fxml%2Fxslt_processor.h"
        sha256 "61d0352bb43ab796e1702f003f119a0838e5357517ee90f71bcc5cd0ba184e36"
        directory "src/3rdparty/chromium"
      end
      patch do
        url "https://chromium-review.googlesource.com/changes/chromium%2Fsrc~4985186/revisions/4/patch?zip&path=third_party%2Fblink%2Frenderer%2Fcore%2Fxml%2Fxslt_processor_libxslt.cc"
        sha256 "dc8cf92c07cad7da51510d2233968af4b0f408ff6857153ffa1d7387bb77f1b7"
        directory "src/3rdparty/chromium"
      end
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
      url "https://sources.debian.org/data/main/q/qtwebengine-opensource-src/5.15.15%2Bdfsg-2/debian/patches/python3.11.patch"
      sha256 "652a612144ef4d87b6b2a4098f56ba6db1201e1a241259d0a227123cb0e566a2"
    end

    # Fix ffmpeg build with binutils
    # https://www.linuxquestions.org/questions/slackware-14/regression-on-current-with-ffmpeg-4175727691/
    patch do
      url "https://github.com/FFmpeg/FFmpeg/commit/effadce6c756247ea8bae32dc13bb3e6f464f0eb.patch?full_index=1"
      sha256 "9800c708313da78d537b61cfb750762bb8ad006ca9335b1724dbbca5669f5b24"
      directory "src/3rdparty/chromium/third_party/ffmpeg"
    end
  end

  # Update catapult to a revision that supports Python 3.
  resource "catapult" do
    url "https://chromium.googlesource.com/catapult.git",
        revision: "5eedfe23148a234211ba477f76fc2ea2e8529189"
  end

  # Fix build with Xcode 14.3.
  patch do
    url "https://invent.kde.org/qt/qt/qtlocation-mapboxgl/-/commit/5a07e1967dcc925d9def47accadae991436b9686.diff"
    sha256 "4f433bb009087d3fe51e3eec3eee6e33a51fde5c37712935b9ab96a7d7571e7d"
    directory "qtlocation/src/3rdparty/mapbox-gl-native"
  end

  # build patch for qmake with xcode 15
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/086e8cf/qt5/qt5-qmake-xcode15.patch"
    sha256 "802f29c2ccb846afa219f14876d9a1d67477ff90200befc2d0c5759c5081c613"
  end

  # build patch for qtmultimedia with xcode 15
  # https://github.com/hmaarrfk/qt-main-feedstock/blob/0758b98854a3a3b9c99cded856176e96c9b8c0c5/recipe/patches/0014-remove-usage-of-unary-operator.patch
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3f509180/qt5/qt5-qtmultimedia-xcode15.patch"
    sha256 "887d6cb4fd115ce82323d17e69fafa606c51cef98c820b82309ab38288f21e08"
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
