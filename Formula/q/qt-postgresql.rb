class QtPostgresql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.2/submodules/qtbase-everywhere-src-6.9.2.tar.xz"
  sha256 "44be9c9ecfe04129c4dea0a7e1b36ad476c9cc07c292016ac98e7b41514f2440"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "de0887723a3ee50956778a09d1aebe7187bde26213616846a96e70ef9ac7e244"
    sha256 cellar: :any,                 arm64_ventura: "4f50eeebe63d8a224f938ba632a3daf842ccaf145875bf1d01d8f87132961321"
    sha256 cellar: :any,                 sonoma:        "2b61609aee8466582bab683999350d91409259a34024351170a1f8bc91c70a18"
    sha256 cellar: :any,                 ventura:       "2d8362b6ea827ed7c3768fd5ce6c44e5ed40180ae844384dcc39c848711b4fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e8e1e8eab4f5f3e211ca89bc4cd57676f7bb6174f05a70ef365428a9549aedd"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "libpq"
  depends_on "qt"

  def install
    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=ON
      -DFEATURE_sql_sqlite=OFF
      -DQT_GENERATE_SBOM=OFF
    ]

    system "cmake", "-S", "src/plugins/sqldrivers", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
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
    CMAKE

    (testpath/"test.pro").write <<~EOS
      QT       += core sql
      QT       -= gui
      TARGET = test
      CONFIG   += console debug
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~CPP
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
    CPP

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Debug"
    system "cmake", "--build", "build"
    system "./build/test"

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    system "./test"
  end
end
