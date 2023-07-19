class QtPostgresql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.2/submodules/qtbase-everywhere-src-6.5.2.tar.xz"
  sha256 "3db4c729b4d80a9d8fda8dd77128406353baff4755ca619177eda4cddae71269"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be6ef087ba33f375dfb5b94df0f254c4acec0dcb23532456e5a53c69e96e85f9"
    sha256 cellar: :any,                 arm64_ventura:  "fc01b20e5779e739d2973013cadbbe6cd44dfad15d420792ddc846a732938131"
    sha256 cellar: :any,                 arm64_monterey: "75d449518836e9bd760544462114b7bf3f4d437ff19cbece5b7d044c07d80dda"
    sha256 cellar: :any,                 arm64_big_sur:  "bdd662f2703c847ad57c9a862c952fa2d1d32911af2f7488118c0850254de0ae"
    sha256 cellar: :any,                 sonoma:         "3e43b711227214d30020125ce10f6f9bb7389c09aad5db34c06548ccb2b644ec"
    sha256 cellar: :any,                 ventura:        "8beec9b0643db83e743d5d4c88876429616604ea44217d1a4e8a31a35e05d112"
    sha256 cellar: :any,                 monterey:       "88e5a949cc4bc54b417fa6cef723d667c351c1caad2552d8d645349d89036179"
    sha256 cellar: :any,                 big_sur:        "0187a1a2d55da8c98f38c631a5f450f863f9285eaead1f65a0bd4c0acb9e7f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a407d35e19b8e97cb2fbf9bcc511a5af700ed63c925ab6b3788383652bf70c59"
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
