class Qtimageformats < Formula
  desc "Plugins for additional image formats: TIFF, MNG, TGA, WBMP"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtimageformats-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtimageformats-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtimageformats-everywhere-src-6.10.1.tar.xz"
  sha256 "498eabdf2381db96f808942b3e3c765f6360fe6c0e9961f0a45ff7a4c68d7a72"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtimageformats.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57ce2d0fbbd052a667976afeff75398608333c1d55bc4873f98eb18fa7ca153e"
    sha256 cellar: :any,                 arm64_sequoia: "795872488bde73f32a248d7974f466ea4c6b04b7b10bc7c2c5946596692894e2"
    sha256 cellar: :any,                 arm64_sonoma:  "c1c2956dad1eb69d3a96d71e3355ee9ac1e94ca3aea031369585b64bcd167699"
    sha256 cellar: :any,                 sonoma:        "28da3fddd23a8295a8eac48752973e0092383026933cdfe11900a2577d4a0029"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a86bf65018b8baf711740b9d1a0363ab010cd4351fa3c5d781a02a378cdb1390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3768c56ad529a9ef9f4cb182cdfe7ebf2aca8ceb73e10251ff7e9d790732fa0d"
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
