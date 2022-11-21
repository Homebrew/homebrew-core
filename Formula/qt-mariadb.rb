class QtMariadb < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.0/submodules/qtbase-everywhere-src-6.4.0.tar.xz"
  sha256 "cb6475a0bd8567c49f7ffbb072a05516ee6671171bed55db75b22b94ead9b37d"
  license all_of: ["LGPL-2.1-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da666b63bf4f31dd38b0b2e1fc1e0c88227eea73337c11fa87a2cf88d039ded6"
    sha256 cellar: :any,                 arm64_monterey: "6a0e03af5e444950d373b096968d243fdbfa8125746216c01f3b1c854128654a"
    sha256 cellar: :any,                 arm64_big_sur:  "4838fba0827ff853bf969a7dc9e4701ceb4579fa545855a098d38b1eb298e9cd"
    sha256 cellar: :any,                 ventura:        "75b152ba9e0455200a3e01a315301ab355cdc89f5b3d872b7ef899eafe5ef7c6"
    sha256 cellar: :any,                 monterey:       "d271bb4dcd43cf63d0971776773309b0f88d69a4d7a1609dc9c6f5ab4baa0349"
    sha256 cellar: :any,                 big_sur:        "22fbe6fab629d559336816dc27ef9e5266d21c19547c1a79989d2568a560ed34"
    sha256 cellar: :any,                 catalina:       "a429e2533b6d310d32fd60ba5e0829bd3f40017b5656f4828135b13356f88423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ebe913183678f1b0dbe7518e29c2cac2a047eab2cae06f4e68b19edd47898c3"
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
