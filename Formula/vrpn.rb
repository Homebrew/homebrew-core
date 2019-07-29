class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  url "https://github.com/vrpn/vrpn/releases/download/version_07.34/vrpn_07.34.zip"
  sha256 "1ecb68f25dcd741c4bfe161ce15424f1319a387a487efa3fbf49b8aa249c9910"
  head "https://github.com/vrpn/vrpn.git"

  bottle do
    cellar :any
    sha256 "5a3e1485fdbc883c3996fef9993ef1f3a0aa0e991c9610e82091663db412e471" => :mojave
    sha256 "9b9f4a31161dbc0a4a9ea0759122f0a3725a361dde0b5f1def9bab4e59de12e7" => :high_sierra
    sha256 "4e03c131adba54f74742151ee269d2d0c1716e307294679ed2366c0e6cb5fd41" => :sierra
    sha256 "36e5273f8006b1fe5f1655e258f8937e06e9abc4ad849e2c9b1e7a1462fe790d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libusb" # for HID support

  def install
    ENV.libstdcxx unless MacOS.version > :mavericks

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}",
                            "-DVRPN_BUILD_CLIENTS:BOOL=OFF",
                            "-DVRPN_BUILD_JAVA:BOOL=OFF"
      system "make", "install"
    end
  end
end
