class QtUnixodbc < Formula
  desc "Qt SQL plugin for ODBC"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.1/submodules/qtbase-everywhere-src-6.0.1.tar.xz"
  sha256 "8d2bc1829c1479e539f66c2f51a7e11c38a595c9e8b8e45a3b45f3cb41c6d6aa"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qt@6"
  depends_on "unixodbc"

  conflicts_with "qt-iodbc",
  because: "qt-unixodbc and qt-iodbc install the same binaries"

  def install
    cd "src/plugins/sqldrivers" do
      system "qmake", "--", "ODBC_PREFIX=#{Formula["unixodbc"].opt_prefix}"
      system "make", "sub-odbc"
      (share/"qt").install "plugins/"
    end
    Pathname.glob("#{share}/qt/plugins/sqldrivers/*.dylib") do |plugin|
      system "strip", "-S", "-x", plugin
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.16.0)

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
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QtSql>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
        qDebug() << db.isValid();;
        return 0;
      }
    EOS

    system "cmake", testpath
    system "make"
    assert_equal "true", shell_output("#{testpath}/test 2>&1").strip

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    assert_equal "true", shell_output("#{testpath}/test 2>&1").strip
  end
end
