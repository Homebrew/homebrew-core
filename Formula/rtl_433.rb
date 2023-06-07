class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433.git",
      tag:      "22.11",
      revision: "c3c58d81e72ec3d80af480a7c2ef7995ef66147f"
  license "GPL-2.0-or-later"
  head "https://github.com/merbanan/rtl_433.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "19a48132d8edf108f3cbc10887b6f6191cbb532b01124e0c51014fcfa618c344"
    sha256 cellar: :any,                 arm64_monterey: "0bb06ae6847de3d39f757ede38bdb4d94c096fdd6791ffdba1642f2333446352"
    sha256 cellar: :any,                 arm64_big_sur:  "41c501152be6572eb632e56774d6f8ae0f3bd17536917f65eb73c35363d3e79a"
    sha256 cellar: :any,                 ventura:        "93746ebddd15ddbb43408492ad905f1f6fe4026da9e174bd55ba584e8194209d"
    sha256 cellar: :any,                 monterey:       "f1ae7ed5124e02d1f81fd74ab86a595d7d61c3449b977e453b8f025e6f5891ec"
    sha256 cellar: :any,                 big_sur:        "664c64a13ba1e4168db43e00b309a02434088a2b11e4ac0c118c1fa3ab2ec5a4"
    sha256 cellar: :any,                 catalina:       "bdf5a0193cadcc946e0a2efb1abf7104033943654ee041ccf6a77f7a381c8d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c11a299405a3547eb31ecbf1b1b3636bed85c11f6279d6bc45f1ce002d0fa4f3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "librtlsdr"
  depends_on "libusb"

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
