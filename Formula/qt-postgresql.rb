class QtPostgresql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.3/submodules/qtbase-everywhere-src-6.4.3.tar.xz"
  sha256 "5087c9e5b0165e7bc3c1a4ab176b35d0cd8f52636aea903fa377bdba00891a60"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ac25f1048578f0a0f35e09ed436a54c7821d91c32ae4c5cae67d8f72f34c84d6"
    sha256 cellar: :any,                 arm64_monterey: "0bf4f5beebdac32509dcaca82cf0f40d96bfeb56bd7cdc137a949afeb759233d"
    sha256 cellar: :any,                 arm64_big_sur:  "fb6e50cc718a530cb41a989b5e39686880977c9740b9323e6963fed0699498a0"
    sha256 cellar: :any,                 ventura:        "fcebbebb51ea152ef3c16df39a25e5dbb7f539693a776032854c39c6a3529a74"
    sha256 cellar: :any,                 monterey:       "2f459c1b5b490bc374d93e8437cb85238db508d9fb0477ed40a8ea16fe89a5bb"
    sha256 cellar: :any,                 big_sur:        "b81fc0d86fa2159ee8fa61d4a675f7f37b1772ebbfdf948efd9b0b3a38c2c967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93837bd93b0620c55f603ee75edc0bdeea4a65bb8ebb39cd6e54f0a27aa714b"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "libpq"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=ON
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
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
