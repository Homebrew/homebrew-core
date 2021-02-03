class QtImageformats < Formula
  desc "Qt image formats support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/archive/additional_libraries/qtimageformats/6.0/6.0.0/qtimageformats-everywhere-src-6.0.0.tar.xz"
  sha256 "6f2823151425656f67d1b7198a9677e236f371a0213e651604c817a0b0a10846"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "jasper"
  depends_on "libtiff"
  depends_on "qt6"
  depends_on "webp"

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

      find_package(Qt6 COMPONENTS Core Gui REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::Gui)
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core gui
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QImageReader>
      #include <QDebug>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        for(const auto &format :
          QImageReader::supportedImageFormats()) {
          std::cout << format.toStdString() << std::endl;
        }
        return 0;
      }
    EOS

    system "cmake", testpath
    system "make"
    assert_match "icns", shell_output("#{testpath}/test")

    ENV.delete "CPATH"
    system "qmake", testpath/"test.pro"
    system "make"
    assert_match "icns", shell_output("#{testpath}/test")
  end
end
