# Patches for Qt5 must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class QtAT57 < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/5.7/5.7.1/single/qt-everywhere-opensource-src-5.7.1.tar.xz"
  mirror "https://www.mirrorservice.org/sites/download.qt-project.org/official_releases/qt/5.7/5.7.1/single/qt-everywhere-opensource-src-5.7.1.tar.xz"
  sha256 "46ebca977deb629c5e69c2545bc5fe13f7e40012e5e2e451695c583bd33502fa"
  head "https://code.qt.io/qt/qt5.git", :branch => "5.7", :shallow => false

  bottle do
    sha256 "e8eb4c729e6c3a788c982a740efc95bc96c0055ae929c5662b603bbd7a5a76b0" => :sierra
    sha256 "c1a3f9d43de1cf014060b6d66575ae97e6ae77d9102c28971884a7b28a654e0e" => :el_capitan
    sha256 "a5fe56be34bf03a68d0c42aae04d381ce1254cd3e72959793af33f4800f602ec" => :yosemite
  end

  keg_only :versioned_formula

  option "with-docs", "Build documentation"
  option "with-examples", "Build examples"
  option "with-qtwebkit", "Build with QtWebkit module"

  deprecated_option "qtdbus" => "with-dbus"
  deprecated_option "with-d-bus" => "with-dbus"

  # OS X 10.7 Lion is still supported in Qt 5.5, but is no longer a reference
  # configuration and thus untested in practice. Builds on OS X 10.7 have been
  # reported to fail: <https://github.com/Homebrew/homebrew/issues/45284>.
  depends_on :macos => :mountain_lion

  depends_on "dbus" => :optional
  depends_on :mysql => :optional
  depends_on "pkg-config" => :build
  depends_on :postgresql => :optional
  depends_on :xcode => :build

  # http://lists.qt-project.org/pipermail/development/2016-March/025358.html
  resource "qt-webkit" do
    url "https://download.qt.io/community_releases/5.7/5.7.1/qtwebkit-opensource-src-5.7.1.tar.xz"
    sha256 "a46cf7c89339645f94a5777e8ae5baccf75c5fc87ab52c9dafc25da3327b5f03"
  end

  # Restore `.pc` files for framework-based build of Qt 5 on OS X. This
  # partially reverts <https://codereview.qt-project.org/#/c/140954/> merged
  # between the 5.5.1 and 5.6.0 releases. (Remove this as soon as feasible!)
  #
  # Core formulae known to fail without this patch (as of 2016-10-15):
  #   * gnuplot  (with `--with-qt5` option)
  #   * mkvtoolnix (with `--with-qt5` option, silent build failure)
  #   * poppler    (with `--with-qt5` option)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e8fe6567/qt5/restore-pc-files.patch"
    sha256 "48ff18be2f4050de7288bddbae7f47e949512ac4bcd126c2f504be2ac701158b"
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
      -pkg-config
    ]

    args << "-nomake" << "examples" if build.without? "examples"

    if build.with? "mysql"
      args << "-plugin-sql-mysql"
      inreplace "qtbase/configure", /(QT_LFLAGS_MYSQL_R|QT_LFLAGS_MYSQL)=\`(.*)\`/, "\\1=\`\\2 | sed \"s/-lssl -lcrypto//\"\`"
    end

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

    if build.with? "qtwebkit"
      (buildpath/"qtwebkit").install resource("qt-webkit")
      inreplace ".gitmodules", /.*status = obsolete\n((\s*)project = WebKit\.pro)/, "\\1\n\\2initrepo = true"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize
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
