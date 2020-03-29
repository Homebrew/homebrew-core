# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/5.14/5.14.1/single/qt-everywhere-src-5.14.1.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.14/5.14.1/single/qt-everywhere-src-5.14.1.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.14/5.14.1/single/qt-everywhere-src-5.14.1.tar.xz"
  sha256 "6f17f488f512b39c2feb57d83a5e0a13dcef32999bea2e2a8f832f54a29badb8"

  head "https://code.qt.io/qt/qt5.git", :branch => "dev", :shallow => false

  bottle do
    cellar :any
    sha256 "e40589965586f2c1132da117aca2e0cf12f3ea4bb1029d26b4b0819d8aae3bd5" => :catalina
    sha256 "149a1c2d2af7afda9910e1d4e3956c27ffa31ea511a8320930abf7a9079d0330" => :mojave
    sha256 "69a7f1ad615f78735b6635da1b1fab5e4eea57dd9be560c695f82b796457870a" => :high_sierra
  end

  keg_only "Qt 5 has CMake issues when linked"

  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on :macos => :sierra

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "sqlite"

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
      -nomake examples
      -nomake tests
      -no-rpath
      -pkg-config
      -dbus-runtime
      -proprietary-codecs
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

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    # (Note: This move breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") { |app| mv app, libexec }
  end

  def caveats
    <<~EOS
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
