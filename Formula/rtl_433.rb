class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433.git",
      tag:      "21.05",
      revision: "87bf52426f9690c06ca8ad4c27993fcab4b5b643"
  license "GPL-2.0-or-later"
  head "https://github.com/merbanan/rtl_433.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "d6302d96e4450238a86db6d9cfe01b20841995aa622b881d5d085426716cbc5a"
    sha256 cellar: :any, arm64_big_sur:  "e6583ff3156f6862160b728a95b1fbb279c6f5a7dd2636200354596057050d15"
    sha256 cellar: :any, monterey:       "8f0177b866f24179f2cd19b2dd65add10a340ee70db253ea6443ea6ef4c3ca91"
    sha256 cellar: :any, big_sur:        "d9d81361c72f07d50c0f28552e15190fbcfc91fe862403511be883a72df3c744"
    sha256 cellar: :any, catalina:       "da1f6e7c5930ed4b98e34fb44d62dd1cefd22225366e35612688a74086afc38e"
    sha256 cellar: :any, mojave:         "421233496a91d2efb4310ac47557d7d4e75d91116dc829c20c96f36283f60d34"
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
