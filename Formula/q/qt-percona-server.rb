class QtPerconaServer < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.8/6.8.1/submodules/qtbase-everywhere-src-6.8.1.tar.xz"
  sha256 "40b14562ef3bd779bc0e0418ea2ae08fa28235f8ea6e8c0cb3bce1d6ad58dcaf"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "60bf3e61d61cf447ab0d3f411d95e03c0adf40e46aed63a3a4f7de827083b88a"
    sha256 cellar: :any,                 arm64_ventura: "ce07eba34a46e36bc779143c694b4814e2089fcc922252c88dba897899046e88"
    sha256 cellar: :any,                 sonoma:        "db44a66e8a43cdecf0aad8d6c6dd85310754584ca0876f6911ebc9035f24dd86"
    sha256 cellar: :any,                 ventura:       "a72f065f79433dfb2c27044f2249f629894ec4c2140e81930682cf0a210d0a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9be1770432fa9425df2bdb36ffc2545ab753ca990337799489c2f473640c32ab"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build

  depends_on "percona-server"
  depends_on "qt"

  conflicts_with "qt-mysql", "qt-mariadb",
    because: "qt-mysql, qt-mariadb, and qt-percona-server install the same binaries"

  def install
    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=ON
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=OFF
      -DFEATURE_sql_sqlite=OFF
      -DMySQL_LIBRARY=#{Formula["percona-server"].opt_lib/shared_library("libperconaserverclient")}
      -DQT_GENERATE_SBOM=OFF
    ]
    # Workaround for missing libraries failure in CI dependent tests when `percona-server`
    # is unlinked due to conflict handling but not re-linked before linkage test
    args << "-DCMAKE_INSTALL_RPATH=#{Formula["percona-server"].opt_lib}" if OS.linux?

    system "cmake", "-S", "src/plugins/sqldrivers", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)
      find_package(Qt6 COMPONENTS Core Sql REQUIRED)
      add_executable(test
          main.cpp
      )
      target_link_libraries(test PRIVATE Qt6::Core Qt6::Sql)
    CMAKE

    (testpath/"test.pro").write <<~EOS
      QT       += core sql
      QT       -= gui
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~CPP
      #include <QCoreApplication>
      #include <QtSql>
      #include <cassert>
      int main(int argc, char *argv[])
      {
        QCoreApplication::addLibraryPath("#{share}/qt/plugins");
        QCoreApplication a(argc, argv);
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
        assert(db.isValid());
        return 0;
      }
    CPP

    system "cmake", "-DCMAKE_BUILD_TYPE=Debug", testpath
    system "make"
    system "./test"

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    system "./test"
  end
end
