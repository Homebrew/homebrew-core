class QtLibiodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.0/submodules/qtbase-everywhere-src-6.4.0.tar.xz"
  sha256 "cb6475a0bd8567c49f7ffbb072a05516ee6671171bed55db75b22b94ead9b37d"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01ce6ea26e506cee368dbe47141e9877d0ad0a93073a1f7ca388a326e91d2dbe"
    sha256 cellar: :any,                 arm64_monterey: "202d487ce7bde85a93569e10ecc4cc50ba15c4a931390a1130dcc5b3a4ce7a0b"
    sha256 cellar: :any,                 arm64_big_sur:  "539980e282206c0349a288c0846491551ce8c68e3b71cc081fdc0e8d17e410f0"
    sha256 cellar: :any,                 ventura:        "fb11e9e94f4d8e92251696df1ef0f59adfe6b1fbccb19b8067f503dbcab36ee1"
    sha256 cellar: :any,                 monterey:       "50668c37867fe4765ffc9a00aff284b87c47339d943ea626dc85a2689b963dae"
    sha256 cellar: :any,                 big_sur:        "5a0c19639d2031eef6e28b3fdb1f31dc0cbf2ab4b581d5845557eb720512f141"
    sha256 cellar: :any,                 catalina:       "e41c49377146ea606a8e87f3ffb2d17bb3370a2fc9141fac5117b42e973ddc50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f222a37f384eadc0c3647e3bee301a9725f5d68e9f39282c12baa6406d491221"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "libiodbc"
  depends_on "qt"

  conflicts_with "qt-unixodbc",
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
