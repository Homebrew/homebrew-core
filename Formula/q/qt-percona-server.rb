class QtPerconaServer < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.7/6.7.2/submodules/qtbase-everywhere-src-6.7.2.tar.xz"
  sha256 "c5f22a5e10fb162895ded7de0963328e7307611c688487b5d152c9ee64767599"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:  "f9b42c6f4de923d6b7c452dfa6454d3ff30219fdc4c99a9a3f17539add805fc1"
    sha256 cellar: :any,                 arm64_ventura: "cb4ec5ba83c47e9e5aa42db405fd3e6c9d3d6ddb7cc70822b1c354fa2b18a25e"
    sha256 cellar: :any,                 sonoma:        "a86a2fa03ffa2b31216c6d1977eb083c93c5216557f3e48d233b30bdbe4ec4cd"
    sha256 cellar: :any,                 ventura:       "407ed5bbddd3bdfe6f8b13b5902f8a49c3458d8fbe662e08979c8333928cd8d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85701a4da17e54dde8b2cd09d26e7e73edf4e3c4cbdbc9a5a02935e208cbbfd4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkg-config" => :build

  depends_on "percona-server"
  depends_on "qt"

  conflicts_with "qt-mysql", "qt-mariadb",
    because: "qt-mysql, qt-mariadb, and qt-percona-server install the same binaries"

  fails_with gcc: "5"

  def install
    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=ON
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=OFF
      -DFEATURE_sql_sqlite=OFF

      -DMySQL_LIBRARY=#{Formula["percona-server"].opt_lib/shared_library("libperconaserverclient")}
    ]
    # Workaround for missing libraries failure in CI dependent tests when `percona-server`
    # is unlinked due to conflict handling but not re-linked before linkage test
    args << "-DCMAKE_INSTALL_RPATH=#{Formula["percona-server"].opt_lib}" if OS.linux?

    system "cmake", "-S", "src/plugins/sqldrivers", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
