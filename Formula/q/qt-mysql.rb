class QtMysql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.2/submodules/qtbase-everywhere-src-6.6.2.tar.xz"
  sha256 "b89b426b9852a17d3e96230ab0871346574d635c7914480a2a27f98ff942677b"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "deb0ea655f5e08cdf2162bd72717fac15edc896f8c465616eee20c5753f7464f"
    sha256 cellar: :any,                 arm64_ventura:  "f63e294f7ccbc4c9618f622bb567cd910c71fc50f67940b89bf11051d9264086"
    sha256 cellar: :any,                 arm64_monterey: "477444148973d566593a9d09d1b8353228928253e8a52f18d2ab9db00adfae64"
    sha256 cellar: :any,                 sonoma:         "03a419deafdee9d68e6585fe70bb214614c6ef03288b16781e3f65b06d522b14"
    sha256 cellar: :any,                 ventura:        "082ad2fd464bb41ae1b1b8c43fc423f12818e3ba9a3467ff1068d8b8a1377686"
    sha256 cellar: :any,                 monterey:       "d6bae37b7dcc11137b09c892f60e4c61d4946095e38aa04d1515d9c824990850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "946fa02fb86220fe44d6dec10bf08214cb2f761270fcde525390e0abe0561493"
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
