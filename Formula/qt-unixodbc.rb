class QtUnixodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.2/submodules/qtbase-everywhere-src-6.3.2.tar.xz"
  sha256 "7929ba4df870b6b30870bc0aed2525cfc606ed7091107b23cf7ed7e434caa9a6"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "052abe291c9ed26bb880a807a8cb40ceb88c5817b950b166ae33f9af1cfaf115"
    sha256 cellar: :any, arm64_big_sur:  "698e13373aa5ac0cf9a48dec699250d941e659656e3411bb28f045563ce1f8d2"
    sha256 cellar: :any, monterey:       "3a3d9e826e303fd3df5554a8a3ee91a1cfe15baf9fdb65cd269fc2871efb62aa"
    sha256 cellar: :any, big_sur:        "e67c8301c84dd5fc5ea6e5f30c39309602f16769ea90168d2cc0ec8470f7226d"
    sha256 cellar: :any, catalina:       "7f07b23ebda0f96ea76cc33dcff00cb2a78bf59e7af5838e9425de1c88b878ff"
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
