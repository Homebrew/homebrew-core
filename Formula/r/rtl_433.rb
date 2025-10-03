class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https://github.com/merbanan/rtl_433"
  license "GPL-2.0-or-later"
  head "https://github.com/merbanan/rtl_433.git", branch: "master"

  stable do
    url "https://github.com/merbanan/rtl_433/archive/refs/tags/25.02.tar.gz"
    sha256 "5a409ea10e6d3d7d4aa5ea91d2d6cc92ebb2d730eb229c7b37ade65458223432"

    # Fix build with CMake 4.0+.
    # Remove with `stable` block on next release.
    patch do
      url "https://github.com/merbanan/rtl_433/commit/42ac641452aa56afa04f7bad5a55f790ee639852.patch?full_index=1"
      sha256 "7e93f6021b80a8e21e637f1be1f7239ca608887b69685781a2e5afcf38bb342d"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9393179910f0f9f4fef924aadd7862b5ed72850d44dff3c4867b6da289fdd333"
    sha256 cellar: :any,                 arm64_sequoia: "cadc9ac43692b5342a8d9fd305bf36598ce8e8f9cbcf088f3b87e7117f569f4c"
    sha256 cellar: :any,                 arm64_sonoma:  "6e8b6406520ac6b02a6d5292ed085c377edc6214dd817e27850a91d1216883b0"
    sha256 cellar: :any,                 arm64_ventura: "ed54be9e72784603e4e6b1b7b1ae679f15ab03cf1ee92efa7c36151b40b81274"
    sha256 cellar: :any,                 sonoma:        "9ba535a042f8ea9bb058ae0b78ed860f4a3157ff228b68c2b5dbe7bd9eea8d2e"
    sha256 cellar: :any,                 ventura:       "e5165eebfca6801f1c588fac131f5b054d37974adc912fc6aead1286e60629f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9381d5020fae59f1a79333b3e52429ed1486b105fa8f7fea786c464724006bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bb83d5f1303cc5aa8dd4d79d7609f0fc9c2ec1d530584a7c7e6648fdd4d0a42"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "librtlsdr"
  depends_on "libusb"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_cu8" do
      url "https://raw.githubusercontent.com/merbanan/rtl_433_tests/master/tests/oregon_scientific/uvr128/g001_433.92M_250k.cu8"
      sha256 "7aa07b72cec9926f463410cda6056eb2411ac9e76006ba4917a0527492c5f65d"
    end

    resource "homebrew-expected_json" do
      url "https://raw.githubusercontent.com/merbanan/rtl_433_tests/master/tests/oregon_scientific/uvr128/g001_433.92M_250k.json"
      sha256 "5054c0f322030dd1ee3ca78261b64e691da832900a2c6e4d13cc22f0fbbfbbfa"
    end

    testpath.install resource("homebrew-test_cu8")
    testpath.install resource("homebrew-expected_json")

    expected_output = (testpath/"g001_433.92M_250k.json").read
    rtl_433_output = shell_output("#{bin}/rtl_433 -c 0 -F json -r #{testpath}/g001_433.92M_250k.cu8")

    assert_equal rtl_433_output, expected_output
  end
end
