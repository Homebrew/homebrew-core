# Patches for Qt5 must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class QtAT55 < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/archive/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.xz"
  mirror "https://www.mirrorservice.org/sites/download.qt-project.org/archive/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.xz"
  sha256 "6f028e63d4992be2b4a5526f2ef3bfa2fe28c5c757554b11d9e8d86189652518"

  # Build error: Fix library detection for QtWebEngine with Xcode 7.
  # https://codereview.qt-project.org/#/c/1w27759/
  patch do
    url "https://raw.githubusercontent.com/UniqMartin/patches/557a8bd4/qt5/webengine-xcode7.patch"
    sha256 "7bd46f8729fa2c20bc486ddc5586213ccf2fb9d307b3d4e82daa78a2553f59bc"
  end

  # Fix for qmake producing broken pkg-config files, affecting Poppler et al.
  # https://codereview.qt-project.org/#/c/126584/
  # Should land in the 5.5.2 and/or 5.6 release.
  patch do
    url "https://gist.githubusercontent.com/UniqMartin/a54542d666be1983dc83/raw/f235dfb418c3d0d086c3baae520d538bae0b1c70/qtbug-47162.patch"
    sha256 "e31df5d0c5f8a9e738823299cb6ed5f5951314a28d4a4f9f021f423963038432"
  end

  # Build issue: Fix install names with `-no-rpath` to be absolute paths.
  # https://codereview.qt-project.org/#/c/138349
  patch do
    url "https://raw.githubusercontent.com/UniqMartin/patches/77d138fa/qt5/osx-no-rpath.patch"
    sha256 "92c9cfe701f9152f4b16219a04a523338d4b77bb0725a8adccc3fc72c9fb576f"
  end

  # Fixes for Secure Transport in QtWebKit
  # https://codereview.qt-project.org/#/c/139967/
  # https://codereview.qt-project.org/#/c/139968/
  # https://codereview.qt-project.org/#/c/139970/
  # Should land in the 5.5.2 and/or 5.6 release.
  patch do
    url "https://gist.githubusercontent.com/The-Compiler/8202f92fff70da39353a/raw/884c3bef4d272d25d7d7202be99c3940248151ee/qt5.5-securetransport-qtwebkit.patch"
    sha256 "c3302de2e23e74a99e62f22527e0edee5539b2e18d34c05e70075490ba7b3613"
  end

  # Upstream commit from 3 Oct 2016 "Fixed build with MaxOSX10.12 SDK"
  # https://code.qt.io/cgit/qt/qtconnectivity.git/commit/?h=5.6&id=462323dba4f963844e8c9911da27a0d21e4abf43
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/04c2de3/qt5/qtconnectivity-bluetooth-fix.diff"
    sha256 "41fd73cba0018180015c2be191d63b3c33289f19132c136f482f5c7477620931"
  end

  # Equivalent to upstream commit from 4 Oct 2016 "Fix CUPS compilation error in macOS 10.12"
  # https://code.qt.io/cgit/qt/qtwebengine-chromium.git/commit/chromium/printing/backend/print_backend_cups.cc?h=53-based&id=3bd01037ab73b3ffbf4abbf97c54443a91b2fc4d
  # https://codereview.chromium.org/2248343002
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/34a4ad8/qt5/cups-sierra.patch"
    sha256 "63b5f37d694d0bd1db6d586d98f3c551239dc8818588f3b90dc75dfe6e9952be"
  end

  bottle do
    sha256 "527c9dbc9f71b6cb2bf6134b5f92730e5f1b639ae700f914126ae4d7aee0b7fb" => :sierra
    sha256 "41811d73ca7dc49280e48802c3420bb210f7272464cc2f59d40f03c79b323df0" => :el_capitan
    sha256 "642e52296c4b27b8ecfc3ad2646f4459582365b08c65cf94eb3f9f70c9513230" => :yosemite
  end

  # Additional MaxOSX10.12 SDK bluetooth fixes
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/qt%405.5/qtconnectivity-bluetooth-fix-2.patch"
    sha256 "d6d6b41aab16d8fbb1bdd1a9c05c519064258c4d5612d281e7f8661ec8990eaf"
  end

  bottle do
    sha256 "527c9dbc9f71b6cb2bf6134b5f92730e5f1b639ae700f914126ae4d7aee0b7fb" => :sierra
    sha256 "41811d73ca7dc49280e48802c3420bb210f7272464cc2f59d40f03c79b323df0" => :el_capitan
    sha256 "642e52296c4b27b8ecfc3ad2646f4459582365b08c65cf94eb3f9f70c9513230" => :yosemite
  end

  keg_only :versioned_formula

  # OS X 10.7 Lion is still supported in Qt 5.5, but is no longer a reference
  # configuration and thus untested in practice. Builds on OS X 10.7 have been
  # reported to fail: <https://github.com/Homebrew/homebrew/issues/45284>.
  depends_on :macos => :mountain_lion

  depends_on :xcode => :build

  def install
    args = %W[
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -system-zlib
      -qt-libpng
      -qt-libjpeg
      -no-openssl -securetransport
      -nomake tests
      -no-rpath
      -nomake examples
    ]

    system "./configure", *args
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

    # configure saved PKG_CONFIG_LIBDIR set up by superenv; remove it
    # see: https://github.com/Homebrew/homebrew/issues/27184
    inreplace prefix/"mkspecs/qconfig.pri", /\n\n# pkgconfig/, ""
    inreplace prefix/"mkspecs/qconfig.pri", /\nPKG_CONFIG_.*=.*$/, ""

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`. Also add a `-qt5` suffix to
    # avoid conflict with the `*.app` bundles provided by the `qt` formula.
    # (Note: This move/rename breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") do |app|
      mv app, libexec/"#{app.basename(".app")}-qt5.app"
    end
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end

  test do
    (testpath/"hello.pro").write <<-EOS.undent
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<-EOS.undent
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert File.exist?("hello")
    assert File.exist?("main.o")
    system "./hello"
  end
end
