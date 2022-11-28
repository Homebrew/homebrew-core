class QtUnixodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.1/submodules/qtbase-everywhere-src-6.4.1.tar.xz"
  sha256 "532ad71cc0f9c8f7cb92766c47bc3d23263c60876becd9053802f9727af24fae"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d979aec2236581625fce5dcda03bf8c5701890284d743612fa40141f33d85004"
    sha256 cellar: :any,                 arm64_monterey: "c0344251ca2fb6f9c0f35332daf1ee1c6ae7d70d55e333eff30e02a8a5506a4d"
    sha256 cellar: :any,                 arm64_big_sur:  "367688f26e931c06e3bba11165c501b9a993f34b1402321e38e4233a76509d2f"
    sha256 cellar: :any,                 ventura:        "18e407e974eb1243b2a0a00a0a80bc52aa94465daa3f702b2df0a0119b98a689"
    sha256 cellar: :any,                 monterey:       "0a04311016edfa0a47e164ce475370a04277a9e6d54c8a13c14dea6f809a66f9"
    sha256 cellar: :any,                 big_sur:        "c02b5dff267082674db5bccda102cea2bad9dd503612ade9f50863a81d346aba"
    sha256 cellar: :any,                 catalina:       "29d58b8b96a0077f3e8818803fd650d7c575e1e1290de0d74042862906699c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7679dd624df4c02ddf4eb16aa5f0c878decd59661dd9cdef6fbd5720822fc0f5"
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
