class QtPerconaServer < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.2/submodules/qtbase-everywhere-src-6.6.2.tar.xz"
  sha256 "b89b426b9852a17d3e96230ab0871346574d635c7914480a2a27f98ff942677b"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "af280c8bd28058555ab2eb6ffe141ecfb3f71db67b5d722e8ff2ffafbf43b2ba"
    sha256 cellar: :any,                 arm64_ventura:  "a254e320a7e163fcbf93bc9d70b5f23a81f0fbbb9d990d5fd10cc95b9a3f33c7"
    sha256 cellar: :any,                 arm64_monterey: "4f306cbc2aba63f7488d0fe4b569fe0de4ca4786e1e28371b5091f71fed3c27f"
    sha256 cellar: :any,                 sonoma:         "953b670cab7cb835b2bb3c64336828379106eb67c3f4853215ce544cc0d5d3f3"
    sha256 cellar: :any,                 ventura:        "ce0f09a7a772698a402a4bba867046199309745c19cd8bca6cf87378d670dbe3"
    sha256 cellar: :any,                 monterey:       "65a09387b83d76f4912ea8b2111af1c618f38ceb26451e674734d93325ed912a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f714e8b94d10cdc18d00cb341cbd5580f333c3709cdd40c7ffff7440c80054d"
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
