class QtPostgresql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.1/submodules/qtbase-everywhere-src-6.4.1.tar.xz"
  sha256 "532ad71cc0f9c8f7cb92766c47bc3d23263c60876becd9053802f9727af24fae"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "67a526ef3785bc7ce98323982d264e7dae51acd027aea63d18af83d3bf29fc91"
    sha256 cellar: :any,                 arm64_monterey: "4ce80725c9198afadf6e8bfa110a4cf56cac7ffdb43bf480bf4e10c0b3dd9bb1"
    sha256 cellar: :any,                 arm64_big_sur:  "56c5ee55a51da34d8fc48944e5883759100c35f1dcdc93e8ff57cde4cf65c544"
    sha256 cellar: :any,                 ventura:        "92954c3e66037536d6a2fe18eb5c686b6072f2328bf7a9a5b719e7e3cec03dd3"
    sha256 cellar: :any,                 monterey:       "d90c1bd27fff9bec49b7eba3aa4163e3fdd2a417af377cb4960f27d1e7649e54"
    sha256 cellar: :any,                 big_sur:        "e4138e9004a37dfb064ff50e048b6f5c239bdd492e725298ab0c63e56bbc4c00"
    sha256 cellar: :any,                 catalina:       "1438ec5cfff58c80361d6eb52707aa007fb59209fc105a2c4bf2f6a15ee888a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c3c9c06f4d07ae47778d629a35c7076377185dab862a7aae770b481eeb6db7b"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "libpq"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=ON
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
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
