class QtLibiodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.2/submodules/qtbase-everywhere-src-6.5.2.tar.xz"
  sha256 "3db4c729b4d80a9d8fda8dd77128406353baff4755ca619177eda4cddae71269"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e72b42788f0af98b71114e977bf4da59f7f15b950e40d1acf1f65dacf756b0fd"
    sha256 cellar: :any,                 arm64_ventura:  "f62327a22bafa282609f72ec2f815b44a58a7db77043dacc405a6a679e51d2ce"
    sha256 cellar: :any,                 arm64_monterey: "247fc0c70555369e01305228d3df61dd3e27e346c32c2134925940f9063c2328"
    sha256 cellar: :any,                 arm64_big_sur:  "ca01eba10d31aee5604f53703aeabbacae9b8239589e7f2ccd4bce1ea9b709a0"
    sha256 cellar: :any,                 sonoma:         "09e1f54b07ec44b4ba8d3c0d5b8aa40c0325e62a02e743a7e3f64efb0d86ceb0"
    sha256 cellar: :any,                 ventura:        "3f625e01b17b31ea7d2f7b0923375cd6cf29373ceed0c6a85ff0f9498be9e1b3"
    sha256 cellar: :any,                 monterey:       "82625921539ee09bb118394dd24fc6217fc736fd06142149859477d51de71104"
    sha256 cellar: :any,                 big_sur:        "940dce88335e2bc3871388a846a3ea8eaff9a4804d024d84b4e373d921c8436f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f31536b0ee21ccee9035a4b12c6f481861f795114da9a93c4fec7715fa867dc9"
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
