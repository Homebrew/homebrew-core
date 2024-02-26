class QtPostgresql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.2/submodules/qtbase-everywhere-src-6.6.2.tar.xz"
  sha256 "b89b426b9852a17d3e96230ab0871346574d635c7914480a2a27f98ff942677b"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a5d509dba86bce0502ff5b24b90c98312a6a53359a65da3428750e1fea81a8c"
    sha256 cellar: :any,                 arm64_ventura:  "5c0a2c1fd63ba5472af590354c63e70406c5c8c96c0c853f279398abb85c6edb"
    sha256 cellar: :any,                 arm64_monterey: "17fa91c677560666fe070c30cd856ab098cfa5ff25bf254fbec33bf36109a2ed"
    sha256 cellar: :any,                 sonoma:         "4bea45a84259788513ab268e2764963dc1b97127dc750a3954f1e03e81d116b2"
    sha256 cellar: :any,                 ventura:        "1a25964b19a5ac4939e45521f30885ef6a9d3dbee958388533f7f3c81bf61ada"
    sha256 cellar: :any,                 monterey:       "15f11cff8bf5414df7ebaddb4b122b553f2687eea708e36a125d3a69c56b5e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce339cdd39d801fdc5fb8d89f14d08a2a4acdb58f68ab5b3548bc0743fb1c2b"
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
