class Qtimageformats < Formula
  desc "Plugins for additional image formats: TIFF, MNG, TGA, WBMP"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtimageformats-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtimageformats-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtimageformats-everywhere-src-6.12.0.tar.xz"
  sha256 "0943132b5db8de6b6a7f1d162682173e8763c7ed94e80fd39113292845f67762"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtimageformats.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c3bb1fbcb22b84c98229a39ba7e3db6d98bdb21a084a93a31c1d225ef49ffe3c"
    sha256 cellar: :any, arm64_tahoe:       "bd485b9e112bbc4fde980efc51dac679db1c773ece989b3a881eb0d1c1b1360b"
    sha256 cellar: :any, arm64_sequoia:     "6aa5b957ba3d1e64b4954774cd66178d620236244bc24727232c6f5fd61c66c0"
    sha256 cellar: :any, arm64_linux:       "94883e48923a8aa726f3089788528457264d7732d3010bba9aa345ab2b33e3c2"
    sha256 cellar: :any, x86_64_linux:      "7aecd067380bece0fecd3afcf062f571c63e05777b12c2971079fe6a1814a1d9"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "libtiff"
  depends_on "qtbase"
  depends_on "webp"

  on_linux do
    depends_on "jasper"
  end

  def install
    rm_r("src/3rdparty")

    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_system_tiff=ON
      -DFEATURE_system_webp=ON
    ]
    args << if OS.mac?
      "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON"
    else
      "-DFEATURE_jasper=ON" # macOS can use Apple ImageIO Framework instead
    end

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
      find_package(Qt6 REQUIRED COMPONENTS Gui)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Gui)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += gui
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QImageReader>

      int main(void) {
        const auto &list = QImageReader::supportedImageFormats();
        Q_ASSERT(list.contains("icns"));
        Q_ASSERT(list.contains("jp2"));
        Q_ASSERT(list.contains("tga"));
        Q_ASSERT(list.contains("tif"));
        Q_ASSERT(list.contains("tiff"));
        Q_ASSERT(list.contains("wbmp"));
        Q_ASSERT(list.contains("webp"));
      #ifdef __APPLE__
        Q_ASSERT(list.contains("heic"));
        Q_ASSERT(list.contains("heif"));
      #endif
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal"

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system formula_opt_bin("qtbase")/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6Gui").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
