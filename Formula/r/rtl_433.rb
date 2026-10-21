class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433/archive/refs/tags/25.12.tar.gz"
  sha256 "d283ec7a41a02d398e8918b20b65df3bf684cf4478371830662004005dadcdd2"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/merbanan/rtl_433.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cb63d1d4051c9c289f24a7f5c3484101836207eb2bceb5f28501682b8ff5bbc8"
    sha256 cellar: :any, arm64_tahoe:       "60d880ae9575f44dc53d72ca05f666863b2dc87853ba74b14d4105dc3d56b1bc"
    sha256 cellar: :any, arm64_sequoia:     "8b80046bfd0a6375b3a13e6955fed7c8acadd67e56a5a9c790ca634b0aaffb3d"
    sha256 cellar: :any, arm64_linux:       "20749caddb277e63d473978de1839f542cd40bc3ee4f4f2156f535894a39dc19"
    sha256 cellar: :any, x86_64_linux:      "a8987509422dc19f9cb1389816d3ddc8699af63c8864f3f2c4416ef0a38bec6d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "librtlsdr"
  depends_on "libusb"
  depends_on "openssl@4"

  resource "homebrew-test_cu8", :test do
    url "https://raw.githubusercontent.com/merbanan/rtl_433_tests/038234077f4d8b9022759430da1154d2c3631344/tests/oregon_scientific/uvr128/g001_433.92M_250k.cu8"
    sha256 "7aa07b72cec9926f463410cda6056eb2411ac9e76006ba4917a0527492c5f65d"
  end

  # Test needs to download resources
  allow_network_access! :test

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("homebrew-test_cu8")

    # Check following if test fails on new release
    # https://github.com/merbanan/rtl_433_tests/blame/master/tests/oregon_scientific/uvr128/g001_433.92M_250k.json
    expected = {
      "time"       => "@0.156680s",
      "model"      => "Oregon-UVR128",
      "id"         => 150,
      "uvi"        => 0.000,
      "battery_ok" => 1,
    }

    output = shell_output("#{bin}/rtl_433 -c 0 -F json -r #{testpath}/g001_433.92M_250k.cu8")
    assert_equal expected, JSON.parse(output.chomp)
  end
end
