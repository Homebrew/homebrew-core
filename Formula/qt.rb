# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  revision 1
  head "https://code.qt.io/qt/qt5.git", :branch => "5.12", :shallow => false

  stable do
    url "https://download.qt.io/official_releases/qt/5.11/5.11.2/single/qt-everywhere-src-5.11.2.tar.xz"
    mirror "https://qt.mirror.constant.com/archive/qt/5.11/5.11.2/single/qt-everywhere-src-5.11.2.tar.xz"
    mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/qt5/qt-everywhere-src-5.11.2.tar.xz"
    sha256 "c6104b840b6caee596fa9a35bc5f57f67ed5a99d6a36497b6fe66f990a53ca81"

    # Restore `.pc` files for framework-based build of Qt 5 on macOS, partially
    # reverting <https://codereview.qt-project.org/#/c/140954/>
    # Core formulae known to fail without this patch (as of 2016-10-15):
    #   * gnuplot (with `--with-qt` option)
    #   * mkvtoolnix (with `--with-qt` option, silent build failure)
    #   * poppler (with `--with-qt` option)
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e8fe6567/qt5/restore-pc-files.patch"
      sha256 "48ff18be2f4050de7288bddbae7f47e949512ac4bcd126c2f504be2ac701158b"
    end

    # Chromium build failures with Xcode 10, fixed upstream:
    # https://bugs.chromium.org/p/chromium/issues/detail?id=840251
    # https://bugs.chromium.org/p/chromium/issues/detail?id=849689
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/962f0f/qt/xcode10.diff"
      sha256 "c064398411c69f2e1c516c0cd49fcd0755bc29bb19e65c5694c6d726c43389a6"
    end
  end

  bottle do
    sha256 "84a1a758d7881f9a446fd76fe4360ce7c5508c48761a74032a361996df1f79ec" => :mojave
    sha256 "ad85f42e73648dc47c8c903e0045e6b8cf62c99888144c73893a0226f2a5b51e" => :high_sierra
    sha256 "cd58fa592235c48ae050861eb3fca82ecfe54ddf103e5962b2bf9621f815f640" => :sierra
  end

  keg_only "Qt 5 has CMake issues when linked"

  option "with-examples", "Build examples"
  option "without-proprietary-codecs", "Don't build with proprietary codecs (e.g. mp3)"

  deprecated_option "with-mysql" => "with-mysql-client"

  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "mysql-client" => :optional
  depends_on "postgresql" => :optional

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
      -dbus-runtime
    ]

    args << "-nomake" << "examples" if build.without? "examples"

    if build.with? "mysql-client"
      args << "-plugin-sql-mysql"
      (buildpath/"brew_shim/mysql_config").write <<~EOS
        #!/bin/sh
        if [ x"$1" = x"--libs" ]; then
          mysql_config --libs | sed "s/-lssl -lcrypto//"
        else
          exec mysql_config "$@"
        fi
      EOS
      chmod 0755, "brew_shim/mysql_config"
      args << "-mysql_config" << buildpath/"brew_shim/mysql_config"
    end

    args << "-plugin-sql-psql" if build.with? "postgresql"
    args << "-proprietary-codecs" if build.with? "proprietary-codecs"

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

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    # (Note: This move breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") { |app| mv app, libexec }
  end

  def caveats; <<~EOS
    We agreed to the Qt open source license for you.
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
