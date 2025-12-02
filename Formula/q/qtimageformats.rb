class Qtimageformats < Formula
  desc "Plugins for additional image formats: TIFF, MNG, TGA, WBMP"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtimageformats-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtimageformats-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtimageformats-everywhere-src-6.9.3.tar.xz"
  sha256 "4fb26bdbfbd4b8e480087896514e11c33aba7b6b39246547355ea340c4572ffe"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtimageformats.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f36e8943686802d046651f233ff63386c126443cd3bd9bd92e55940e1a93124"
    sha256 cellar: :any,                 arm64_sequoia: "4730520a5ffe2a0dc02b4037bbb073cae05e5b8926ca9786cb76cfb03e6da177"
    sha256 cellar: :any,                 arm64_sonoma:  "9e8c7cc840f05e1babafbcb767e5e5ed6e47d5cd48d2592579a09910d1b02894"
    sha256 cellar: :any,                 sonoma:        "87cd8046387e13613f6b04d1d60d3c45340cc16201db30f32f9e4c45113f7fd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a23663253c2382fadb27f04600d5b4f1e78f2d5b349643086e313cb9d928e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bc7a304fcdfb672f8205bbfc268dc9bddb35a5ee6bf58ffdb329aa4fc0bd4ef"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "libmng"
  depends_on "libtiff"
  depends_on "qtbase"
  depends_on "webp"

  def install
    rm_r("src/3rdparty")

    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_system_tiff=ON
      -DFEATURE_system_webp=ON
    ]
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
        for(const char* fmt : {"icns", "jp2", "tga", "tif", "tiff", "wbmp", "webp"}) {
          Q_ASSERT(list.contains(fmt));
        }
      #ifdef __APPLE__
        Q_ASSERT(list.contains("heic"));
        Q_ASSERT(list.contains("heif"));
      #endif
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

    flags = shell_output("pkgconf --cflags --libs Qt6Gui").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
