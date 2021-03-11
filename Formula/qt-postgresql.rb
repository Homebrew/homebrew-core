class QtPostgresql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.2/submodules/qtbase-everywhere-src-6.0.2.tar.xz"
  sha256 "991a0e4e123104e76563067fcfa58602050c03aba8c8bb0c6198347c707817f1"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "cdb24bf5fe174d484438d265095fd6c38614e55f11dd0be543dead6b1abbbe20"
    sha256 cellar: :any, big_sur:       "d497f050cb6530bf28f409a84093bb875f8d60e8842b30ba1e465527cb5e0fb4"
    sha256 cellar: :any, catalina:      "778231dc3ffc60418545ca8530550908723090b3b2ea4e6bbfeaeceae2f16e21"
    sha256 cellar: :any, mojave:        "ae857493cde2aa599959fb887b76c502ef925b2a11fbe713b5f43393b25687d8"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "postgresql"
  depends_on "qt"

  def install
    cd "src/plugins/sqldrivers" do
      system "qmake"
      system "make", "sub-psql"
      (share/"qt").install "plugins/"
    end
    Pathname.glob(share/"qt/plugins/sqldrivers/#{shared_library("*")}") do |plugin|
      system "strip", "-S", "-x", plugin
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.19.0)
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
        QCoreApplication a(argc, argv);
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
        assert(db.isValid());
        return 0;
      }
    EOS

    system "cmake", "-DCMAKE_BUILD_TYPE=Debug", testpath
    system "make"
    system "./test"

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    system "./test"
  end
end
