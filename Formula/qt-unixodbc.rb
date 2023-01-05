class QtUnixodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.2/submodules/qtbase-everywhere-src-6.4.2.tar.xz"
  sha256 "a88bc6cedbb34878a49a622baa79cace78cfbad4f95fdbd3656ddb21c705525d"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "4229899b889f6e2663b5e2ac365726c6bff7beea6ab6321afe18d94533efe5da"
    sha256 cellar: :any, arm64_monterey: "0df604bed86c91ce398a854abfd5197c648c304ddc4d80f55a62284524625e15"
    sha256 cellar: :any, arm64_big_sur:  "d773e6603aee772c194e50f38a68c7cc27beff6de17e5a783d1d876bde75541f"
    sha256 cellar: :any, ventura:        "1b3cc95453d22ac32c45feb8ef16bc37da8be1315ee2c8e54971bd70e973bf91"
    sha256 cellar: :any, monterey:       "f0f2bea7b2c0d5f824cc4044fda2f048d17b80ed630fb27ebe9c393e10ad74ce"
    sha256 cellar: :any, big_sur:        "2d8683a595eba11912814d6c7a1feac789e6c7fe0e6bc0a491280f85b1e603c0"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "qt"
  depends_on "unixodbc"

  conflicts_with "qt-libiodbc",
    because: "qt-unixodbc and qt-libiodbc install the same binaries"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=ON
      -DFEATURE_sql_psql=OFF
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
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
