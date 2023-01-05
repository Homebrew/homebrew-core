class QtLibiodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.2/submodules/qtbase-everywhere-src-6.4.2.tar.xz"
  sha256 "a88bc6cedbb34878a49a622baa79cace78cfbad4f95fdbd3656ddb21c705525d"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "61f06b95954426627fad90df748d351bb22579396cdd20e9eab616900efbd80a"
    sha256 cellar: :any, arm64_monterey: "525a8d1cdb287e4a0b6468fcd9126e39ed17b1dbd3353e0e75cabdc087b77ce3"
    sha256 cellar: :any, arm64_big_sur:  "c97a8ab821a75e9e1501131b8afae2626e722d36120040cbabe407705cbdc25f"
    sha256 cellar: :any, ventura:        "a790ffd049b983197a497eb21c0fd7d864804419d947177213f3ba81e553aac7"
    sha256 cellar: :any, monterey:       "1b1bef20d3d103af9888fdef27226de65cbca3ee89afade39f1cdadd79ed1ead"
    sha256 cellar: :any, big_sur:        "6f746e8eb0019e1df218e0df587ec211b6bec0f10548be3421e6ef454a0dbe85"
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
