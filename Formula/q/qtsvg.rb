class Qtsvg < Formula
  desc "Classes for displaying the contents of SVG files"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtsvg-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtsvg-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtsvg-everywhere-src-6.11.1.tar.xz"
  sha256 "7f3cf02f4824bf03c2c5859ea6db173bf1482a1daf24e6cdf7bc78cfa26a8a94"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtsvg.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63a90b82065224a984a49acb79c9093d4cfe49604773275259ec38d71aa6b540"
    sha256 cellar: :any,                 arm64_sequoia: "4a4a099f4efd7ac52498863da80e2003ad1efa9f4014675773f54bda45ca2fe6"
    sha256 cellar: :any,                 arm64_sonoma:  "1cfb3ef8360be50b145c0b453345b272e47b60ffea66adbff501983108534b7a"
    sha256 cellar: :any,                 sonoma:        "a531de952828bbd87f348b532482a3cad9827c75bcfcf8f8061c6e0b625f8f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0609e2f428aaeb430794e867aa31b17b44abb7b5653647aac02b7d28c892f63a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a32be2f4673db832761f994cf0a3ac6638e9ccf3d53b33e6f4780bb016544d4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
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

      int main(void) {
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
      system Formula["qtbase"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6Svg").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
