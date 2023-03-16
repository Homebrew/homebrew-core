class QtMysql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.3/submodules/qtbase-everywhere-src-6.4.3.tar.xz"
  sha256 "5087c9e5b0165e7bc3c1a4ab176b35d0cd8f52636aea903fa377bdba00891a60"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c7edfa7bf8ea15a4bc228505884d1dfd86841008a70157dd2d2cfcbbd13bd81"
    sha256 cellar: :any,                 arm64_monterey: "b57f0f329f74653b97928773111e51c44098cda476e4d7b5517f3e6908c20b6c"
    sha256 cellar: :any,                 arm64_big_sur:  "073160fb1b5c1d2dc4f69c8b9df67f77a32fcc8f79d8bba316ad5f4390fc6293"
    sha256 cellar: :any,                 ventura:        "adfbcff2965e5f5a1b87c2c897d7844eab92bcaf5e1d8fdc5e6cfad7234e494e"
    sha256 cellar: :any,                 monterey:       "9e5d8ce5e7f551929a7a9efe8a7a540b27f1799477f5d4f396fc036647dfc3bc"
    sha256 cellar: :any,                 big_sur:        "8d01e2ac8836ec102198c2d6e7a0c2ff928e34632de040553ef9f92131eb08e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38c18df46c01933d838cb3e4ab9fa671faf3a6dd0f838668ca3bef37cd03780d"
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
