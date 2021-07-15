class QtMysql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.2/submodules/qtbase-everywhere-src-6.1.2.tar.xz"
  sha256 "b9c4061c1c7999c42c315fc5b0f4f654067b4186066dd729bbcf1bdce8d781c8"
  license all_of: ["LGPL-2.1-only", "LGPL-3.0-only"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "19e3a5c51acf56eacff24e47e48930197925953b85a6a158118c30320d8a13f0"
    sha256 cellar: :any, big_sur:       "ebf05abda54934cb916cbc9e1d4523e6e0ccc3578a8f43d1357d82d343728ae1"
    sha256 cellar: :any, catalina:      "c5f3fe7c67d1ff894d24079b0fa3317ca49cb815ce0e61401d28717a52245283"
    sha256 cellar: :any, mojave:        "77fc10ce69c10898fc00c892b7f05337c7a524f5283aed50e988bfd58b9944d5"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "mysql"
  depends_on "qt"

  conflicts_with "qt-mariadb", "qt-percona-server",
    because: "qt-mysql, qt-mariadb, and qt-percona install the same binaries"

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
