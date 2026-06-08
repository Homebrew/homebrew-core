class QtPerconaServer < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtbase-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtbase-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtbase-everywhere-src-6.11.1.tar.xz"
  sha256 "d9594a31228aa23ad6b531719a29b45f0f3989fe6c136d45767ea179f233c1ac"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2134921332088c304f2b5f8be54fce88e0f12d10ec0dc50d0941a78a72f98a37"
    sha256 cellar: :any,                 arm64_sequoia: "4c47a64b83bc00a78f6e93ed26c5bced9fc8fc01c8a92c0631c5825e41b8d821"
    sha256 cellar: :any,                 arm64_sonoma:  "b1dc09e701afe70d9d1805d052050325128bad45a69f264c5d74bc8f58856577"
    sha256 cellar: :any,                 sonoma:        "e30788384b57ae630bd8ded2ff6a8dc3c959efb4aea7c16ab29307f5321e140e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c115a2acb9a9981434d7db0403482c03855a6be391894ec0f8069d8ab986aae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ab5a284306c416a7bd006fd5257989412c4be8760a9adc02e9b61e6c0422fcd"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "percona-server"
  depends_on "qtbase"

  conflicts_with "qt-mysql", "qt-mariadb", because: "both install the same binaries"

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

    system "cmake", "-S", "src/plugins/sqldrivers", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 COMPONENTS Core Sql REQUIRED)
      qt_standard_project_setup()
      qt_add_executable(test main.cpp)
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
        QCoreApplication a(argc, argv);
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
        assert(db.isValid());
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test"

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    system "./test"
  end
end
