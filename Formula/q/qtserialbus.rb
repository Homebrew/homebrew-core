class Qtserialbus < Formula
  desc "Provides access to serial industrial bus interfaces"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtserialbus-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtserialbus-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtserialbus-everywhere-src-6.11.1.tar.xz"
  sha256 "c46c9c0c8d6815301a669cdbd5866c10bcfb9e56889f5d7da14e11d6ad24f20a"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # canbusutil
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtserialbus.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34f00db80fca021b7ba9dd038e46b7cbf46b6d830099c5bed43409d35b3b7ecd"
    sha256 cellar: :any,                 arm64_sequoia: "7aae778e651098ddfb66eaacc850875a7db61c8357a759773b825fc5e4addc9f"
    sha256 cellar: :any,                 arm64_sonoma:  "d35418e1b980f3ea3d5e7cea58a88e256873f143d941c31dbeca1ee491be6367"
    sha256 cellar: :any,                 sonoma:        "e90221ee821a06c2532144c282e2b2d2caede50e5c3c8842f12b7e9893e9a21f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b80fbaf0555c8f953999faf043d767b3a9c795adf9c22b6e763ae109158a80c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24681a34700f0f14e2087bb1ec2f32c388d1e5588bba4da6b1eaaaacad8785d7"
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
