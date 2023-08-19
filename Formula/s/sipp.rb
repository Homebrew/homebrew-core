class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp.git",
      tag:      "v3.7.1",
      revision: "1126a8b27af21850a74b1f17b9c9af5c6c8d4309"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8786cc5adcbe5899275b7cc504decd96a0df83729b39f24da584c326b3fd3f2"
    sha256 cellar: :any,                 arm64_monterey: "3ab4877a57f6b5260db98d4b912a864e934420f5c1d3ec29a3ee96cd2b028124"
    sha256 cellar: :any,                 arm64_big_sur:  "051f4ddf73a816d0ec591d0122b2e8dda508118e2130eb2b8d16da5d4ed2a2aa"
    sha256 cellar: :any,                 ventura:        "faa45e7690f37061b2c21bc1d43c81756eeeceeec6067bb0466fccc8a0e9be30"
    sha256 cellar: :any,                 monterey:       "c5d4946eb77659974a47635e096c83eab1f09aed85929bf76da9d1ff75eaafce"
    sha256 cellar: :any,                 big_sur:        "3d52c34248ff03fccd8099c47c6cb962f454142a126ab5dca063a7572c2c5a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa40e901e3d6e0301beb526ae94849cc185b1d53eccfe6a3a532adb0d32ad3b9"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    args = %w[
      -DUSE_PCAP=1
      -DUSE_SSL=1
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end
