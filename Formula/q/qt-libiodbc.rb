class QtLibiodbc < Formula
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7000bf1c5b597c4ba88516da4a8bb95b54496664bc4865d8f5119c1e48aef94a"
    sha256 cellar: :any,                 arm64_sequoia: "32a1400ba0ff1eba75ab219bd0459106244e64f21d73c520d37eef1de74ff76a"
    sha256 cellar: :any,                 arm64_sonoma:  "92890cf3ad3f5e9a5ae1a8a18e3296334b3cbf41b5962f816c445ebae4a36e9c"
    sha256 cellar: :any,                 sonoma:        "39e77d7fbc9acc578b8d6d2aa572be72636dc56ea88d586ed335742177540690"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f73161faaa1861c99a2763be3e62a88a52cb97cb369840e204f14c6d88f809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3765b3766d3e70861435a3a09cf7265a46a615c7045910c42ed286c9efe31b9e"
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
