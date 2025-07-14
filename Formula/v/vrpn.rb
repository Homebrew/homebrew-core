class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  url "https://github.com/vrpn/vrpn.git",
      tag:      "v07.36",
      revision: "79deb000cc0b47ae49a80c92c78167c02d8a04d8"
  license "BSL-1.0"
  head "https://github.com/vrpn/vrpn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6df76cd24b9715b3cd44fba0da667b8d6999759e2da6a00c8ac1e5aaf5cdc7cc"
    sha256 cellar: :any,                 arm64_sonoma:  "96810647768b9f76928312becdbdf4566475faf3dfad67524d633e0f19456c35"
    sha256 cellar: :any,                 arm64_ventura: "e4cadc44e87394fa280711cb00ecb7b0363a63e459a3bec2604cb66dea4707e9"
    sha256 cellar: :any,                 sonoma:        "c07c530ba62053c232c91eaa9953b7ded4a7f874a88b57b591a9523afa4f43b7"
    sha256 cellar: :any,                 ventura:       "85bf1f7e010c6298a774fc915b12a27efbec8c511ba8afefd4fc2027a60c9fe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9973bb24a161a50bd8406bb48d97dfed0d9235c00b27d196b81e38841dd4d31d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b74a67ae4e340f4226650337b007bb94edbe27c751ccc83429120a4a91f37c"
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
