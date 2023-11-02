class QtPostgresql < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.0/submodules/qtbase-everywhere-src-6.6.0.tar.xz"
  sha256 "039d53312acb5897a9054bd38c9ccbdab72500b71fdccdb3f4f0844b0dd39e0e"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d79628ffb37546fb442e7cb4b8b090681e2e4799758fd7253f9f10ece2457fc0"
    sha256 cellar: :any,                 arm64_ventura:  "ed5fb06282aad1c2bb2159ada2c58e5716055b7f40ff9d97cf91a94b91098931"
    sha256 cellar: :any,                 arm64_monterey: "737306db7d1bed0d30e4917fcd0436cd0d7b886c39cd4e9a3e8e5fbb82da57c0"
    sha256 cellar: :any,                 sonoma:         "dda87fea5063252977b090615b814f18525d3ef0ca8b3933ac8007a0d7176af9"
    sha256 cellar: :any,                 ventura:        "1a2a696c8cda7c1d703e5a12d23493e81d722e59dc94d762a1dc8aa83631fe16"
    sha256 cellar: :any,                 monterey:       "b75a17fb1290a7617c7f7435f444b67968582a8a657204838e9d974917dfe1d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65036ec15d01e98cd3b91406cd3e8fc618575477c41bd68cb32554fe2d6d1537"
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
