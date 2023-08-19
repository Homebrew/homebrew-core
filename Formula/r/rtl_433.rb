class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433.git",
      tag:      "22.11",
      revision: "c3c58d81e72ec3d80af480a7c2ef7995ef66147f"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/merbanan/rtl_433.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2567ae5b1e95bbe323493563c57f9214c01d2ed23aa3fddca341386bdb22869"
    sha256 cellar: :any,                 arm64_monterey: "29bf211dc690fec048e76155bb10a518e7319d4dc1ebbbd191a915f07fdbf943"
    sha256 cellar: :any,                 arm64_big_sur:  "e89d9e40b7b637abe061f1d302105efc08e403fb5d24b682660fde4d1890bd18"
    sha256 cellar: :any,                 ventura:        "bae66790200f8ba134f7f80984f5a6a4b0c5e8677db0dfe903854cfe3cc25e63"
    sha256 cellar: :any,                 monterey:       "21302023e56d72a5ab3c85cad90d17d6d9cf5827a2afdbb69991b37c778d7d38"
    sha256 cellar: :any,                 big_sur:        "ac70a060db70e27692b7e480d1dab3e8f5f52dbde2d681f7c49c7211c81bed9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "692e370f6028edeb4ad904df1404e28e33d450925a8510a35f7b2f71501472f0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "librtlsdr"
  depends_on "libusb"
  depends_on "openssl@3"

  resource("test_cu8") do
    url "https://raw.githubusercontent.com/merbanan/rtl_433_tests/master/tests/oregon_scientific/uvr128/g001_433.92M_250k.cu8"
    sha256 "7aa07b72cec9926f463410cda6056eb2411ac9e76006ba4917a0527492c5f65d"
  end

  resource("expected_json") do
    url "https://raw.githubusercontent.com/merbanan/rtl_433_tests/master/tests/oregon_scientific/uvr128/g001_433.92M_250k.json"
    sha256 "5054c0f322030dd1ee3ca78261b64e691da832900a2c6e4d13cc22f0fbbfbbfa"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("test_cu8").stage testpath
    resource("expected_json").stage testpath

    expected_output = (testpath/"g001_433.92M_250k.json").read
    rtl_433_output = shell_output("#{bin}/rtl_433 -c 0 -F json -r #{testpath}/g001_433.92M_250k.cu8")

    assert_equal rtl_433_output, expected_output
  end
end
