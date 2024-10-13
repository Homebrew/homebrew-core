class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  url "https://github.com/vrpn/vrpn/releases/download/version_07.35/vrpn_07.35.zip"
  sha256 "06b74a40b0fb215d4238148517705d0075235823c0941154d14dd660ba25af19"
  license "BSL-1.0"
  head "https://github.com/vrpn/vrpn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "75a13c37fad4a005e8308fadcc7a98f75e9147f73fafe7c2f73709e4c3156b48"
    sha256 cellar: :any,                 arm64_sonoma:   "761817673c366cc4107359c8da2ad4d98c0b0baba8a804ac58f30d56a5ed81bc"
    sha256 cellar: :any,                 arm64_ventura:  "30798e598e05078f5ce75ca7451df08ccef3810848f61f6870a440c802c2008f"
    sha256 cellar: :any,                 arm64_monterey: "e16ae039e897123feecad339bba4ebdb34773a30924ac0046e5785c86c37e243"
    sha256 cellar: :any,                 arm64_big_sur:  "7937578e438051b79f3270c6fbcd9025d1f4cf42785aa04d72d2c4d245733fa3"
    sha256 cellar: :any,                 sonoma:         "bcbf18043a42516374d9c6aedb11ea725bf7f8338cfb99cecb554191588e3fa0"
    sha256 cellar: :any,                 ventura:        "7ad5e83677486dc1cee37c5a2a80c599f9065780af1a7c0660ecbac0fa000bd4"
    sha256 cellar: :any,                 monterey:       "2b172896f3d3c3103643f4d7ded96c1302730677741ee3db5b2cd1d94a65d4b0"
    sha256 cellar: :any,                 big_sur:        "994b39680e7cb653839053a76ad471e29b1fefbce14a9bbf5434d9de8625732d"
    sha256 cellar: :any,                 catalina:       "c3fb15bbfbde5f246e3776cde0489227836a695bef07a7a25cc928f2e28a935b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f1717e1d29898fb06c95d84c99c1beee02403f6e64f9617569e08e358abbbb"
  end

  depends_on "cmake" => :build
  depends_on "libusb" # for HID support

  def install
    args = %w[
      -DVRPN_BUILD_CLIENTS=OFF
      -DVRPN_BUILD_JAVA=OFF
      -DVRPN_USE_WIIUSE=OFF
    ]

    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lvrpn"
    system "./test"

    system bin/"vrpn_server", "-h"
  end
end
