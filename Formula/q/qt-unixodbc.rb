class QtUnixodbc < Formula
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
    sha256 cellar: :any,                 arm64_tahoe:   "226b26cda71840f4a5651cfdc70eb54ce23e5b3e6f6845feb3ee678136e8f5f8"
    sha256 cellar: :any,                 arm64_sequoia: "ea7c7e7fcb5782d48e4bd51ee66be3d3b09a8decdd0e020378a81d011e0d2dba"
    sha256 cellar: :any,                 arm64_sonoma:  "1307719dd6b045def85dee65a7df37d1cc045bd678aa75be8014cc189a0be66d"
    sha256 cellar: :any,                 sonoma:        "e7e83bfd316f2c7aa989d91a33b8f8092253cbd7ec1f930c6321c333606ee219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efd1e697f79acbfc8c18165b5258a02b06afaa0889d7e68030e3b4184e9dba2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06086701a96eff0c9a997be8b64d1119b21d8bd93ad987ceacf4dde3ca3eac81"
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
