class Qtcanvaspainter < Formula
  desc "Accelerated 2D painting solution for Qt Quick and QRhi-based render targets"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtcanvaspainter-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtcanvaspainter-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtcanvaspainter-everywhere-src-6.11.1.tar.xz"
  sha256 "9e36c61b10a5eb9b4a4af058996de5816d2c0d9f02415876ca8c0f8cccfd08d0"
  license all_of: [
    "GPL-3.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qcshadergen
    "BSD-3-Clause", # *.cmake
    "Zlib", # nanovg
  ]
  head "https://code.qt.io/qt/qtcanvaspainter.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ad224d80791ae2b03872aaadb254eafbe5a7bd000e0eeb3346131cc28019c42"
    sha256 cellar: :any,                 arm64_sequoia: "ca05aaaf6c56a21e48d1ef635c6688e4e2c71ec017cef63384aabb92f8395d04"
    sha256 cellar: :any,                 arm64_sonoma:  "ab3ba6c9fda2f2aa2bba35ffd4f6cdfb2b34243841ca33ccdbebdfa16d55cbdc"
    sha256 cellar: :any,                 sonoma:        "6d3c3330ffe79010278ead841798e411c9998ac24a9a19592e3aab32e8f164a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0656f9481856ff11697ea6bda244170c8da32d76d28c8783a9125c2b1ce61e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b5bd7751e537846c0dbc108d4c887dceb8931a211fe3998e6eceb6eb257f6bd"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "qtshadertools" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"

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
      project(test LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS CanvasPainter)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::CanvasPainter)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += canvaspainter
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <cassert>
      #include <QtCanvasPainter>

      int main(void) {
        QCanvasPath p1;
        QCanvasPath p2;
        assert(p1 == p2);
        p1.moveTo(10, 20);
        assert(p1 != p2);
        p2.moveTo(10, 20);
        assert(p1 == p2);
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

    flags = shell_output("pkgconf --cflags --libs Qt6CanvasPainter").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
