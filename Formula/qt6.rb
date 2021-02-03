class Qt6 < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.1/single/qt-everywhere-src-6.0.1.tar.xz"
  sha256 "d13cfac103cd80b216cd2f73d0211dd6b1a1de2516911c89ce9c5ed14d9631a8"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build

  depends_on "assimp"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "jpeg"
  depends_on "libb2"
  depends_on "libpng"
  depends_on "libproxy"
  depends_on "llvm"
  depends_on "pcre2"
  depends_on "python@3.9"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "perl"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  patch :DATA

  def install
    ENV.append "LDFLAGS", "-framework GSS"
    ENV.append "LDFLAGS", "-framework IOKit"

    config_args = %W[
      -release

      -prefix #{HOMEBREW_PREFIX}
      -extprefix #{prefix}

      -plugindir share/qt/plugins
      -qmldir share/qt/qml
      -docdir share/doc/qt
      -translationdir share/qt/translations
      -examplesdir share/qt/examples
      -testsdir share/qt/tests

      -libproxy
      -no-feature-relocatable
      -no-sql-odbc
      -no-sql-psql
      -no-sql-mysql
      -system-sqlite
    ]

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DICU_ROOT=#{Formula["icu4c"].opt_prefix}
      -DLLVM_INSTALL_DIR=#{Formula["llvm"].opt_prefix}

      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DINSTALL_MKSPECSDIR=share/qt/mkspecs
      INSTALL_DESCRIPTIONSDIR=share/qt/modules

      -DFEATURE_pkg_config=ON
    ]

    system "./configure", *config_args, "--", *cmake_args
    system "ninja"
    system "ninja", "install"

    # FIXME: This is required to enable installation of all configurations of
    # a Qt built with Ninja Multi-Config until the following issue is fixed.
    # https://gitlab.kitware.com/cmake/cmake/-/issues/20713
    rm bin/"qt-cmake-private-install.cmake"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", /.*set.__qt_initial_.*/, ""

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    # FIXME: this step just moves `*.app` bundles into `libexec` and create link
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") do |app|
      mv app, libexec
      bin.install_symlink "#{libexec/app.stem}.app/Contents/MacOS/#{app.stem}"
    end
  end

  test do
    assert_equal HOMEBREW_PREFIX, shell_output("qmake -query QT_INSTALL_PREFIX").strip

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.16.0)

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Widgets REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Widgets)
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = test
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

    system "cmake", testpath
    system "make"
    assert_equal "Hello World!", shell_output("#{testpath}/test 2>&1").strip

    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete "CPATH"
    system bin/"qmake", testpath/"test.pro"
    system "make"
    assert_equal "Hello World!", shell_output("#{testpath}/test 2>&1").strip
  end
end

__END__
diff --git a/qtbase/src/corelib/global/qlibraryinfo.cpp b/qtbase/src/corelib/global/qlibraryinfo.cpp
index bb1eafe..e433ac4 100644
--- a/qtbase/src/corelib/global/qlibraryinfo.cpp
+++ b/qtbase/src/corelib/global/qlibraryinfo.cpp
@@ -600,7 +600,7 @@ QString qmake_abslocation();
 
 static QString getPrefixFromHostBinDir(const char *hostBinDirToPrefixPath)
 {
-    const QString canonicalQMakePath = QFileInfo(qmake_abslocation()).canonicalPath();
+    const QString canonicalQMakePath = QFileInfo(qmake_abslocation()).absolutePath();
     return QDir::cleanPath(canonicalQMakePath + QLatin1Char('/')
                            + QLatin1String(hostBinDirToPrefixPath));
 }
