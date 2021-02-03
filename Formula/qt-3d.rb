class Qt3d < Formula
  desc "3D Lib"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/archive/additional_libraries/qt3d/6.0/6.0.0/qt3d-everywhere-src-6.0.0.tar.xz"
  sha256 "ebca4357d6f1ebe70b344d1e94b5b81bae00fc421da4af8fcacb1f82740ce3c7"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qt6"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", "-G", "Ninja", ".", *args
    system "ninja"
    system "ninja", "install"
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

      find_package(Qt6 COMPONENTS Core 3DCore REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::3DCore)
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core 3dcore
      QT       -= gui
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <Qt3DCore>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        auto *root = new Qt3DCore::QEntity();
        return 0;
      }
    EOS

    system "cmake", testpath
    system "make"

    ENV.delete "CPATH"
    system "qmake", testpath/"test.pro"
    system "make"
  end
end
