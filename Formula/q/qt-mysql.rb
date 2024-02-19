class QtMysql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.1/submodules/qtbase-everywhere-src-6.6.1.tar.xz"
  sha256 "450c5b4677b2fe40ed07954d7f0f40690068e80a94c9df86c2c905ccd59d02f7"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]
  revision 1

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2ab5cdc7439230e57d5cf24a709ad1b40f3adafe5ca13ac9e9149c5314a61e52"
    sha256 cellar: :any,                 arm64_ventura:  "85f15b15c5bae2a0fe8a40312b6b7ce9b1aca888433abc47ba20dece367f0f1d"
    sha256 cellar: :any,                 arm64_monterey: "282caa16ecff63f3d99a5e10a413251edbf231b0555053ae11adfe91ad27b338"
    sha256 cellar: :any,                 sonoma:         "839dd139d1d0449ebafbb11afcc16ab1de62cf2f2434dc1ec4ca38ac309781fc"
    sha256 cellar: :any,                 ventura:        "5d91adaba125776db9cdda7240846eeb4915c7bfac02225e53dc2d51d9e34991"
    sha256 cellar: :any,                 monterey:       "ca4dc7bc03ec7f0bfdcf28349a45ec19e04e2f26a7f70cc0df27d351684ba26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d45c609c512284f21b4d7d0eb92ec33744dc85fd87edc8e63b7730a767b2e50"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "mysql"
  depends_on "qt"

  conflicts_with "qt-mariadb", "qt-percona-server",
    because: "qt-mysql, qt-mariadb, and qt-percona-server install the same binaries"

  fails_with gcc: "5"

  # Fix for breaking API changes in MySQL 8.3.0
  # https://codereview.qt-project.org/c/qt/qtbase/+/532555
  patch do
    url "https://github.com/qt/qtbase/commit/41c842d3f7eecdf736d26026427033791586c83a.patch?full_index=1"
    sha256 "f89d7c40ec29f992edcd5332c9512d5573d8047cb907eb8e36aaee15ba33a547"
  end

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
