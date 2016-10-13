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
    sha256 "2aaa410f2ab2fbbddbc8c3438e43bc9f4271774c794bcae8f935fb6b1b5a82ed" => :sierra
    sha256 "2aaa410f2ab2fbbddbc8c3438e43bc9f4271774c794bcae8f935fb6b1b5a82ed" => :el_capitan
    sha256 "eefa531c6ebc757982b31f17935fa2220aad52caf3112e389a878dce04f40490" => :yosemite
    sha256 "73d33dd2563c39542844c276a7bd43463f2974fde141e7afeb3057168adbe606" => :mavericks
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

  # qtconnectivity bluetooth fix
  patch do
    url "https://gist.githubusercontent.com/ilovezfs/9d9f17b166b37a68f5f33a1df381675f/raw/5dd9b3ee82d486fc78373ca1e8bd16bbbc1ff84f/gistfile1.txt"
    sha256 "41fd73cba0018180015c2be191d63b3c33289f19132c136f482f5c7477620931"
  end

  # qtwebengine bluetooth fix
  patch do
    url "https://gist.githubusercontent.com/ilovezfs/eedb11ddbceaaa5eb1f4ffd8baa40c32/raw/f2518f204a459da5f200739ce7553f1a8f151215/gistfile1.txt"
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
