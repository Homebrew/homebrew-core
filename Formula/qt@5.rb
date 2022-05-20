# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class QtAT5 < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/5.15/5.15.4/single/qt-everywhere-opensource-src-5.15.4.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.15/5.15.4/single/qt-everywhere-opensource-src-5.15.4.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.15/5.15.4/single/qt-everywhere-opensource-src-5.15.4.tar.xz"
  sha256 "615ff68d7af8eef3167de1fd15eac1b150e1fd69d1e2f4239e54447e7797253b"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5ac5153ebd4c55455f4e66c8ff709a8f6e5eaa4585b771d3713ff4157533c535"
    sha256 cellar: :any,                 arm64_big_sur:  "6b1b9976f3d2156044a6417eea49950e032d3aa7868bce07f0b4f9a53566028f"
    sha256 cellar: :any,                 monterey:       "c5b6845eaf185e11cfd8a34285b16c1abd00352a89d82940fc8dc6a9dc4c4270"
    sha256 cellar: :any,                 big_sur:        "fac4e2200c7fd63370768cf50f7d094ea8de548a60c5bb48820815671ba7a772"
    sha256 cellar: :any,                 catalina:       "0ee613de8e493575c529d25f3747375df84a5e0f3503535b0f227e86a055acca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c59614cf1a5d21a4ea8090bb063bedd49fdcf0dca166411f85930176431a4426"
  end

  keg_only :versioned_formula

  depends_on "node"       => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on macos: :sierra

  uses_from_macos "gperf" => :build
  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "at-spi2-core"
    depends_on "fontconfig"
    depends_on "gcc"
    depends_on "glib"
    depends_on "icu4c"
    depends_on "libproxy"
    depends_on "libxkbcommon"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libxcomposite"
    depends_on "libdrm"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "python@3.9"
    depends_on "sdl2"
    depends_on "systemd"
    depends_on "xcb-util"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
    depends_on "zstd"
    depends_on "wayland"
  end

  fails_with gcc: "5"

  resource "qtwebengine" do
    url "https://code.qt.io/qt/qtwebengine.git",
        tag:      "v5.15.9-lts",
        revision: "4f570bd7add21725d66ac8396dcf21917c3a603f"
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

  # Fix build for GCC 11
  patch do
    url "https://invent.kde.org/qt/qt/qtdeclarative/commit/ba07a40a2afacfb57ddb8f7cb4cc90a39560f17d.patch"
    sha256 "44f620ebf210f8f894142c9bcdfd38a0b916f3743f7c9dd0c0327430cc582224"
    directory "qtdeclarative"
  end

  # Update Chromium
  # https://code.qt.io/cgit/qt/qtwebengine.git/patch/?id=404a40de5862c8ab24992ea4dcd2f8ef63f5e080
  patch do
    url "https://invent.kde.org/qt/qt/qtwebengine/commit/404a40de5862c8ab24992ea4dcd2f8ef63f5e080.patch"
    sha256 "c7055bc4853a5cd8acdc54fe8808b5fea908ed3d5f089ad5966971350e377eaa"
    directory "qtwebengine"
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

    resource("qtwebengine").stage(buildpath/"qtwebengine") if OS.mac?

    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -qt-libpng
      -qt-libjpeg
      -qt-freetype
      -qt-pcre
      -nomake examples
      -nomake tests
      -pkg-config
      -dbus-runtime
    ]

    if OS.mac?
      args << "-no-rpath"
      args << "-system-zlib"
      if Hardware::CPU.arm?
        # QtWebEngine is not supported on arm64. Use qt6 if you need it.
        args << "-skip" << "qtwebengine" << "-no-assimp"
      else
        args << "-proprietary-codecs"
      end
    else
      args << "-R#{lib}"
      # https://bugreports.qt.io/browse/QTBUG-71564
      args << "-no-avx2"
      args << "-no-avx512"
      args << "-qt-zlib"
      # https://bugreports.qt.io/browse/QTBUG-60163
      # https://codereview.qt-project.org/c/qt/qtwebengine/+/191880
      args += %w[-skip qtwebengine]
      args << "-no-sql-mysql"

      # Change default mkspec for qmake on Linux to use brewed GCC
      inreplace "qtbase/mkspecs/common/g++-base.conf", "$${CROSS_COMPILE}gcc", ENV.cc
      inreplace "qtbase/mkspecs/common/g++-base.conf", "$${CROSS_COMPILE}g++", ENV.cxx
    end

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

    if OS.mac? && !Hardware::CPU.arm?
      # Fix find_package call using QtWebEngine version to find other Qt5 modules.
      inreplace Dir[lib/"cmake/Qt5WebEngine*/*Config.cmake"],
                " #{resource("qtwebengine").version} ", " #{version} "
    end
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
