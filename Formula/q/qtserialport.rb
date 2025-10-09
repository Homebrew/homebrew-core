class Qtserialport < Formula
  desc "Provides classes to interact with hardware and virtual serial ports"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtserialport-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtserialport-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtserialport-everywhere-src-6.9.3.tar.xz"
  sha256 "4b18ec030ff2644698c3f5c776894d8ffe5d3174c964d9bd8668429c943e8298"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtserialport.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8a89abf674c18356e224b863c50ef93de9443c4c00f4988a54c3a1719f1b184"
    sha256 cellar: :any,                 arm64_sequoia: "e73491d79f3318f356bbedfdf194b30e24d4591c3c7e0daa3556d1977b812607"
    sha256 cellar: :any,                 arm64_sonoma:  "be4b0ebdc65e7f9c6162d08e86db40e90923bb6c70907591533f39c107e582b9"
    sha256 cellar: :any,                 sonoma:        "6c03a8b4fb34e06d80abdab55dc6821dbb7b04d7f508b980af32681e3ef91f02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a6286dcb267ef4602cb8b11faba3a1ce80c19fd1affd2d0dca59bc3e59384ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6f4079925529e453d07694d63aa22a15a19cec659cce192559a3857832d67c9"
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
