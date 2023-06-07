class Wb32DfuUpdaterCli < Formula
  desc "USB programmer for downloading and uploading firmware to/from USB devices"
  homepage "https://github.com/WestberryTech/wb32-dfu-updater"
  url "https://github.com/WestberryTech/wb32-dfu-updater/archive/refs/tags/1.0.0.tar.gz"
  sha256 "2b1c5b5627723067168af9740cb25c5c179634e133e4ced06028462096de5699"
  license "Apache-2.0"
  head "https://github.com/WestberryTech/wb32-dfu-updater.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "87370e3838ab6edf46fd33ffe58ab53222dc519d6fcf849228461d994cf0c4f2"
    sha256 cellar: :any,                 arm64_monterey: "7e2f160501bb9541e72aaa421804bbd39036b758d76d1ba597f0e4be1146f0df"
    sha256 cellar: :any,                 arm64_big_sur:  "7bfb9b1814a0a3d0c7e861add90ecf2957e9a5dbd16a08582ef4c9dd0eda5a75"
    sha256 cellar: :any,                 ventura:        "b8580af9836f71c45a43029a65a3373e9583de4ba3d18a60fec9c686581fcd6d"
    sha256 cellar: :any,                 monterey:       "5500f504311ae7403129ecef45590f500bdf35a5a0e89a037aaf5f661c9b1bc9"
    sha256 cellar: :any,                 big_sur:        "ec1cb55399fe6198944db099424b96f8c6138cd309d3a9ff52d0206c5b295221"
    sha256 cellar: :any,                 catalina:       "a9a3f5950019c27a9a022c07af2859240987d1c93acd751e741c6a320535c6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bd5b556320a3df8117e4215c78b24686e0d4751b80d3ebb4ed280950bf6d2e8"
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "No DFU capable USB device available\n", shell_output(bin/"wb32-dfu-updater_cli -U 111.bin 2>&1", 74)
  end
end
