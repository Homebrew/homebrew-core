class QtPerconaServer < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.1/submodules/qtbase-everywhere-src-6.4.1.tar.xz"
  sha256 "532ad71cc0f9c8f7cb92766c47bc3d23263c60876becd9053802f9727af24fae"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d26b19ce0e56025614756059ca5e3634abea24bda45fb05cfc2f21af8f32cb74"
    sha256 cellar: :any,                 arm64_monterey: "55a08cd9f922d24188c53b08710baf0f33640d5cf545989934483dbab921273b"
    sha256 cellar: :any,                 arm64_big_sur:  "8d87edd78907aa3d8d4c690ce1a082c1d3a3974e184f0609a2e0f66e5105f273"
    sha256 cellar: :any,                 ventura:        "0e45102d604a21e17d3eaceb6cf528356966233824e366888ffb7412923fd8f5"
    sha256 cellar: :any,                 monterey:       "a1f5ec2ea5f599f1e209e73f2c33af9d381f75fd4a76b93dc0dd8d27e506140c"
    sha256 cellar: :any,                 big_sur:        "9f8f706003e14b7dc487a9083a068312147f939540d28fee3ae13263e3a3a2c4"
    sha256 cellar: :any,                 catalina:       "7f0dbfb006a4b170e6f7aa5741b50c0527cffb9792f3e316a1c2c639c4b68f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "600650429f78d07e9b97cc43321145301a96c7324f067647a106a6f12a25dfad"
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
