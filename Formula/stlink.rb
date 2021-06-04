class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/v1.7.0.tar.gz"
  sha256 "57ec1214905aedf59bee7f70ddff02316f64fa9ba5a9b6a3a64952edc5b65855"
  license "BSD-3-Clause"
  head "https://github.com/texane/stlink.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "79683924dac821a1744cf32a96c3296eecd1668b5f2f64dbdcf570f32480459f"
    sha256 cellar: :any, big_sur:       "9ea7be4ae1c0b91ceeb40c6df9d07ad6a5660be80043895bcf29acc47988d10d"
    sha256 cellar: :any, catalina:      "e162fb37d4a7e2a0e006c5cb9beae3b86784d6a0b3d371fc33d7ed9ba2140083"
    sha256 cellar: :any, mojave:        "f112f45203b8c460da03ae840529d4564a677d0621ac0a9576bac510258a9ef5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "st-flash #{version}", shell_output("#{bin}/st-flash --debug reset 2>&1", 255)
  end
end
