# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class QtAT5 < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/5.15/5.15.5/single/qt-everywhere-opensource-src-5.15.5.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.15/5.15.5/single/qt-everywhere-opensource-src-5.15.5.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.15/5.15.5/single/qt-everywhere-opensource-src-5.15.5.tar.xz"
  sha256 "5a97827bdf9fd515f43bc7651defaf64fecb7a55e051c79b8f80510d0e990f06"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bce4356e6987a55b0bbe586f753190d3f3afed4036ada8ec4a2d8d23d420841a"
    sha256 cellar: :any,                 arm64_big_sur:  "2b857b719b13cae92c5e008103118fc3a5f78aa7dbce18aa3755ac08794bbdcf"
    sha256 cellar: :any,                 monterey:       "5183ae7bd3b28677de502c2c82e93ba2a41255f17d68c94110ce7c6b125345a4"
    sha256 cellar: :any,                 big_sur:        "ca12eaad160b35bc3a7b6ea293b5d289d42cfe6b40cc5cd2109e6a2e426ccf15"
    sha256 cellar: :any,                 catalina:       "6ef01c649fbe7c574c8eeee94614cd41157ffaa6d93430d17bee567214fe8e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08cf52c62bad792f6da62da2a4163dca2204c91b64ee657c04fe585546be69c5"
  end

  keg_only :versioned_formula

  depends_on "node"       => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
    depends_on "gcc"
    depends_on "harfbuzz"
    depends_on "icu4c"
    depends_on "libdrm"
    depends_on "libevent"
    depends_on "libice"
    depends_on "libproxy"
    depends_on "libsm"
    depends_on "libvpx"
    depends_on "libxkbcommon"
    depends_on "libxcomposite"
    depends_on "libxkbfile"
    depends_on "libxrandr"
    depends_on "libxtst"
    depends_on "mesa"
    depends_on "minizip"
    depends_on "nss"
    depends_on "opus"
    depends_on "pulseaudio"
    depends_on "re2"
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
        tag:      "v5.15.10-lts",
        revision: "c7e716ef1ffd63a8ab1f4dbf879230849eb3b505"

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

    # Fix build of qt-webengine-chromium with newer GCC.
    # Submitted upstream here: https://codereview.qt-project.org/c/qt/qtwebengine-chromium/+/416598
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/a6f16c6daea3b5a1f7bc9f175d1645922c131563/qt5/qt5-webengine-gcc12.patch?full_index=1"
      sha256 "cf9be3ffcc3b3cd9450b1ff13535ff7d76284f73173412d097a6ab487463a379"
      directory "src/3rdparty"
    end
  end

  # Update catapult to a revision that supports Python 3.
  resource "catapult" do
    url "https://chromium.googlesource.com/catapult.git",
    revision: "5eedfe23148a234211ba477f76fc2ea2e8529189"
  end

  # Backport of https://code.qt.io/cgit/qt/qtbase.git/commit/src/plugins/platforms/cocoa?id=dece6f5840463ae2ddf927d65eb1b3680e34a547
  # to fix the build with Xcode 13.
  # The original commit is for Qt 6 and cannot be applied cleanly to Qt 5.
  patch :DATA

  # Fix build for GCC 11
  patch do
    url "https://invent.kde.org/qt/qt/qtbase/commit/ccc0f5cd016eb17e4ff0db03ffed76ad32c8894d.patch"
    sha256 "ad97b5dbb13875f95a6d9ffc1ecf89956f8249771a4e485bd5ddcbe0c8ba54e8"
    directory "qtbase"
  end

  # Fix build for GCC 11
  patch do
    url "https://invent.kde.org/qt/qt/qtdeclarative/commit/8da88589929a1d82103c8bbfa80210f3c1af3714.patch"
    sha256 "9faedb41c80f23d4776f0be64f796415abd00ef722a318b3f7c1311a8f82e66d"
    directory "qtdeclarative"
  end

  # Patch for qmake on ARM
  # https://codereview.qt-project.org/c/qt/qtbase/+/327649
  if Hardware::CPU.arm?
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/9dc732/qt/qt-split-arch.patch"
      sha256 "36915fde68093af9a147d76f88a4e205b789eec38c0c6f422c21ae1e576d45c0"
      directory "qtbase"
    end
  end

  def install
    rm_r "qtwebengine"

    resource("qtwebengine").stage(buildpath/"qtwebengine")

    rm_r "qtwebengine/src/3rdparty/chromium/third_party/catapult"

    resource("catapult").stage(buildpath/"qtwebengine/src/3rdparty/chromium/third_party/catapult")

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

      # Change default mkspec for qmake on Linux to use brewed GCC
      inreplace "qtbase/mkspecs/common/g++-base.conf", "$${CROSS_COMPILE}gcc", ENV.cc
      inreplace "qtbase/mkspecs/common/g++-base.conf", "$${CROSS_COMPILE}g++", ENV.cxx

      # Homebrew-specific workaround to ignore spurious linker warnings on Linux.
      inreplace "qtwebengine/src/3rdparty/chromium/build/config/compiler/BUILD.gn",
               "fatal_linker_warnings = true",
               "fatal_linker_warnings = false"
    end

    ENV.prepend_path "PATH", Formula["python@3.10"].libexec/"bin"
    system "./configure", *args

    # Remove reference to shims directory
    inreplace "qtbase/mkspecs/qmodule.pri",
              /^PKG_CONFIG_EXECUTABLE = .*$/,
              "PKG_CONFIG_EXECUTABLE = #{Formula["pkg-config"].opt_bin/"pkg-config"}"
    system "make"
    ENV.deparallelize
    system "make", "install"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    # (Note: This move breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") { |app| mv app, libexec }
  end

  def caveats
    s = <<~EOS
      We agreed to the Qt open source license for you.
      If this is unacceptable you should uninstall.
    EOS

    if Hardware::CPU.arm?
      s += <<~EOS

        This version of Qt on Apple Silicon does not include QtWebEngine.
      EOS
    end

    s
  end

  test do
    (testpath/"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
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

__END__
--- a/qtbase/src/plugins/platforms/cocoa/qiosurfacegraphicsbuffer.h
+++ b/qtbase/src/plugins/platforms/cocoa/qiosurfacegraphicsbuffer.h
@@ -43,4 +43,6 @@
 #include <qpa/qplatformgraphicsbuffer.h>
 #include <private/qcore_mac_p.h>
+ 
+#include <CoreGraphics/CGColorSpace.h>

 QT_BEGIN_NAMESPACE
