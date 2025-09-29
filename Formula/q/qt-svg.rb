class QtSvg < Formula
  desc "Provides functionality for handling SVG images"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.2/submodules/qtsvg-everywhere-src-6.9.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.2/submodules/qtsvg-everywhere-src-6.9.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.2/submodules/qtsvg-everywhere-src-6.9.2.tar.xz"
  sha256 "d984cab8f26334aa1c15e5b8f0cd9f1b7c0c1289fe0b68c1c84ab469b75605a5"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtsvg.git", branch: "dev"

  livecheck do
    formula "qt-base"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on xcode: :build
  depends_on "pkgconf" => :test

  depends_on "qt-base"

  uses_from_macos "zlib"

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      # Allow accessing headers from include directory
      include.install_symlink f/"Headers" => f.stem
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 REQUIRED COMPONENTS Svg)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Svg)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += svg
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QImageReader>
      #include <QtSvg>
      #include <QDebug>
      #include <iostream>

      int main(void)
      {
        QSvgGenerator generator;
        const auto &list = QImageReader::supportedImageFormats();
        Q_ASSERT(list.contains("svg"));
        Q_ASSERT(list.contains("svgz"));
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system Formula["qt-base"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6Svg").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
