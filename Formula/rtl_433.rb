class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433.git",
      tag:      "21.12",
      revision: "5e44ab3eca0f44ff5fac96d3c22a470cd2f45097"
  license "GPL-2.0-or-later"
  head "https://github.com/merbanan/rtl_433.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "50d863bfb93b8186913082ae451ad42cd7cdc3b6d56e3a52ff3da031a56459fd"
    sha256 cellar: :any,                 arm64_big_sur:  "ed915afbe569d6802bd1c2ea70e04c25d3a05a97ff712af46f66e55c8158dbf5"
    sha256 cellar: :any,                 monterey:       "41da1507a5b0c5f7c91ea129c459cc77fa772c7f1f4f763c11ee00b1939ba0cd"
    sha256 cellar: :any,                 big_sur:        "0e4334269c387914888c2ae366ff784903dfadd9dd02b6c8507ac1b4202ff24c"
    sha256 cellar: :any,                 catalina:       "bb968856b95daef8e3880cc8b9ddad3384bff348b4ecc13db96998e0eb4a7a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f42cf7cdb9e8bd31e463a6ee3ad67dccf24d89bc1910fb226f39ba86d90b8cb"
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
