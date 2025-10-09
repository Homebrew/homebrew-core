class Qtconnectivity < Formula
  desc "Provides access to Bluetooth hardware"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtconnectivity-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtconnectivity-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtconnectivity-everywhere-src-6.9.3.tar.xz"
  sha256 "e21bba5efb174c4456c5e5a7b4d52bba1ee62dfb4509bcff73fdfad9cb1dd7f5"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtconnectivity.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46990ccc8f093045c2062b4ce93ef453ec9a4b37789f96b22c32b425e3ff6f8b"
    sha256 cellar: :any,                 arm64_sequoia: "fd9521753c641880c1c195936787a70ad33023c6c481d990e11db44e04e68a4e"
    sha256 cellar: :any,                 arm64_sonoma:  "9309787fa0b27c8a7a17be3a317cf413d8c7db8cdb46b643f6813ca7e40f18c5"
    sha256 cellar: :any,                 sonoma:        "0561107aa7d4c025cd48aec78034789d7629eb5ca918ee3e251c1e9bbaed9925"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe829fc263f15cfd263764fc5707f90fb7c70b315759b91facd869a5f5bf4389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49aab37a8f1da9d6b8a68b690d75877f8a5c48265b3dd7dd67e5d0f930059ee5"
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
