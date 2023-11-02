class QtUnixodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.0/submodules/qtbase-everywhere-src-6.6.0.tar.xz"
  sha256 "039d53312acb5897a9054bd38c9ccbdab72500b71fdccdb3f4f0844b0dd39e0e"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "055885ae44911e2c1ba530850940a4f40459aa549dccc289f4b90edb5ec670d5"
    sha256 cellar: :any,                 arm64_ventura:  "c2230401552fcc0da243fa036a5c6d80795a4e87f45cd6ec052decf2ee2973db"
    sha256 cellar: :any,                 arm64_monterey: "6f48ebb03fcde6064aa5d4a09d05eb9ca94ad51bbdf621f76b254a70c5b7d09b"
    sha256 cellar: :any,                 sonoma:         "938ba020a77541d5695fd2edb9c92812563cc3d833fdccfb27bda58f6aad0ef0"
    sha256 cellar: :any,                 ventura:        "ec32270b02ced8dda119d0f84a5c1dc6bd3d1ab94d2655ddde1e58c769c6c06f"
    sha256 cellar: :any,                 monterey:       "7640b0fdfdbdb484651e0dc3d06b61c3d8d58d991aaa90b1697d1eef25be2ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3444e36fb47a5ad1fb74a395f3afd60e5220282c70dac807969a30eb86d5df4"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "qt"
  depends_on "unixodbc"

  conflicts_with "qt-libiodbc",
    because: "qt-unixodbc and qt-libiodbc install the same binaries"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=ON
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
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
