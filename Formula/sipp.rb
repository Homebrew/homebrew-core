class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.io/"
  url "https://github.com/SIPp/sipp.git",
      tag:      "v3.7.0",
      revision: "f9a4ba6cbae7a71a05df653289109b6f7d6d5d53"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bda23aafba064a9e42a33161a63eba4234919354a7fbf5103a4475366ff530a0"
    sha256 cellar: :any,                 arm64_monterey: "eb3c10cc445051067ef72a1ebb50002ce6dcafe26270ca9772a358b21f701842"
    sha256 cellar: :any,                 arm64_big_sur:  "83a6642a5189f023e7933d0600df2484d50cd952365e7bef5e9ab579ec644447"
    sha256 cellar: :any,                 ventura:        "ce0fec4c51d06ed4475d66431c96d83568673c5fc3d3a778bcdcd7910434bf19"
    sha256 cellar: :any,                 monterey:       "675ac77fb5d93f0c2e7b478e7aeb77968f24319ac62e2279050f5f1909a07f58"
    sha256 cellar: :any,                 big_sur:        "78147a91821b91d5e98a3a59ce93f261066e22fa7251c6a83b9bcec5665208d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bbd41293dcdbb58df19b7226abb6c23ab949593bc89c4f0bb65ab6545ccda0d"
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
