class QtMysql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.7/6.7.0/submodules/qtbase-everywhere-src-6.7.0.tar.xz"
  sha256 "11b2e29e2e52fb0e3b453ea13bbe51a10fdff36e1c192d8868c5a40233b8b254"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0946c75dcdb6aebaedb6fa7d0cf11f7c3dd50d2342986931575343fc492d1c0c"
    sha256 cellar: :any,                 arm64_ventura:  "70f6f7a536783575e73c318388e0cad7c4c0a3cbaf223f9caae3711c682d356d"
    sha256 cellar: :any,                 arm64_monterey: "ceb74b27837a961f2fb6b2850cd25f4d663e7ca125fccc8b5f20e244f561b088"
    sha256 cellar: :any,                 sonoma:         "fe1def6055f949b7b0e63b548cc8f188f1f43758b9395517c829f5e89c7ee9ec"
    sha256 cellar: :any,                 ventura:        "08ded99ead3e3ea843c58426f5b766a7aa2d1fda59614c61f692581bb35d1870"
    sha256 cellar: :any,                 monterey:       "87c5b4339aed038b58679d81be8de7dc5306959d5c635b578b7e588e7dd00461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8d73010ffe1be2420fdabfd3290d25175c5cf2a10a2e61d9bbb38daa9936396"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "mysql"
  depends_on "qt"

  conflicts_with "qt-mariadb", "qt-percona-server",
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
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
