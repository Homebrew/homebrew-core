class Qtserialport < Formula
  desc "Provides classes to interact with hardware and virtual serial ports"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtserialport-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtserialport-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtserialport-everywhere-src-6.11.1.tar.xz"
  sha256 "9af31a898ffd9a7e4faf6fed845d29e783c716885789055cbe319f3e072d3974"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtserialport.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f9c1f32c5ffe25029526e6d90698338aeefa29bd7be7ff2e22a8881e48b5bae"
    sha256 cellar: :any,                 arm64_sequoia: "7c7a4febdae73410e73314acfbe41daa5bfb962e8e079746cdc113bbc8cab4d2"
    sha256 cellar: :any,                 arm64_sonoma:  "273f5a1bde35e1cce05e7e922e5360734d92d198d8935cb4e0d409c0b41a8946"
    sha256 cellar: :any,                 sonoma:        "4c6f12f2ce030d2fb9dddefb4d3f77acf542d53a756f0407674bea2f81ecdf1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "664bf745a8c0aafc28137a22daed4b486c64e7a5b902153ff667865cd8984066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65a880eafca61c8a25c954b374f6e1cda085fad7df084deec2cd3dfb642a8747"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd"
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
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS SerialPort)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::SerialPort)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += serialport
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~'CPP'
      #undef QT_NO_DEBUG
      #include <QSerialPortInfo>
      #include <QDebug>

      int main(void) {
        const auto serialPortInfos = QSerialPortInfo::availablePorts();
        for (const QSerialPortInfo &portInfo : serialPortInfos) {
          qDebug() << "Port:" << portInfo.portName() << "\n"
                   << "Location:" << portInfo.systemLocation() << "\n";
        }
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

    flags = shell_output("pkgconf --cflags --libs Qt6SerialPort").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
