class Qtconnectivity < Formula
  desc "Provides access to Bluetooth hardware"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtconnectivity-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtconnectivity-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtconnectivity-everywhere-src-6.10.2.tar.xz"
  sha256 "cf58f021f32857b5b6799cd4404ef613399ecc1c515492f0f620ce338a311a32"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtconnectivity.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe0a882bb13e4ee03b3def3ae19e15b55567e3e6582c4a7a93552dbac430020f"
    sha256 cellar: :any,                 arm64_sequoia: "33ff238523002bd9c1d72ce68a7d8b60cc335fb7e2e9024c6dfbdab89b587558"
    sha256 cellar: :any,                 arm64_sonoma:  "8b1f255b499d139241cc43dd3c1b24c7897750e7e31a98b59ca2748b74b39dc7"
    sha256 cellar: :any,                 sonoma:        "cdbc3a39f363eda4d18305dfb316bc007c360d1e4a73a1d341fadb86291b1446"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb365b19f11e3f3e01e85cdf60cd14374e1012cd7396f90151ecdc73dd8ec906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bced6bd1ec404123cefb1b7a45284093645c689f14308811906654e57daf1a9f"
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
