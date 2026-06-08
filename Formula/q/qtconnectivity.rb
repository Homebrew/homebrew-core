class Qtconnectivity < Formula
  desc "Provides access to Bluetooth hardware"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtconnectivity-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtconnectivity-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtconnectivity-everywhere-src-6.11.1.tar.xz"
  sha256 "2105289ea414b46ed5fa53ba8782230045b9e47cc8156b5940c9e31e3980e591"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtconnectivity.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74bd9d47a3867ee962c3422e1720b785f866023e44df467953e5c8edd1253ec3"
    sha256 cellar: :any,                 arm64_sequoia: "a2d0beedfca5c4228e095d1bffbb21e968b6b71290fb40f0935ff023171fb141"
    sha256 cellar: :any,                 arm64_sonoma:  "6e2b52d5463ef2fee35125894220273d545fc49d55c10d46979094277e0edc86"
    sha256 cellar: :any,                 sonoma:        "6340644d490bff285063b2ad647e40908621eb9dab0fd22099957fdc2df4e75e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0332095c40e6488fca193cb856f94e427d263783bf0fce6812515aabe308ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cf46e2ba26a929ff629205d863b303cd7d324dc7d522aad974ae2947ca7cd1b"
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
