class QtMariadb < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.2/submodules/qtbase-everywhere-src-6.9.2.tar.xz"
  sha256 "44be9c9ecfe04129c4dea0a7e1b36ad476c9cc07c292016ac98e7b41514f2440"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "cbb411b1b7dddb367615925cb92e1c617085e8fcf2112a8634506ee1e263172b"
    sha256 cellar: :any,                 arm64_ventura: "4bc8cb1b433e25c7eea4d8d74db1ca9b01e7ef73317c23fc1d64c14b880b056e"
    sha256 cellar: :any,                 sonoma:        "1e0749cce6cc14884c6c020c22e61c54b6d2445887accf191f728e88087ed478"
    sha256 cellar: :any,                 ventura:       "825ef5dcb8555457b67dd74c6a116bbb5728413563773a42d554b1ef8c02316e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69e5b57abc5db719f6c0fd62204bfc2f745216bfb833b335a444b31c80f22c2f"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "mariadb"
  depends_on "qt"

  conflicts_with "qt-mysql", "qt-percona-server",
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
      -DQT_GENERATE_SBOM=OFF
    ]

    system "cmake", "-S", "src/plugins/sqldrivers", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
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
      CONFIG   += console debug
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QMARIADB");
        assert(db.isValid());
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Debug"
    system "cmake", "--build", "build"
    system "./build/test"

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    system "./test"
  end
end
