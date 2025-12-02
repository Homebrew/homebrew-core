class Qtsvg < Formula
  desc "Classes for displaying the contents of SVG files"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtsvg-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtsvg-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtsvg-everywhere-src-6.9.3.tar.xz"
  sha256 "db76aa3358cbbe6fce7da576ff4669cb9801920188c750d3b12783bbe97026e2"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtsvg.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b999d5ec5374d07bf0bd9054bbfa07e5c99600a2a66ac1443a60f82db322ca8"
    sha256 cellar: :any,                 arm64_sequoia: "1c957a3056610a7c6df750b38cb77e1f36be981755f8c6b13be05fd5bd9c0b15"
    sha256 cellar: :any,                 arm64_sonoma:  "207ffa2660c6101fcdaeb82fb96f3f4fe01908c0c8e5d5768857ed74dfaca5cb"
    sha256 cellar: :any,                 sonoma:        "25d2a966b420dedf3c935cb08339b4b57bc0fccf3e9c6e21f754cd82fdb6e819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cbfec9d62bdfca1c483c1cd565ee4d3b1c436dd200063a81efc00ff02484227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0520e7c62d0c903d2bd5a75c5e8493ea13e0f21b0dd8d72c96e5f65a17509eee"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"

  uses_from_macos "zlib"

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
