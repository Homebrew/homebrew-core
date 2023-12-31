class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.4.2.tar.gz"
  sha256 "fa9837b232b078357c1fba3d34992b05654ea2b9b55476c1ad336d8c96aac40e"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09c6cc16b40ab037efb30d3121d8c42bf1449c0b8b5ce6c63228f233db261bd6"
    sha256 cellar: :any,                 arm64_ventura:  "d0148d3d82ef603d5f1e09456d4e2b86df39f1cb5e4cf855b1cdad90092cd7de"
    sha256 cellar: :any,                 arm64_monterey: "0a59ba3fc61cd444c125da485ef05e78d0607fbd74a9b3738d2032ad448d34af"
    sha256 cellar: :any,                 sonoma:         "582557e73c264f6b13e0fb57e0bfa5b6587ba3c6d23bec509e69f0dcad3edcb9"
    sha256 cellar: :any,                 ventura:        "9ba7968f3d79c146a352343153646393ad18523bbc01c8529147a4bfa88f92f7"
    sha256 cellar: :any,                 monterey:       "6f24da683104280a4e9a841c7db992486abd4b6f9ab35905f5bc668aa07e6f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d02a31f5d64f2c65f45682d0ec7ace225f3b9889583860d18db3acf72feb5887"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@3"
  depends_on "pcsc-lite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_C_FLAGS=-I#{Formula["pcsc-lite"].opt_include}/PCSC"
      system "make", "install"
    end
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
