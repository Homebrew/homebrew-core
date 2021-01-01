# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.0/single/qt-everywhere-src-6.0.0.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/official_releases/qt/6.0/6.0.0/single/qt-everywhere-src-6.0.0.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/official_releases/qt/6.0/6.0.0/single/qt-everywhere-src-6.0.0.tar.xz"
  sha256 "d39a1a557a0dc8dc5ea2eaaee0fa015c71dcbb79c25a6aea421c594227565296"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  head "https://code.qt.io/qt/qt5.git", branch: "dev", shallow: false

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "ac22ab5828d894518e42f00e254f1e36d5be4e5f3f1c08b3cd49b57819daaf2d" => :big_sur
    sha256 "049a78d3f84586a28d9d035bc5ff1a677b0dd9bd8c81b5775919591cde99f258" => :arm64_big_sur
    sha256 "51ab78a99ff3498a236d15d9bed92962ddd2499c4020356469f7ab1090cf6825" => :catalina
    sha256 "25c4a693c787860b090685ac5cbeea18128d4d6361eed5b1bfed1b16ff6e4494" => :mojave
  end

  keg_only "Qt has CMake issues when linked"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on xcode: :build
  depends_on macos: :mojave

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "icu4c"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  # QTBUG-89176: Fix a critical bug in Qt 6.0.0 - QCache related crash.
  # Patch from https://codereview.qt-project.org/c/qt/qtbase/+/326060
  patch do
    url "https://code.qt.io/cgit/qt/qtbase.git/patch/?id=b97001aa1cbd21008ebc48fe61b15fbcacb14875"
    sha256 "87675faadfca6d2f77877328e69a464718efd9d289c1632ce536a5e3ebdc2157"
    directory "qtbase"
  end

  def install
    args = %W[
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -cmake
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
      -no-avx2
    ]

    system "./configure", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    rm_f bin/"qt-cmake-private-install.cmake"
    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", /.*set.__qt_initial_.*/, ""

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
    (testpath/"CMakeLists.txt").write <<~EOS
      project(hello)
      cmake_minimum_required(VERSION 3.0)
      find_package(Qt6 REQUIRED COMPONENTS Core Gui)
      add_executable(hello main.cpp)
      target_link_libraries(hello PRIVATE Qt6::Core Qt6::Gui)
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

    system "cmake", testpath, "-DCMAKE_PREFIX_PATH=#{lib}/cmake"
    system "make"

    assert_predicate testpath/"hello", :exist?
    system "./hello"
  end
end
