class Qtconnectivity < Formula
  desc "Provides access to Bluetooth hardware"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtconnectivity-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtconnectivity-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtconnectivity-everywhere-src-6.10.1.tar.xz"
  sha256 "7baefd3a90c73820e33ddc59ded8c018e233d14d23eaa4eadbf332b5ac2154ff"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtconnectivity.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "870d3c3a6e1aa8f81f120277d83c5457615020f59ca69d1c91f233c0f36b20ac"
    sha256 cellar: :any,                 arm64_sequoia: "077edab468470a94688d1eb2f8b0e095b7c750d9244ae605c5d63a2feaaa3588"
    sha256 cellar: :any,                 arm64_sonoma:  "7c7c224e1d2fa6c346fe7baaba6e8c33d55d5ef43731612511bf0909d1223c9c"
    sha256 cellar: :any,                 sonoma:        "eefe93a7b0789d0fc9576852d91e94b985ab8be9e3ad388d12ecb35a58632621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "793a0870b4a5e3364fee67c2c0140451bd32067752867732a102386df454ea29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc2e7214c195e92ae405f028b18953046c52b2dab45dea3c61e23038e84c9b86"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"

  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "bluez"
  end

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
    # NOTE: On macOS we cannot run executable as it requires Bluetooth permissions via interactive prompt
    run_executable = !OS.mac?

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS Bluetooth)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Bluetooth)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += bluetooth
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QBluetoothLocalDevice>
      #include <QDebug>

      int main(void) {
        QBluetoothLocalDevice localDevice;
        if (localDevice.isValid()) {
          qInfo() << localDevice.name();
        }
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test" if run_executable

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system Formula["qtbase"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test" if run_executable
    end

    flags = shell_output("pkgconf --cflags --libs Qt6Bluetooth").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test" if run_executable
  end
end
