class QtUnixodbc < Formula
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
    sha256 cellar: :any,                 arm64_tahoe:   "759c552b47b2079674aa8e32dfe68fe07d105617836d0d592ea2c739d1214a5a"
    sha256 cellar: :any,                 arm64_sequoia: "28723ba39c3a5f96660da5b402a1e963cd5415973f37c21e1d64c4ed93a9676e"
    sha256 cellar: :any,                 arm64_sonoma:  "73d6f8b034d1782597c3f59f67aa431c1d66738b2f53113630ad7780fc026ca4"
    sha256 cellar: :any,                 sonoma:        "544c549fcb7475de2c28c0c9d753b99cc3293f0459ce1d94af1ebb2091d35d29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36153e0040372b78e175dc304af0cc100431d868e6f436e5bbb8065421533fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c45588734da878f2733abf7b7e1c3b6644cc7b1baf99eba9317c56ddd97d358"
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
