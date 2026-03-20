class QtPostgresql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtbase-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtbase-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtbase-everywhere-src-6.10.2.tar.xz"
  sha256 "aeb78d29291a2b5fd53cb55950f8f5065b4978c25fb1d77f627d695ab9adf21e"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "397ee750019d64de8ca91856298505e2f6dde0b143ebea6bef615fccc8e62f68"
    sha256 cellar: :any,                 arm64_sequoia: "9614ccbf5c95ed42d7d09d695d499462d664aee3c87908345990c28566d9eb2f"
    sha256 cellar: :any,                 arm64_sonoma:  "c5f13c142d4d1beddd19a6a300ffa1fc9b6bc75ff19a452d030eeb3eb0cb6342"
    sha256 cellar: :any,                 sonoma:        "3bf4d676b3e0162d277980e8da64dd98840f7030478fb05dd33d29f691f4cb82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87f20d59d0a3320ac84c1cc8173410d3fd5fa69f2f403d02fa61cbb50889d1f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "452d30780d933500f3be2ef68dce1fcb8fae1e02a67e418c30a28ad9b67abd1f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "libpq"
  depends_on "qtbase"

  def install
    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=ON
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
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
