class QtUnixodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.2/submodules/qtbase-everywhere-src-6.5.2.tar.xz"
  sha256 "3db4c729b4d80a9d8fda8dd77128406353baff4755ca619177eda4cddae71269"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "085ac431e47c676160bed5e012a48911d9c930e51e996f902472f242c38d69c4"
    sha256 cellar: :any,                 arm64_ventura:  "fbae1c11298d5b3b00fc2297222bc877ef67508ea0b75152d3cb86d4880db3b6"
    sha256 cellar: :any,                 arm64_monterey: "09bf198d7066f0af56cc84907a5c35817f3460788c084ae16f9d5ef4587f0e45"
    sha256 cellar: :any,                 arm64_big_sur:  "0b16a536b91cb783230feb7d1a492700215071b532934c7d2be44b001be52e3a"
    sha256 cellar: :any,                 sonoma:         "e226b5a500f5d1ed8121cf4f7ea72d57296bc576e07f388cc7edbe74269e7c6e"
    sha256 cellar: :any,                 ventura:        "6d8f3b7fbf38c0fed278f3189ebde536c34884ecf72a477b24a93b03348867b0"
    sha256 cellar: :any,                 monterey:       "5ce7fa0555edfd016950adeae6afb3170cb7d0941b972eb023bfcc2ce4dc35f4"
    sha256 cellar: :any,                 big_sur:        "2f82e90fef0117dad086ba0ed050a9c3d05e9b6ff2fc5bf8f48827631cb04867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38babc2a0d860ce81a80363d0ab766742ef413197a0fd7084dd05a55f2eed9e1"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "qt"
  depends_on "unixodbc"

  conflicts_with "qt-libiodbc",
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
