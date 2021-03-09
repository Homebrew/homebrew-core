class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433.git",
      tag:      "20.11",
      revision: "0bb4672b1afb716d107b3060afc2d80a2159dbef"
  license "GPL-2.0-or-later"
  head "https://github.com/merbanan/rtl_433.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8cad78e933133a7488445c11a33047b4ea33d7ff5518ca5ec6c3080d847f75f5"
    sha256 cellar: :any, big_sur:       "9c1f16a45e2527a266e94c5e6885edb47e8b1e11a72672488e19a323f664dd93"
    sha256 cellar: :any, catalina:      "90bd9710694e5dea8a4847db255bd27b62310af0c207b19125728b9402707bfe"
    sha256 cellar: :any, mojave:        "785f8aa3ea271d615a5a89e440aac3ee4ab3f0312ddf88576f389cc4eec57889"
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
