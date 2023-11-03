class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433.git",
      tag:      "22.11",
      revision: "c3c58d81e72ec3d80af480a7c2ef7995ef66147f"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/merbanan/rtl_433.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e2d3ca4bd584899032e7a8fd1be121e0ea2b6568c3fb836734fad011f1d851a"
    sha256 cellar: :any,                 arm64_ventura:  "05b29053924008c6e7340fa5cba1c2b85fea2c1d5519fca6873a1c87aa28ba52"
    sha256 cellar: :any,                 arm64_monterey: "ad98368da38d15d4788a2b71c659935c32bc1302a2a758ce0a613d568591841f"
    sha256 cellar: :any,                 sonoma:         "780df13e28fe12ee535493e778425a536510183e46a885bd2caebd911b326046"
    sha256 cellar: :any,                 ventura:        "150d0bc219d0cb5ebd545c8d29ea8a60483d20d126cd27b2e01a56a71e502620"
    sha256 cellar: :any,                 monterey:       "86c2f53d0e571dc4cae49357409a05869281cc895ac6521629e9765969f7a81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a625e5879cff419e3cceddf801248084fbbdd55820786d5f82ea17bf6fcaf87"
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
