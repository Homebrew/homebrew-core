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
  url "https://download.qt.io/official_releases/qt/5.6/5.6.1-1/single/qt-everywhere-opensource-src-5.6.1-1.tar.xz"
  mirror "https://www.mirrorservice.org/sites/download.qt-project.org/official_releases/qt/5.6/5.6.1-1/single/qt-everywhere-opensource-src-5.6.1-1.tar.xz"
  sha256 "ce08a7eb54661705f55fb283d895a089b267c688fabe017062bd71b9231736db"

  head "https://code.qt.io/qt/qt5.git", :branch => "5.6", :shallow => false

  bottle do
    sha256 "2aaa410f2ab2fbbddbc8c3438e43bc9f4271774c794bcae8f935fb6b1b5a82ed" => :el_capitan
    sha256 "eefa531c6ebc757982b31f17935fa2220aad52caf3112e389a878dce04f40490" => :yosemite
    sha256 "73d33dd2563c39542844c276a7bd43463f2974fde141e7afeb3057168adbe606" => :mavericks
  end

  # Restore `.pc` files for framework-based build of Qt 5 on macOS. This
  # partially reverts <https://codereview.qt-project.org/#/c/140954/> merged
  # between the 5.5.1 and 5.6.0 releases. (Remove this as soon as feasible!)
  #
  # Core formulae known to fail without this patch (as of 2016-03-17):
  #   * mkvtoolnix (with `--with-qt5` option, silent build failure)
  #   * poppler    (with `--with-qt5` option)
  #   * wireshark  (with `--with-qt5` option)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e8fe6567/qt5/restore-pc-files.patch"
    sha256 "48ff18be2f4050de7288bddbae7f47e949512ac4bcd126c2f504be2ac701158b"
  end

  # Fix build error due to missing Mac QtBase widget example targets, detected
  # by logic introduced in <https://codereview.qt-project.org/#/c/156610/> and
  # corrected in <https://codereview.qt-project.org/#/c/161001/>.
  # Should land in either 5.6.2 and/or 5.7.1.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6ffd0e250d374193613a51beda8830dda9b67e56/qt5/QTBUG-54110.patch"
    sha256 "2cf77b820f46f0c404284882b4a4a97bf005b680062842cdc53e107a821deeda"
  end

  keg_only "Qt 5 conflicts Qt 4"

  option "with-docs", "Build documentation"
  option "with-examples", "Build examples"
  option "with-oci", "Build with Oracle OCI plugin"
  option "with-qtwebkit", "Build with QtWebkit module"
  option "without-webengine", "Build without QtWebEngine module"

  deprecated_option "qtdbus" => "with-dbus"
  deprecated_option "with-d-bus" => "with-dbus"

  # macOS 10.7 Lion is still supported in Qt 5.5, but is no longer a reference
  # configuration and thus untested in practice. Builds on macOS 10.7 have been
  # reported to fail: <https://github.com/Homebrew/homebrew/issues/45284>.
  depends_on :macos => :mountain_lion

  depends_on "dbus" => :optional
  depends_on :mysql => :optional
  depends_on :postgresql => :optional
  depends_on :xcode => :build

  depends_on OracleHomeVarRequirement if build.with? "oci"

  resource "qt-webkit" do
    # http://lists.qt-project.org/pipermail/development/2016-March/025358.html
    url "https://download.qt.io/community_releases/5.6/5.6.1/qtwebkit-opensource-src-5.6.1.tar.gz"
    sha256 "f5ba5afc5846fc755575dd04081a90a9536f920e312f18f6fb1f5a0c33f477b0"
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
