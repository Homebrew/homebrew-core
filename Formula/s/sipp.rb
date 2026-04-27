class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp.git",
      tag:      "v3.7.7",
      revision: "369b3c187f0ff96f3ec9795650820e80cf17c776"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04a868199a774e7dffbb6974c523173aeb1a70c6319ac081b07d21ffa095b79c"
    sha256 cellar: :any,                 arm64_sequoia: "07b010ab115ed3dbea66d4c6e9eaa4ab2b11a681291e626f0f1a5ca1a94bb3c6"
    sha256 cellar: :any,                 arm64_sonoma:  "372ad9aa6622667c1808a5b8a0ecf09e4246689189ec8b94f809a414c36f0d68"
    sha256 cellar: :any,                 sonoma:        "7ca2fd99cf19d1248849f4e4c9e58d133d07cc7632c896bce1a9eb0073a85e6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6733f16449a1f4d3b4e95112ac9b47af384eb498263e837a7c96c2c8fac00564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55afaac7579d5bd70e414a66ec9e753c202d168abbe1d5ca295616c416586db0"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

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
