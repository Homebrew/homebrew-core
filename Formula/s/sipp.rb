class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp.git",
      tag:      "v3.7.7",
      revision: "369b3c187f0ff96f3ec9795650820e80cf17c776"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3e1fdb229aa351f03286bb7f0307bfbe3dcfbb3cd50682dc014fb4374ea440c"
    sha256 cellar: :any,                 arm64_sequoia: "c97d398015c63262071e4ef4d09d8db7e7c3650d5739d75dd4f478e869bb5e43"
    sha256 cellar: :any,                 arm64_sonoma:  "235ac951536505cb30c3afb724483e0b3e6937b05d781b26a6c506589af6cdc2"
    sha256 cellar: :any,                 sonoma:        "c1f171d277ff1e496f6ae2aa12b993748d2c753e8ca0f9f7313c491fd5052872"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d83356a09523afc89c2b77fb8eb86d63f19ae5e08cd6bad4fe3678a5b8c464a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b6070f03dc92b92d250606b5d3f0fbc60f5b842425dcfc5d477367ba5dc8bb"
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
