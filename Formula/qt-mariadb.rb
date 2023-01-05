class QtMariadb < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.2/submodules/qtbase-everywhere-src-6.4.2.tar.xz"
  sha256 "a88bc6cedbb34878a49a622baa79cace78cfbad4f95fdbd3656ddb21c705525d"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b245ac49719c25ab6b53d3debc95162f43ca8f878333f7ebf5559147317dd45a"
    sha256 cellar: :any, arm64_monterey: "4fe49638189c8b381f9bd30fa16d1a09d1c6a38caa1b1f2bb5af0ca6bc614719"
    sha256 cellar: :any, arm64_big_sur:  "2c5cc9ea81aa5e236eff8482049846be0e188ee46d050cc912cf0e4d8512b33a"
    sha256 cellar: :any, ventura:        "a9f979fee5c2634babee5ffa63fd0910b0c05886d952c31d4b8e869359ca63a4"
    sha256 cellar: :any, monterey:       "19b33ff78c6d1926cf53e39e7754cc82a957202633b40388f98774fc222fb72f"
    sha256 cellar: :any, big_sur:        "073ede071aef586d87ed32f4004de458857e398d27025e97ad67f090cadceb76"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "mariadb"
  depends_on "qt"

  conflicts_with "qt-mysql", "qt-percona-server",
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QMARIADB");
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
