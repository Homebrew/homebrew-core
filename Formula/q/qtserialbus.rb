class Qtserialbus < Formula
  desc "Provides access to serial industrial bus interfaces"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtserialbus-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtserialbus-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtserialbus-everywhere-src-6.9.3.tar.xz"
  sha256 "0a8139da071afcb768b9d115f514a3e5783312530b2be69e3ee42b301d775bcf"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # canbusutil
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtserialbus.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "854ed284b3edd23113f1a8ad41071fe71e632b4025020eebf87798ee3d05babb"
    sha256 cellar: :any,                 arm64_sequoia: "eedebb571a0bd192211723eb32c09a2d5bf397f2dd514c44e59800725d3db312"
    sha256 cellar: :any,                 arm64_sonoma:  "49d639f622ba2c58ed055c00ab083d6e4139c0e8cf4a77ac92e7a636a20190a0"
    sha256 cellar: :any,                 sonoma:        "f22b0a4973e5082e8d9ef5cd9e05b952146e45a8c3906c9ac8d63dc9d1a76cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28553934744f46bf5a20949ad5cbd788cc28c672fe010ca31bd27f8045394602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2564f16918575baaac56edace8e77bd0320be2209bc39cdcd09758e0a3c30232"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
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
      find_package(Qt6 REQUIRED COMPONENTS SerialBus)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::SerialBus)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += serialbus
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QCanBus>
      #include <QDebug>

      int main(void) {
        // NOTE: Can safely ignore "Cannot load library" as it checks for proprietary drivers
        for (auto device : QCanBus::instance()->availableDevices()) {
          qDebug() << device.name();
        }
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

    flags = shell_output("pkgconf --cflags --libs Qt6SerialBus").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
