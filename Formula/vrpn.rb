class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  url "https://github.com/vrpn/vrpn/releases/download/version_07.34/vrpn_07.34.zip"
  sha256 "1ecb68f25dcd741c4bfe161ce15424f1319a387a487efa3fbf49b8aa249c9910"
  head "https://github.com/vrpn/vrpn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0166e398738d642dbe0c93a058a4e436060c6b57175ad2f6cff9ed53fd2bd857"
    sha256 cellar: :any,                 big_sur:       "679f3b5776a13311701ec2e75481dd263a47444084bd06948da80b7787184b60"
    sha256 cellar: :any,                 catalina:      "cecacf7a6918983b48197ab850b20e00a775a607f28b53e51ba49e89f550b2a6"
    sha256 cellar: :any,                 mojave:        "5a3e1485fdbc883c3996fef9993ef1f3a0aa0e991c9610e82091663db412e471"
    sha256 cellar: :any,                 high_sierra:   "9b9f4a31161dbc0a4a9ea0759122f0a3725a361dde0b5f1def9bab4e59de12e7"
    sha256 cellar: :any,                 sierra:        "4e03c131adba54f74742151ee269d2d0c1716e307294679ed2366c0e6cb5fd41"
    sha256 cellar: :any,                 el_capitan:    "36e5273f8006b1fe5f1655e258f8937e06e9abc4ad849e2c9b1e7a1462fe790d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "789d64889877212b96531df4039aee677863793cf29aeb55ad425ff3dd7d3a59"
  end

  depends_on "cmake" => :build
  depends_on "libusb" # for HID support

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}",
                            "-DVRPN_BUILD_CLIENTS:BOOL=OFF",
                            "-DVRPN_BUILD_JAVA:BOOL=OFF"
      system "make", "install"
    end
  end
end
