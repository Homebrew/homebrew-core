class QtBase < Formula
  desc "Base components of Qt framework (Core, Gui, Widgets, Network, ...)"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.0/submodules/qtbase-everywhere-src-6.0.0.tar.xz"
  sha256 "ae227180272d199cbb15318e3353716afada5c57fd5185b812ae26912c958656"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on xcode: :build # for xcodebuild to get version

  # Apple Advanced Typography need qt bundled harfbuzz
  # dependency openssl, fontfonfig will cause config error
  # mapped cmake variables are:
  #   -DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}
  #   -DDFEATURE_fontconfig:BOOL=ON
  # Qt SQL supported DBs are:
  # DB2 (IBM)
  #   FEATURE_sql_db2:BOOL=OFF
  # InterBase
  #   FEATURE_sql_ibase:BOOL=OFF
  # MySql
  #   FEATURE_sql_mysql:BOOL=ON
  # OCI (Oracle)
  #   FEATURE_sql_oci:BOOL=OFF
  # ODBC
  #   FEATURE_sql_odbc:BOOL=ON
  # PostgreSQL
  #   FEATURE_sql_psql:BOOL=ON
  # SQLite
  #   FEATURE_sql_sqlite:BOOL=ON

  # optional dependencies
  # zstd
  # pcre2
  # libjpeg
  # libpng
  # gegl
  # dbus

  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "icu4c" # Qt needs icu's utilities
  depends_on "jpeg"
  depends_on "libb2"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "pkg-config"
  depends_on "postgresql"
  depends_on "unixodbc"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  # HACK: qmake use symlink's canonical path before patching
  patch :DATA

  def install
    # use framework, Qt use some symbol not in krb5
    ENV.append "LDFLAGS", "-framework GSS"

    # Qt support use `CMAKE_STAGING_PREFIX` instead of `CMAKE_INSTALL_PREFIX` to
    # change the install dir, see
    # https://cmake.org/cmake/help/latest/variable/CMAKE_STAGING_PREFIX.html
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=/usr/local
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DICU_ROOT=#{Formula["icu4c"].opt_prefix}

      -DINSTALL_ARCHDATADIR=share/qt
      -DINSTALL_DATADIR=share/qt

      -DINSTALL_DESCRIPTIONSDIR=share/qt/modules
      -DINSTALL_DOCDIR=share/doc/qt
      -DINSTALL_EXAMPLESDIR=share/qt/examples
      -DINSTALL_MKSPECSDIR=share/qt/mkspecs
      -DINSTALL_PLUGINSDIR=share/qt/plugins
      -DINSTALL_QMLDIR=share/qt/qml
      -DINSTALL_TESTSDIR=share/qt/tests

      -DFEATURE_appstore_compliant:BOOL=ON
      -DFEATURE_freetype:BOOL=ON
      -DFEATURE_pkg_config:BOOL=ON
      -DFEATURE_relocatable:BOOL=OFF
      -DFEATURE_zstd:BOOL=ON
    ]

    system "cmake", "-G", "Ninja", ".", *args
    system "ninja"
    system "ninja", "install"

    # This is required to enable installation of all configurations of
    # a Qt built with Ninja Multi-Config until the following issue is fixed.
    # https://gitlab.kitware.com/cmake/cmake/-/issues/20713
    rm bin/"qt-cmake-private-install.cmake"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # FIXME: remove this toolchain file seems not good
    rm lib/"cmake/Qt6/qt.toolchain.cmake"

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.16.0)

      project(hello VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Widgets REQUIRED)

      add_executable(hello
          main.cpp
      )

      target_link_libraries(hello PRIVATE Qt6::Widgets)
    EOS

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

    system "cmake", testpath
    system "make"
    system "./hello"

    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete "CPATH"
    system bin/"qmake", testpath/"hello.pro"
    system "make"
    system "./hello"
  end
end

__END__
diff --git a/src/corelib/global/qlibraryinfo.cpp b/src/corelib/global/qlibraryinfo.cpp
index 301c3ab..fbd6adf 100644
--- a/src/corelib/global/qlibraryinfo.cpp
+++ b/src/corelib/global/qlibraryinfo.cpp
@@ -597,7 +597,7 @@ QString qmake_abslocation();
 
 static QString getPrefixFromHostBinDir(const char *hostBinDirToPrefixPath)
 {
-    const QString canonicalQMakePath = QFileInfo(qmake_abslocation()).canonicalPath();
+    const QString canonicalQMakePath = QFileInfo(qmake_abslocation()).absolutePath();
     return QDir::cleanPath(canonicalQMakePath + QLatin1Char('/')
                            + QLatin1String(hostBinDirToPrefixPath));
 }
