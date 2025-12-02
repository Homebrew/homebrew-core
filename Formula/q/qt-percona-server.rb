class QtPerconaServer < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtbase-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtbase-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtbase-everywhere-src-6.9.3.tar.xz"
  sha256 "c5a1a2f660356ec081febfa782998ae5ddbc5925117e64f50e4be9cd45b8dc6e"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c61120bbce4d1c610981c891d46b533b91f9f42f25bfb713cffb38754e36f143"
    sha256 cellar: :any,                 arm64_sequoia: "e893f07fe1dd3f2629860adcb6c586c7c374eb5ee0a49cbcefa3e7611cd450dc"
    sha256 cellar: :any,                 arm64_sonoma:  "0f47f8f4315aab469775a83936d5b1ad402b504f01cd49acb3b1943352545601"
    sha256 cellar: :any,                 sonoma:        "4cee6a48c6d924b15692d2671a935092794f436a578ee0c3658115eb708ad9db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "958597e0a036bd75841a2d7ea4ae0c5c02338dcb83d255f65f4c2f845b20dcf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b75b67d199de55822c1cf2ec3c2302a6de15985a5b6f4c38c74bb90993c501d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build

  depends_on "percona-server"
  depends_on "qtbase"

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
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?
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
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Core Qt6::Sql)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += core sql
      QT      -= gui
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

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

    ENV["LC_ALL"] = "en_US.UTF-8"
    system "cmake", "-DCMAKE_BUILD_TYPE=Debug", testpath
    system "make"
    system "./test"

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    system "./test"
  end
end
