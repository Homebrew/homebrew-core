class QtUnixodbc < Formula
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
    sha256 cellar: :any,                 arm64_tahoe:   "2a8e099cf9a932334bf5b5debf95a1baf5935234d7fbb1c91e898efb7b6b012b"
    sha256 cellar: :any,                 arm64_sequoia: "f05326605e9e16e3ef85761c7acb5a59813bb9c6d9ede8240e5e99f6c70e4909"
    sha256 cellar: :any,                 arm64_sonoma:  "a671ec5715ebf08a9a4d7b307e4113ac5fda4cc65fd19307160e9662c3753b23"
    sha256 cellar: :any,                 sonoma:        "55f94195a4afdb901d80923ee1486352746e8de939ff34d9030bcf315185531a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9bbcca617af250a5600d6ce0a4b2bd2e13049f384f8d74a4d4f8cd4df1b8b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e64bb076ea532c757f680f8995e5d64c93d8115a24441fbdb7c907d8aa43eddc"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "qtbase"
  depends_on "unixodbc"

  conflicts_with "qt-libiodbc", because: "both install the same binaries"

  def install
    args = %w[
      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=ON
      -DFEATURE_sql_psql=OFF
      -DFEATURE_sql_sqlite=OFF
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
      CONFIG  += console debug
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
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
