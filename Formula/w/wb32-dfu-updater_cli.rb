class Wb32DfuUpdaterCli < Formula
  desc "USB programmer for downloading and uploading firmware to/from USB devices"
  homepage "https://github.com/WestberryTech/wb32-dfu-updater"
  url "https://github.com/WestberryTech/wb32-dfu-updater/archive/refs/tags/1.0.0.tar.gz"
  sha256 "2b1c5b5627723067168af9740cb25c5c179634e133e4ced06028462096de5699"
  license "Apache-2.0"
  head "https://github.com/WestberryTech/wb32-dfu-updater.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "934c190218de4e881ed04b18bf537a15710600e07055dec9a0adbca436afab65"
    sha256 cellar: :any,                 arm64_sequoia:  "ac239ddaa16c7c73763bb0e7fccf0e832ba3dde536d90115ac65fb1ac58da4eb"
    sha256 cellar: :any,                 arm64_sonoma:   "d661a663c75316e1523b6fa0407cebda2ea86788a3fbf23ac6657af815d1c2b9"
    sha256 cellar: :any,                 arm64_ventura:  "87370e3838ab6edf46fd33ffe58ab53222dc519d6fcf849228461d994cf0c4f2"
    sha256 cellar: :any,                 arm64_monterey: "7e2f160501bb9541e72aaa421804bbd39036b758d76d1ba597f0e4be1146f0df"
    sha256 cellar: :any,                 arm64_big_sur:  "7bfb9b1814a0a3d0c7e861add90ecf2957e9a5dbd16a08582ef4c9dd0eda5a75"
    sha256 cellar: :any,                 sonoma:         "7b286ba7e7d2bd622870689fc34fe6e0903624ebb811ddbeb49139a1203d3513"
    sha256 cellar: :any,                 ventura:        "b8580af9836f71c45a43029a65a3373e9583de4ba3d18a60fec9c686581fcd6d"
    sha256 cellar: :any,                 monterey:       "5500f504311ae7403129ecef45590f500bdf35a5a0e89a037aaf5f661c9b1bc9"
    sha256 cellar: :any,                 big_sur:        "ec1cb55399fe6198944db099424b96f8c6138cd309d3a9ff52d0206c5b295221"
    sha256 cellar: :any,                 catalina:       "a9a3f5950019c27a9a022c07af2859240987d1c93acd751e741c6a320535c6e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a2d90c6c2b6c8c7ad35af63a0fd3ad9706eaa9eacb58263b431b859ad5ad03d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bd5b556320a3df8117e4215c78b24686e0d4751b80d3ebb4ed280950bf6d2e8"
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  # Fix compatibility with cmake 4+
  # PR ref: https://github.com/WestberryTech/wb32-dfu-updater/pull/17
  patch do
    url "https://github.com/WestberryTech/wb32-dfu-updater/commit/34725776e4b21be89e5d4eb0ea83346f26fc5d1f.patch?full_index=1"
    sha256 "bfcc362f17c3063b90531e2795e7d33743dc754cce5dac2a93582994f9a88479"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "No DFU capable USB device available\n",
                 shell_output("#{bin}/wb32-dfu-updater_cli -U 111.bin 2>&1", 74)
  end
end
