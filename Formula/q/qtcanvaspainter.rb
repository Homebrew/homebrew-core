class Qtcanvaspainter < Formula
  desc "Accelerated 2D painting solution for Qt Quick and QRhi-based render targets"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.2/submodules/qtcanvaspainter-everywhere-src-6.11.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.2/submodules/qtcanvaspainter-everywhere-src-6.11.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.2/submodules/qtcanvaspainter-everywhere-src-6.11.2.tar.xz"
  sha256 "8a90a27250ceef5ff659744e035ef4f5d3cd7392e027d5f953765b3f1083e760"
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
    sha256 cellar: :any, arm64_golden_gate: "4fdfd0705d1367d5495e6599facceb837ade7d7b0653aee843c23c4e308901f6"
    sha256 cellar: :any, arm64_tahoe:       "a6bb00ca5067608c56e51e70ff90bdb935a5c2c9164af9c97ddf3401aa5e0570"
    sha256 cellar: :any, arm64_sequoia:     "4e0492f31e6e4b7189c9ec0e2857c8b29b97b0a382831e4a33614b5a4789b60f"
    sha256 cellar: :any, arm64_sonoma:      "5deaa0eb21587966debfdd016e1138692ccb2efafba69156138daa5f364f796e"
    sha256 cellar: :any, arm64_linux:       "5d81d776cc6a867857267bc5bd7cb6a637f2680e0c0aaf736fa4b85d7861ad4b"
    sha256 cellar: :any, x86_64_linux:      "1bf9a2f33d03593cf43a1f7cfc90130966a6821a10bceb7fee5d5220a9146501"
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
      system formula_opt_bin("qtbase")/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6CanvasPainter").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
