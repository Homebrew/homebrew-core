class QtMysql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.2/submodules/qtbase-everywhere-src-6.5.2.tar.xz"
  sha256 "3db4c729b4d80a9d8fda8dd77128406353baff4755ca619177eda4cddae71269"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f1aa250d76991df324ecff7b26915fcb108d9752e12da33d66ce70269aa84296"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bfc728209369a52f821cd0fa3a5148f8d52cfe3107383eeac28617fb0fd687e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1bf71b43b404d012bcbb62949657acfb21524983edf36965f94fef34a15a326"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20d8e8a698289dd1b715fae366fc4e8b7cad5debbaf83d756f8e2c7cb24dd13c"
    sha256 cellar: :any,                 sonoma:         "498ef32620727631452dd31248da18db2e505359201d3ad01a5fee678b6345d8"
    sha256 cellar: :any_skip_relocation, ventura:        "c0ef0588a2b6195d1c55215f0dad2c495245ee59dde5f59d4efca9c88f4ad961"
    sha256 cellar: :any_skip_relocation, monterey:       "6883b13f11a91ff7048ff6a237d4b8820788ebef95a6831fdd99937069413ce9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0979f7ffccab1379db612b87abcde50753837fe98c86ed6636f6d4459c41a653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c338506a9c2845d4a52fa1a8b1a0076fb6c44bded46a83be696f06fc950daed2"
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
