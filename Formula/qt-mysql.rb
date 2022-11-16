class QtMysql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.1/submodules/qtbase-everywhere-src-6.4.1.tar.xz"
  sha256 "532ad71cc0f9c8f7cb92766c47bc3d23263c60876becd9053802f9727af24fae"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "079661fd6d4a2e8790adf0987db4e8af69ae476a827546fd7646c21f4763129e"
    sha256 cellar: :any,                 arm64_monterey: "ed655e593a0f04f1f2ef4a6e69c9850b5e8230e491f487fe9daa0949832603f2"
    sha256 cellar: :any,                 arm64_big_sur:  "09296c51249c4bbcd2e8287d6804397924bd4267c1e367f3d64402ef88cf1d84"
    sha256 cellar: :any,                 ventura:        "5360a1edf5fcbc9609c0ff6e17dba97ad53698c0ec2327bf4c8c70654f253342"
    sha256 cellar: :any,                 monterey:       "e94c38f53df5002b3e07ab4f6721bacb2a1cca934340c25fcf317a3b0a42acef"
    sha256 cellar: :any,                 big_sur:        "8281d5cab2a3b8ae8f61e1c70dd6df12c44c1df325b9a68af7e80abb1fa942ca"
    sha256 cellar: :any,                 catalina:       "bc724307260c2f2a4d08342a2f504c86ee60acf8a15289b178b4f57409bc7b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae67e4feef6ec568db061d4c0691f3e9a878ff68b94c6aabc80060515aab8c90"
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
