class QtLibiodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.2/submodules/qtbase-everywhere-src-6.3.2.tar.xz"
  sha256 "7929ba4df870b6b30870bc0aed2525cfc606ed7091107b23cf7ed7e434caa9a6"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "1aa1db1b91b0c13c4b5a7c007c303ed2708de5f7a89b235a8fc2122011ded820"
    sha256 cellar: :any, arm64_big_sur:  "5ae7faf29aaf9da11dbede23c52af2e0cacb84387b28982140345199429f056e"
    sha256 cellar: :any, monterey:       "8c7ea4929040e1f4f3b9f6697c64d664a71c8a07e563afe9ee55030175cae592"
    sha256 cellar: :any, big_sur:        "8b76df7dc45f85676f92c285f013dcc6cef1f37365444f82c38ae2030f806834"
    sha256 cellar: :any, catalina:       "cd18c2d53e36153ba936e7ceb378a94094e609b1704d610bf47abdbca21c2d76"
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
