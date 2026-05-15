class QtLibiodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtbase-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtbase-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtbase-everywhere-src-6.11.0.tar.xz"
  sha256 "231ad85979864d914dc9568a1b71c91d6cf20d7b2021d059103bf0eb51cb755e"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "efd29bcdc8425dc15657f0b4aee4a47784a07f6d9dc800ecd5c8fb70f0a84f43"
    sha256 cellar: :any,                 arm64_sequoia: "d83a8ab93b3a1cce9081cdbbecd3062a2639255318cdc91fce35322b9a81e999"
    sha256 cellar: :any,                 arm64_sonoma:  "01d6f9bfbe06a399d189ee9a0e4f9c389dd929028d36427498cd16ea20cb50a6"
    sha256 cellar: :any,                 sonoma:        "03374a8927a1120d00b3b7624906470c0f18438bdd966bb040bb3eca50ac4821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b702ccd0a283b4d34b645fac70bd532db1fdc059d7f5d3d9a52de2554a08346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f50a480f110542fabddb90d97e0c15b85cd08544ef462aa67fbbba52330c3834"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "libiodbc"
  depends_on "qtbase"

  conflicts_with "qt-unixodbc", because: "both install the same binaries"

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
