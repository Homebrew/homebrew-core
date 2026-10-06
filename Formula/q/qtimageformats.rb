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
    sha256 cellar: :any, arm64_golden_gate: "59152b29f08c34534caea89417c7917eae18f025c7c5c5be4f9cb33c0b654d10"
    sha256 cellar: :any, arm64_tahoe:       "a02105982f1256b050dc4efa5d34d788ba44d2fcf764e617c0f26c5295ce3099"
    sha256 cellar: :any, arm64_sequoia:     "7f3940e679dd2d382564496f36ae0ec1eac8d7e91c1cbc55bf7bbd24895a140a"
    sha256 cellar: :any, arm64_sonoma:      "6739d65d475052a8c77781efd3329fd0c0d956196252306c397b6ace0c475033"
    sha256 cellar: :any, arm64_linux:       "b87f2769f8fcef5287df77b39ea6d6cc6234598cd4a20a4a2d1bcb7e942d1fe3"
    sha256 cellar: :any, x86_64_linux:      "80cf10a9cf640df6ca95df4ec096383d7711a0a34c5bcacfbaf7aeb93ba9f618"
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
