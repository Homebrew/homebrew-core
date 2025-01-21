class Rtl433 < Formula
  desc "Program to decode radio transmissions from devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433/archive/refs/tags/24.10.tar.gz"
  sha256 "e5ab1597a723bf9e0eaa56be988b23dae3670471c6472510ba07b3b588407dcb"
  license "GPL-2.0-or-later"
  head "https://github.com/merbanan/rtl_433.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32f8c90c98bff20b7f7a74bebc611fc3c3d917a1c19ee9a6558ed85d3338fdac"
    sha256 cellar: :any,                 arm64_sonoma:  "6c95bbf6fc2409649172688480da895fbc382128c7e98d613d02fb115dd6237f"
    sha256 cellar: :any,                 arm64_ventura: "58b0d9e8ac9e8959f4a7c99416ab07ee70027ac05edbb2e52dd0af4db90f8c8c"
    sha256 cellar: :any,                 sonoma:        "411281a288eec7b0b4210191aec08ba5cb8798eb5bad69f120f3d6f8faf28ae1"
    sha256 cellar: :any,                 ventura:       "2c2b71299c4dfaaf7a6f531d0d0532d77f3d45c821cfe25a054afd7814bfeb34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f45fedbaa73f2e0d800e6e64d52a209c4d242c9291ff82022907b915a542ed64"
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
