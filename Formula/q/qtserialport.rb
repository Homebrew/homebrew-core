class Qtserialport < Formula
  desc "Provides classes to interact with hardware and virtual serial ports"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtserialport-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtserialport-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtserialport-everywhere-src-6.10.1.tar.xz"
  sha256 "17b2f68435f67785a0c75fd70125f3e1892282efdab2098dcdac02d1d70f4c4c"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtserialport.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af814e3cc44bc1a27e07b3f2cc6968295b45e9d8ff871f94ad2c8fc82bb518d5"
    sha256 cellar: :any,                 arm64_sequoia: "4c096cb4e067f3cafce0aa9f1b8c66923c920b9a0c9144678cea3500308e9ee1"
    sha256 cellar: :any,                 arm64_sonoma:  "7d17b535c69e4624d5f481c36e219c58f27e4ece28948d149fcb113acca58b66"
    sha256 cellar: :any,                 sonoma:        "e728f43f2db6fc84abdfad3e441ebfe16b30c9ef5b95e15486d54be1aeee7cb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47ab88a6cbeabaa1def2e85b4965e7e11ba542597bc757034add3ac8b99da4c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da99a146d400f9d01321ca61ec5abf9faf6572fca5c4a868f997b7e02d1ab25"
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
