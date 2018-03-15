# Patches for Qt5 must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class QtAT55 < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/archive/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.xz"
  mirror "https://www.mirrorservice.org/sites/download.qt-project.org/archive/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.xz"
  sha256 "6f028e63d4992be2b4a5526f2ef3bfa2fe28c5c757554b11d9e8d86189652518"
  revision 1

  bottle do
    sha256 "30c5a19c4c18737d40ab072d27a1b5220e746eb7a549812ceb1799eb07cfd58f" => :high_sierra
    sha256 "f44403a72ab524a6f010bcf86f1414c42729f4763f4e7c2cfb0f6cba2b6135d2" => :sierra
    sha256 "e1e66c950b66c9bd59b43566a4a5919f4f14a0331c7d9aa062d8c6a152e157c4" => :el_capitan
    sha256 "debdc797d8314548a7cfc05ac97699d98ceeaf46265180a979bbb96190024d1c" => :yosemite
  end

  keg_only :versioned_formula

  # OS X 10.7 Lion is still supported in Qt 5.5, but is no longer a reference
  # configuration and thus untested in practice. Builds on OS X 10.7 have been
  # reported to fail: <https://github.com/Homebrew/homebrew/issues/45284>.
  depends_on :macos => :mountain_lion

  depends_on :xcode => :build

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

  # Additional MaxOSX10.12 SDK bluetooth fixes
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/qt%405.5/qtconnectivity-bluetooth-fix-2.patch"
    sha256 "d6d6b41aab16d8fbb1bdd1a9c05c519064258c4d5612d281e7f8661ec8990eaf"
  end

  # Fix QTBUG-62266 and deprecated Bluetooth API
  if MacOS.version >= :high_sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/3ad1b0e172/qt%405.5/high_sierra.patch"
      sha256 "0959c86ac37c65a7ce4b813ee1e4942425117f76c981d64ff41da782ba7b2efc"
    end
  end

  # Fix Xcode 9 build errors
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/6152bded7d/qt%405.5/xcode9.patch"
      sha256 "757f377f3fcf753ef6d5b543e6291928d07591c3e3ee8a536a88433aa49d4fbb"
    end
  end

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

    # Qt tries to find xcrun using xcrun, which fails with Xcode 8 with the
    # error "Project ERROR: Xcode not set up properly. You may need to confirm
    # the license agreement by running /usr/bin/xcodebuild."
    # See https://github.com/Homebrew/homebrew-core/issues/8777.
    # Fixed upstream 7 Jul 2016 in https://code.qt.io/cgit/qt/qtbase.git/patch/configure?id=77a71c32c9d19b87f79b208929e71282e8d8b5d9.
    if MacOS::Xcode.version >= "8.0"
      inreplace prefix/"mkspecs/features/mac/default_pre.prf",
                /xcrun -find xcrun/, "xcrun -find xcodebuild"
    end

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

  def caveats; <<~EOS
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
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

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert_predicate testpath/"hello", :exist?
    assert_predicate testpath/"main.o", :exist?
    system "./hello"
  end
end
