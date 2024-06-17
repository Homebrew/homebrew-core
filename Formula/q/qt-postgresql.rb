class QtPostgresql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.7/6.7.0/submodules/qtbase-everywhere-src-6.7.0.tar.xz"
  sha256 "11b2e29e2e52fb0e3b453ea13bbe51a10fdff36e1c192d8868c5a40233b8b254"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6f073765a42dda11f1cdab9ca2fb66e7c890f4d72562e82fbeeb6ed290fcf33"
    sha256 cellar: :any,                 arm64_ventura:  "3ffcc647516380404e0d7ceb7bffba1b375b938a3fc7bb9f8bd87c83bff42399"
    sha256 cellar: :any,                 arm64_monterey: "881013d2a4c49285248404b58806e3bc3c9acabdad6583fa770686c1ff27ae80"
    sha256 cellar: :any,                 sonoma:         "330f4ac789b655f692f2e2dca1b35dd902c1562da008f4bd025c2eaf375d0e5c"
    sha256 cellar: :any,                 ventura:        "1b088f9703c3868a2362d30d0371e92414755b88e42d6e55d3d7f6bd530e1021"
    sha256 cellar: :any,                 monterey:       "3d40b375f8ba4d85f2ae0a34504c745dde53f3be6526be5d38ca2762c02972f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddf52e24abb8a3def2c3a12886a62da390df6e5a8acddc8cc41fe94b046f0728"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "libpq"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=ON
      -DFEATURE_sql_sqlite=OFF
    ]

    cd "src/plugins/sqldrivers" do
      system "cmake", ".", *args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
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
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core sql
      QT       -= gui
      TARGET = test
      CONFIG   += console debug
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QtSql>
      #include <cassert>
      int main(int argc, char *argv[])
      {
        QCoreApplication::addLibraryPath("#{share}/qt/plugins");
        QCoreApplication a(argc, argv);
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
        assert(db.isValid());
        return 0;
      }
    EOS

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Debug"
    system "cmake", "--build", "build"
    system "./build/test"

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    system "./test"
  end
end
