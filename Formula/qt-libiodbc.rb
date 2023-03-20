class QtLibiodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.3/submodules/qtbase-everywhere-src-6.4.3.tar.xz"
  sha256 "5087c9e5b0165e7bc3c1a4ab176b35d0cd8f52636aea903fa377bdba00891a60"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41b4f791da3b70c832e060209b1cf3b008c7ef01a83c7aff34c793c1923e51fe"
    sha256 cellar: :any,                 arm64_monterey: "e0363515706fc735054a68e9da2d5bcba3d17a51e2f3b8bf18eb5c659fd33642"
    sha256 cellar: :any,                 arm64_big_sur:  "65e05e6a5260d13e91578344a68bf1f0a3a124ab3712c46538a79f5627504cbb"
    sha256 cellar: :any,                 ventura:        "5d1383e4dc6253d3606e2ab27acb77b2de9923d10b978dfe8da8f856bed909c6"
    sha256 cellar: :any,                 monterey:       "af39cb5e7530739f283d1ff0d1017e96b7b218ec135752f6ad13298a6ed0e8a1"
    sha256 cellar: :any,                 big_sur:        "60199b32b98ca54b8160468b6a3dace54dacd4956b4b95215c9638c6ba91cb70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d27b1fa91b2b2161ac3ae04f125f68a81a01906eb369b9c281a8c4b7808a1bd5"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "libiodbc"
  depends_on "qt"

  conflicts_with "qt-unixodbc",
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
