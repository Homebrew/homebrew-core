class QtMariadb < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.7/6.7.3/submodules/qtbase-everywhere-src-6.7.3.tar.xz"
  sha256 "8ccbb9ab055205ac76632c9eeddd1ed6fc66936fc56afc2ed0fd5d9e23da3097"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "36df0a8bb8e0085f4dd4c3431ecc198edcb0e3a579160e565cdda35cbfec6cf1"
    sha256 cellar: :any,                 arm64_ventura: "82acaa2afe947a56264be5673dc7dedbff76cc6cd2cce32241794920296d5f49"
    sha256 cellar: :any,                 sonoma:        "f66b1041ae0f2861b81d6e728b893517c7a6246aa0c1f46742a97f27734f8db3"
    sha256 cellar: :any,                 ventura:       "e5e0fd4650fd6dc4936ec257dbbc9275a8d0d603bef546c1020c9b21edb2e3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe26e8dedfa68195ae611d654ec004731e975e6c1ae99b6655c9ce88f840bd48"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "mariadb"
  depends_on "qt"

  conflicts_with "qt-mysql", "qt-percona-server",
    because: "qt-mysql, qt-mariadb, and qt-percona-server install the same binaries"

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
