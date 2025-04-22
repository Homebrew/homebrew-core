class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  url "https://github.com/vrpn/vrpn/releases/download/version_07.35/vrpn_07.35.zip"
  sha256 "06b74a40b0fb215d4238148517705d0075235823c0941154d14dd660ba25af19"
  license "BSL-1.0"
  head "https://github.com/vrpn/vrpn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "462a889a4d51338c58f99862c0812246a5277b9d2e234cfdf860d48c4be65220"
    sha256 cellar: :any,                 arm64_sonoma:  "91159cd014e31a07bb587ef84b34fc15356a33f9530395556e1c53698ff67b17"
    sha256 cellar: :any,                 arm64_ventura: "0966014087dbd6557936ebcd2c06a7ad2d93f82b8bf692efabf8f374f2d3706e"
    sha256 cellar: :any,                 sonoma:        "4d230ea0614872eb9f765d5ad75cebfe4a940794b84306abf87bf77c48ce52b6"
    sha256 cellar: :any,                 ventura:       "0b00fe78bd9847767966b12aadb1f66789edb318baa67b5a78fe1485fc2d01fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "829af47c8c79baddc6660ec6cf85b79b1eea6cfeef3cd4245dcafdccfd4b89ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e62daba2f3721ca392c8e47767987b5b865bd12d1100e63ca22baedcf037e73"
  end

  depends_on "cmake" => :build
  depends_on "libusb" # for HID support

  def install
    args = %w[
      -DVRPN_BUILD_CLIENTS=OFF
      -DVRPN_BUILD_JAVA=OFF
      -DVRPN_USE_WIIUSE=OFF
      -DVRPN_BUILD_PYTHON=OFF
      -DVRPN_BUILD_PYTHON_HANDCODED_3X=OFF
    ]

    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <vrpn_Analog.h>
      int main() {
        vrpn_Analog_Remote *analog = new vrpn_Analog_Remote("Tracker0@localhost");
        if (analog) {
          std::cout << "vrpn_Analog_Remote created successfully!" << std::endl;
          delete analog;
          return 0;
        }
        return 1;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lvrpn"
    system "./test"

    system bin/"vrpn_server", "-h"
  end
end
