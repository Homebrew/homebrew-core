class QtPerconaServer < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.2/submodules/qtbase-everywhere-src-6.9.2.tar.xz"
  sha256 "44be9c9ecfe04129c4dea0a7e1b36ad476c9cc07c292016ac98e7b41514f2440"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "57169c034f535405cf2994a904b99de7d2a97e6d619673f69a3cffa401266205"
    sha256 cellar: :any,                 arm64_ventura: "1246fa7bc7abe4fb629688511f160e5e468be3a64acba8c7c22685d0e09de48d"
    sha256 cellar: :any,                 sonoma:        "ab24521e5d998db3051b1b85a7a475243529bdbb864eed117e037defc6fb2ab9"
    sha256 cellar: :any,                 ventura:       "0a31e90639ed06694b93cfd0d3f57c0707b85bf0d47d14cfc4926e698ebd11ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5db0479da513098bbd32290114121ed481b2f936ea0df6b31422e58c911f0b99"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build

  depends_on "percona-server"
  depends_on "qt"

  conflicts_with "qt-mysql", "qt-mariadb",
    because: "qt-mysql, qt-mariadb, and qt-percona-server install the same binaries"

  def install
    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=ON
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=OFF
      -DFEATURE_sql_sqlite=OFF
      -DMySQL_LIBRARY=#{Formula["percona-server"].opt_lib/shared_library("libperconaserverclient")}
      -DQT_GENERATE_SBOM=OFF
    ]
    # Workaround for missing libraries failure in CI dependent tests when `percona-server`
    # is unlinked due to conflict handling but not re-linked before linkage test
    args << "-DCMAKE_INSTALL_RPATH=#{Formula["percona-server"].opt_lib}" if OS.linux?

    system "cmake", "-S", "src/plugins/sqldrivers", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
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
    CMAKE

    (testpath/"test.pro").write <<~EOS
      QT       += core sql
      QT       -= gui
      TARGET = test
      CONFIG   += console
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
        assert(db.isValid());
        return 0;
      }
    CPP

    system "cmake", "-DCMAKE_BUILD_TYPE=Debug", testpath
    system "make"
    system "./test"

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    system "./test"
  end
end
