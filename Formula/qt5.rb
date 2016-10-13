class OracleHomeVarRequirement < Requirement
  fatal true
  satisfy(:build_env => false) { ENV["ORACLE_HOME"] }

  def message; <<-EOS.undent
      To use --with-oci you have to set the ORACLE_HOME environment variable.
      Check Oracle Instant Client documentation for more information.
    EOS
  end
end

# Patches for Qt5 must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class Qt5 < Formula
  desc "Version 5 of the Qt framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/5.6/5.6.2/single/qt-everywhere-opensource-src-5.6.2.tar.xz"
  sha256 "83e61bfc78bba230770704e828fa4d23fe3bbfdcfa4a8f5db37ce149731d89b3"

  head "https://code.qt.io/qt/qt5.git", :branch => "5.6", :shallow => false

  bottle do
    sha256 "3e18f74f18c81bc2d27c64edbf266b6aee90b29de7204de726801a7d65bc30bc" => :sierra
    sha256 "db805c12e877aa51970ba710705cbd462e01ea163634c6cc6d6febac292047ee" => :el_capitan
    sha256 "c2829138042fb9dcf07732682fbe69ab141da5a91451a3b25b8146117b330c13" => :yosemite
  end

  keg_only "Qt 5 conflicts Qt 4"

  option "with-docs", "Build documentation"
  option "with-examples", "Build examples"
  option "with-oci", "Build with Oracle OCI plugin"
  option "with-qtwebkit", "Build with QtWebkit module"
  option "without-webengine", "Build without QtWebEngine module"

  deprecated_option "qtdbus" => "with-dbus"
  deprecated_option "with-d-bus" => "with-dbus"

  # OS X 10.7 Lion is still supported in Qt 5.5, but is no longer a reference
  # configuration and thus untested in practice. Builds on OS X 10.7 have been
  # reported to fail: <https://github.com/Homebrew/homebrew/issues/45284>.
  depends_on :macos => :mountain_lion

  depends_on "dbus" => :optional
  depends_on :mysql => :optional
  depends_on :postgresql => :optional
  depends_on :xcode => :build

  depends_on OracleHomeVarRequirement if build.with? "oci"

  resource "qt-webkit" do
    # http://lists.qt-project.org/pipermail/development/2016-March/025358.html
    url "https://download.qt.io/community_releases/5.6/5.6.2/qtwebkit-opensource-src-5.6.2.tar.xz"
    sha256 "528a6b8b1c5095367b26e8ce4f3a46bb739e2e9913ff4dfc6ef58a04fcd73966"
  end

  # Upstream commit from 3 Oct 2016 "Fixed build with MaxOSX10.12 SDK"
  # http://code.qt.io/cgit/qt/qtconnectivity.git/commit/?h=5.6&id=462323dba4f963844e8c9911da27a0d21e4abf43
  # Should be removed for > 5.6.2 or > 5.7.0
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/04c2de3/qt5/qtconnectivity-bluetooth-fix.diff"
    sha256 "41fd73cba0018180015c2be191d63b3c33289f19132c136f482f5c7477620931"
  end

  # Upstream commit from 1 Aug 2016 "BASELINE: Update Chromium to 53.0.2785.41"
  # http://code.qt.io/cgit/qt/qtwebengine-chromium.git/commit/chromium/base/mac/sdk_forward_declarations.h?h=upstream-master&id=28b1110370900897ab652cb420c371fab8857ad4
  # Remove when qtwebengine's src/3rdparty/chromium submodule points to a commit
  # of qtwebengine-chromium with Chromium >= 53.0.2785.41
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/04c2de3/qt5/qtwebengine-bluetooth-fix.diff"
    sha256 "218b8682d7e8a3f74618d0bd87e4797e13fc2cbfe49c21a2845e64da3fe8868a"
  end

  def install
    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -system-zlib
      -qt-libpng
      -qt-libjpeg
      -qt-freetype
      -qt-pcre
      -nomake tests
      -no-rpath
    ]

    args << "-nomake" << "examples" if build.without? "examples"

    args << "-plugin-sql-mysql" if build.with? "mysql"
    args << "-plugin-sql-psql" if build.with? "postgresql"

    if build.with? "dbus"
      dbus_opt = Formula["dbus"].opt_prefix
      args << "-I#{dbus_opt}/lib/dbus-1.0/include"
      args << "-I#{dbus_opt}/include/dbus-1.0"
      args << "-L#{dbus_opt}/lib"
      args << "-ldbus-1"
      args << "-dbus-linked"
    else
      args << "-no-dbus"
    end

    if build.with? "oci"
      args << "-I#{ENV["ORACLE_HOME"]}/sdk/include"
      args << "-L#{ENV["ORACLE_HOME"]}"
      args << "-plugin-sql-oci"
    end

    args << "-skip" << "qtwebengine" if build.without? "webengine"

    if build.with? "qtwebkit"
      (buildpath/"qtwebkit").install resource("qt-webkit")
      inreplace ".gitmodules", /.*status = obsolete\n((\s*)project = WebKit\.pro)/, "\\1\n\\2initrepo = true"
    end

    system "./configure", *args
    system "make"
    ENV.j1
    system "make", "install"

    if build.with? "docs"
      system "make", "docs"
      system "make", "install_docs"
    end

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
    inreplace prefix/"mkspecs/qconfig.pri",
              /\n# pkgconfig\n(PKG_CONFIG_(SYSROOT_DIR|LIBDIR) = .*\n){2}\n/,
              "\n"

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
