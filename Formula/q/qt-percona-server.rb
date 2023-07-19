class QtPerconaServer < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.2/submodules/qtbase-everywhere-src-6.5.2.tar.xz"
  sha256 "3db4c729b4d80a9d8fda8dd77128406353baff4755ca619177eda4cddae71269"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "08d26aa391fbc065a7122ac15b3702983a5de527da6a068513ee8482c612ec3a"
    sha256 cellar: :any,                 arm64_ventura:  "b32e9ae3cc043307ee278c449f2eb76ef85caa0c30d1c0d315cf73e9eb9c85c4"
    sha256 cellar: :any,                 arm64_monterey: "d918f5098cfa4131ad417aaf36fb5da2ab6e7edb016b279813634b9b74dd9244"
    sha256 cellar: :any,                 arm64_big_sur:  "da23de68a5f0a33c3c18224c028d2ec45ab36efe215defc3b78ac1fe8dd9350f"
    sha256 cellar: :any,                 sonoma:         "f9357ac95680a3b14e129a716dfe69ed4f0b82785d6c471cd6ad914b70a179ce"
    sha256 cellar: :any,                 ventura:        "6c7216393f5536a33a069ee2171d8d6b9b1098361d2892335bebed73d4a66427"
    sha256 cellar: :any,                 monterey:       "05d9e0fb047abbe171ecd16a3f923a10a9e286f0852b0cedb0bd5a6f747f97bb"
    sha256 cellar: :any,                 big_sur:        "b1905ee3be1127084423f54c4c958869497c7e744ee786ca6ab9cfe41531215f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efc913d411945f1b3e8e314aee4ef92bfdf6aa216615adec6dc9e041f482aa8f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkg-config" => :build

  depends_on "percona-server"
  depends_on "qt"

  conflicts_with "qt-mysql", "qt-mariadb",
    because: "qt-mysql, qt-mariadb, and qt-percona-server install the same binaries"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=ON
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=OFF
      -DFEATURE_sql_sqlite=OFF

      -DMySQL_LIBRARY=#{Formula["percona-server"].opt_lib}/#{shared_library("libperconaserverclient")}
    ]

    cd "src/plugins/sqldrivers" do
      system "cmake", "-S", ".", "-B", "build", *args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
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
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core sql
      QT       -= gui
      TARGET = test
      CONFIG   += console
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
        assert(db.isValid());
        return 0;
      }
    EOS

    system "cmake", "-DCMAKE_BUILD_TYPE=Debug", testpath
    system "make"
    system "./test"

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    system "./test"
  end
end
