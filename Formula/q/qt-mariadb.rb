class QtMariadb < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.2/submodules/qtbase-everywhere-src-6.6.2.tar.xz"
  sha256 "b89b426b9852a17d3e96230ab0871346574d635c7914480a2a27f98ff942677b"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0566d2ff205ccc1a20d54a2d1c593578436699c077f4ffe70c2facf1ce960ee"
    sha256 cellar: :any,                 arm64_ventura:  "ad0be676f53792aca78fe7179074d0028ffab6ce1dd2899d79e009b0341b32c8"
    sha256 cellar: :any,                 arm64_monterey: "9fd5e9d3eb20644657b8b2026f5e55d0315f6c5729b15fa88d2765196cfce1ac"
    sha256 cellar: :any,                 sonoma:         "7887f00327be04883ff8ae84849cb57968cef118f00932cc949a7b5cf6200bc9"
    sha256 cellar: :any,                 ventura:        "0a29a097f0c0e99a50e0fb6a902fff29b3fa639a02a633420ce416ef7601a038"
    sha256 cellar: :any,                 monterey:       "2215b4837c9124d11f02a2f95fd683ef2f8dd06e3fc0c3a50d943b535f2d066a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6359dbeaf65279aebcd903bc3d49eb3d26389306ca31b34c1c07860d84211ad6"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "mariadb"
  depends_on "qt"

  conflicts_with "qt-mysql", "qt-percona-server",
    because: "qt-mysql, qt-mariadb, and qt-percona-server install the same binaries"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_sql_ibase=OFF
      -DFEATURE_sql_mysql=ON
      -DFEATURE_sql_oci=OFF
      -DFEATURE_sql_odbc=OFF
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
        QSqlDatabase db = QSqlDatabase::addDatabase("QMARIADB");
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
