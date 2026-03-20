class Qtpositioning < Formula
  desc "Provides access to position, satellite info and area monitoring classes"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtpositioning-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtpositioning-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtpositioning-everywhere-src-6.10.2.tar.xz"
  sha256 "7051fa64477c66769840cad396fc3772a01ba5516363c8842a7a513fa0c4cdce"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # bundled poly2tri; *.cmake
    "BSL-1.0",      # bundled clipper
    "MIT",          # bundled clip2tri
  ]
  head "https://code.qt.io/qt/qtpositioning.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f313e3d9ba56268d927c1a09fe4690636226cc35bb38bfb3d39f83abb2013aac"
    sha256 cellar: :any,                 arm64_sequoia: "68887dddac79fe6eb024f8d93d80654c454c6369b5b2541e3bfe909f86ac6a0b"
    sha256 cellar: :any,                 arm64_sonoma:  "e70be8205e0baf5d6851b29e8fe3fccfa214d775bafb2c02f7135ca8aaedcc36"
    sha256 cellar: :any,                 sonoma:        "d36c33e270d92488f0fef6fd684f245bb8520d4f7abd9103403009f5cf4822eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7437906399dcb64dfcc87c37f0ae02cbb5af84239810b12e98da14284ceaf030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c53f32391269ba8aa8ae44abc5d8ba0e1cd30938acd2e411b39c70187edc5285"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtserialport"

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
      find_package(Qt6 REQUIRED COMPONENTS Positioning)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Positioning)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += positioning
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QGeoPositionInfoSource>

      int main(void) {
        Q_ASSERT(QGeoPositionInfoSource::availableSources().contains("nmea"));
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

    flags = shell_output("pkgconf --cflags --libs Qt6Positioning").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
