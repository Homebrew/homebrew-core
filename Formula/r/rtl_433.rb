class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433.git",
      tag:      "23.11",
      revision: "59133f44a297eb2288e803e2e56587da4e586ffc"
  license "GPL-2.0-or-later"
  head "https://github.com/merbanan/rtl_433.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e55a0e0e62f174e25cc3f3d892a8e4dc9ef0b0adb6709cbc793b139b664e3a80"
    sha256 cellar: :any,                 arm64_ventura:  "d3f17a8874d3e02d2c1b0ba9b1a7ad230d1e78e087fd687eefdca3eced8e4fbd"
    sha256 cellar: :any,                 arm64_monterey: "4c809261d3dce9109ab94c05494e3412bde50eb0ba80c466365b72e8b6ead82a"
    sha256 cellar: :any,                 sonoma:         "0a6dd47bd2e165af9603fcdb175392969e73ee68893aa3dbc6f9fae6286c465b"
    sha256 cellar: :any,                 ventura:        "c803a214a219b58b1b3d00753177b81162da3dcbb26bcf20e02e9dfdb8874ff9"
    sha256 cellar: :any,                 monterey:       "72724b2b1486bb5253075d7af35b61f909d37630f0ab0c4362d6d12a50218a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2810378fa47bce1e015317722a6716f834558b98d963e3b92e07eb0ba5c9e161"
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
