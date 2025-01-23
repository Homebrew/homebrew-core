class QtPerconaServer < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.7/6.7.3/submodules/qtbase-everywhere-src-6.7.3.tar.xz"
  sha256 "8ccbb9ab055205ac76632c9eeddd1ed6fc66936fc56afc2ed0fd5d9e23da3097"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]
  revision 1

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "1ddef630fd535a78863fe590869c44ae945fa5440eafcb8a47b1147a5d56d3cf"
    sha256 cellar: :any,                 arm64_ventura: "de8893b2e841a762a7b9dae8933b5f28bd1872e7504e09b2432a0ecf24cd71e3"
    sha256 cellar: :any,                 sonoma:        "91e25ff4c6ba990382dd7c97e015163bef458660d7e45c0febe7f335eb1b5698"
    sha256 cellar: :any,                 ventura:       "1dec6aa1e06b02ae44355af80b74287c5855d8101e74a274006b735a529f0c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "428c6d820ad63f8121c706c2570c6d227e108ea7eba62a85fbb67eb924d2d5f8"
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
