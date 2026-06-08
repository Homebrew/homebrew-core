class Qtimageformats < Formula
  desc "Plugins for additional image formats: TIFF, MNG, TGA, WBMP"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtimageformats-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtimageformats-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtimageformats-everywhere-src-6.11.1.tar.xz"
  sha256 "b2bf6c6845ac175ed7f819145483ba4676f617aaa6a5012c8efee63c8bbac413"
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
    sha256 cellar: :any,                 arm64_tahoe:   "da6df7c6bd5379f35e828e5a330d94a762da3d680dffc25ba0f0e15054c0c067"
    sha256 cellar: :any,                 arm64_sequoia: "7328c7658f26e8d69154bc07662850d5e9a2f25efc0288fec78508c5a484b1c8"
    sha256 cellar: :any,                 arm64_sonoma:  "d5b0738d0052617d5a2c3d02b82be89f7cdda2c39aa5b049ac752dc1d32ebeaa"
    sha256 cellar: :any,                 sonoma:        "a18673e37675013817a45f4fc84d1a58b559297e42fbb782ab7b9bcc62e46de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9fed936dcbc12d4a0d639d151695d04e3365c5640c2e67143b0a34e567ab257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21bc6a2cabb95927c2a0d505cf4441076116ee9ae0aa96e5f0973c771ff64b9c"
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
