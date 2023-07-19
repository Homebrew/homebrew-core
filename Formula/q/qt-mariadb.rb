class QtMariadb < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.2/submodules/qtbase-everywhere-src-6.5.2.tar.xz"
  sha256 "3db4c729b4d80a9d8fda8dd77128406353baff4755ca619177eda4cddae71269"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "044e7d3a532722aa2191b1f4633239608db90ab2c87244701d285e9bd8a39aca"
    sha256 cellar: :any,                 arm64_ventura:  "0afb4d84269cbfc9935f627c836ffca986beed1a27692ea54ed73b0bb35a2c38"
    sha256 cellar: :any,                 arm64_monterey: "93290c7540f30cf95194a35a5d5af5ad0579dd225fc14dd3030dc7f0ea8e61ca"
    sha256 cellar: :any,                 arm64_big_sur:  "bedc5ada13d9417615056766bb610a071b36fa77e4a65c96097351b769a1a19c"
    sha256 cellar: :any,                 sonoma:         "6f41d75751d681bafaac6ab8831a60ca93bf4dc378a324d809b4e42682c0c663"
    sha256 cellar: :any,                 ventura:        "2ffc59d23e73c2e490a717ce08d05b5cb3304b281f09c687caa99add89541bb7"
    sha256 cellar: :any,                 monterey:       "bd83fe0198c4744f34bd405a004c8c2f40f1205b93895626da614f798c1abb19"
    sha256 cellar: :any,                 big_sur:        "9129dce0ee9c1f5f80631217f22edbf19887ab424964aca0683cbac5ca373411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ff4239e1ab64da29d4c532c6d90b28f7f25133dcd6a4ad92846c5bfd8b07f9b"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "mariadb"
  depends_on "qt"

  conflicts_with "qt-mysql", "qt-percona-server",
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QMARIADB");
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
