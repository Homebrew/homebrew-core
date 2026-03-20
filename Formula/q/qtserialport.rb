class Qtserialport < Formula
  desc "Provides classes to interact with hardware and virtual serial ports"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtserialport-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtserialport-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtserialport-everywhere-src-6.10.2.tar.xz"
  sha256 "b40cbf29da111ffa8fee7e7cb44b9097042782cd17a10448a83ff3156cdebd6b"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtserialport.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b58bd62abf1078b6afb8cc625389d0b7a55b55ddfc8f3be6e30885a3785cfaf"
    sha256 cellar: :any,                 arm64_sequoia: "b89a5ec7f7f5380d94ac2b57def7c973988f68c2a0c833077007c20fa73ef9fd"
    sha256 cellar: :any,                 arm64_sonoma:  "7beebe6109ed867700d4332d6ad7969ff839f4f4da763f38c32c0ee8456e94ed"
    sha256 cellar: :any,                 sonoma:        "93f5a8e7b9bdb30f6d41a4900978506b98b848613220abc0b502e56e02d641a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c37ff62b11198825040aa761dcaebb78b7b9fafc6c07812bd41c21b8914d881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c4f28bc9114ceacd542571568f95878dfb528f36f9f6d5b495e5c630d94de24"
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
