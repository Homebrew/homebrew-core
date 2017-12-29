# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/5.10/5.10.0/single/qt-everywhere-src-5.10.0.tar.xz"
  mirror "https://www.mirrorservice.org/sites/download.qt-project.org/official_releases/qt/5.10/5.10.0/single/qt-everywhere-src-5.10.0.tar.xz"
  sha256 "936d4cf5d577298f4f9fdb220e85b008ae321554a5fcd38072dc327a7296230e"
  head "https://code.qt.io/qt/qt5.git", :branch => "5.10", :shallow => false

  bottle do
    sha256 "332ab2f3eb7c13510f460c13d28a562db03297149a3615feb9e3d467fafde56c" => :high_sierra
    sha256 "c93cf6ead1774cfa7a369c92c7d6a69154bc0dd5b48a0e7ddf3a78202c4a3dc5" => :sierra
    sha256 "44425e23d8b9c2b8b2f50d850ca94dcd411cd89e20e057c8d6505c9056d06328" => :el_capitan
  end

  keg_only "Qt 5 has CMake issues when linked"

  option "with-docs", "Build documentation"
  option "with-examples", "Build examples"

  # OS X 10.7 Lion is still supported in Qt 5.5, but is no longer a reference
  # configuration and thus untested in practice. Builds on OS X 10.7 have been
  # reported to fail: <https://github.com/Homebrew/homebrew/issues/45284>.
  depends_on :macos => :mountain_lion

  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "mysql" => :optional
  depends_on :postgresql => :optional

  # Restore `.pc` files for framework-based build of Qt 5 on OS X. This
  # partially reverts <https://codereview.qt-project.org/#/c/140954/> merged
  # between the 5.5.1 and 5.6.0 releases. (Remove this as soon as feasible!)
  #
  # Core formulae known to fail without this patch (as of 2016-10-15):
  #   * gnuplot  (with `--with-qt` option)
  #   * mkvtoolnix (with `--with-qt` option, silent build failure)
  #   * poppler    (with `--with-qt` option)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e8fe6567/qt5/restore-pc-files.patch"
    sha256 "48ff18be2f4050de7288bddbae7f47e949512ac4bcd126c2f504be2ac701158b"
  end

  # Remove for > 5.10.0
  # Fix "error: 'loadFileURL:allowingReadAccessToURL:' is only available on
  # macOS 10.11 or newer [-Werror,-Wunguarded-availability]"
  # Reported 8 Dec 2017 https://bugreports.qt.io/browse/QTBUG-65075
  # Equivalent to upstream fix from 8 Dec 2017 https://codereview.qt-project.org/#/c/213993/
  if MacOS::Xcode.version >= "9.0"
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/9c97726e2b153099049326ade23fe24b52b778fe/qt/QTBUG-65075.diff"
      sha256 "a51595868c6173ab53463107e0ee3355576002c32ab80897587c3607589cfd22"
    end
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
      -dbus-runtime
    ]

    args << "-nomake" << "examples" if build.without? "examples"

    if build.with? "mysql"
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

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    # (Note: This move breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") { |app| mv app, libexec }
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
