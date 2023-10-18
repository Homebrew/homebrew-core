class QtPerconaServer < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.2/submodules/qtbase-everywhere-src-6.5.2.tar.xz"
  sha256 "3db4c729b4d80a9d8fda8dd77128406353baff4755ca619177eda4cddae71269"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f5bc1eb8465ece60fd6c38f492c5b789a711762d939960dde1b80fa6d6da0271"
    sha256 cellar: :any,                 arm64_ventura:  "0f95535214cf7895197156a53197b6e3ce925632271e4c279167034373e93dd1"
    sha256 cellar: :any,                 arm64_monterey: "f1cf38f9a1e56f9f96d6063f0bc79ed2ff594fcd4622bb7bef132a17e512c07f"
    sha256 cellar: :any,                 sonoma:         "eab68cc0bef697dbe414f4b9b8c82d87a259632127a03eee5944e9619ba4a09b"
    sha256 cellar: :any,                 ventura:        "551a76e739b81b4f96900cf17921804c9c00f17d12ed4f95278deeb8b0c9490a"
    sha256 cellar: :any,                 monterey:       "3a1c163fcc7d86044743b85c3c296cb33c02ec48f4693f058d0fe79f66993701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "913b91c4e157d3e4b4bff4e01969d60f622b5ac9905316e960650d348b825dbf"
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
