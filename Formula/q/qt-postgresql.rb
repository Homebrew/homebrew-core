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
    sha256 cellar: :any,                 arm64_sonoma:   "e503abd2cd9ed6677e415315867f58b6618d75631a94c66f5343835c6e265241"
    sha256 cellar: :any,                 arm64_ventura:  "b3406656ecb755d4a9eefa3fb47a483be116c2915a09686d46799c9d9a7c15b2"
    sha256 cellar: :any,                 arm64_monterey: "5fc98f12ebe54e2c580bf48cc325f6bb987fc0a8c422e8df70f9c392b2bbb090"
    sha256 cellar: :any,                 sonoma:         "184ea4a5f980ed6f4e25dfe23edd37ea828be710ff22a2893e7329ac1b0d7c0d"
    sha256 cellar: :any,                 ventura:        "0efad2d9845ea5bf8f21876c202cee95239c6a38038389e0404f2a094052facc"
    sha256 cellar: :any,                 monterey:       "caab8307bc63b81a7655624d1763633c3a7c6d3efa0620ca65b36dcb8d6403f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63feb4756a65daf81e2f97dae9215756eddc06af15cf3df7dcc83f6b3fe1e301"
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
