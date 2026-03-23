class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433/archive/refs/tags/25.12.tar.gz"
  sha256 "d283ec7a41a02d398e8918b20b65df3bf684cf4478371830662004005dadcdd2"
  license "GPL-2.0-or-later"
  head "https://github.com/merbanan/rtl_433.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22b43f0eb2c9899189e3c33d8bf75164d21b7165a7f31abad2067553df8a7a0f"
    sha256 cellar: :any,                 arm64_sequoia: "c7d29dd8afb14227875759650c7ec1166462b452d9aa3f9749a354c050267d71"
    sha256 cellar: :any,                 arm64_sonoma:  "b426f76e5b9664a781f6e80fa2fbfbb2178226343f10a635b1f78381759d1069"
    sha256 cellar: :any,                 sonoma:        "922beeb4abc104f5e5b653ff83fca1412006b1debbab210a3013454f1e70fcbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dba0bb785442b49492e69176003117025384dbea6e71e782c0138fdcde6abcfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4871e6bb7ec1b56935a8f99accef274a29bc2f90c9b2e7f54d06de9f1197073"
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
      sha256 "08637818a2a268da4862bdb98c62a3afc9a4a0d751230451abbeacd47f58860c"
    end

    testpath.install resource("homebrew-test_cu8")
    testpath.install resource("homebrew-expected_json")

    expected_output = (testpath/"g001_433.92M_250k.json").read
    rtl_433_output = shell_output("#{bin}/rtl_433 -c 0 -F json -r #{testpath}/g001_433.92M_250k.cu8")

    assert_equal rtl_433_output, expected_output
  end
end
