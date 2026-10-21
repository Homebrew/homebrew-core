class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp.git",
      tag:      "v3.8.0",
      revision: "c44a9fe5a5896665b2c6a19bfd6190e10a9144e2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c888ef82a35c0cb9006ecd149094084683b13b1ac20ea69e72b4b774d0add6dd"
    sha256 cellar: :any, arm64_tahoe:       "be899c91b751edf389701279a7aa772de6a3f9f476bc9df5039cb68f0c42da73"
    sha256 cellar: :any, arm64_sequoia:     "31c9d9ff93be8b3187b8c7459e1b37c187f1890ccca3cfa73fc0b8086bccc58d"
    sha256 cellar: :any, arm64_linux:       "940e47bbaa642ecbd8ebb147fd58fe344ea5a343d8dbed1e651b524d9796b245"
    sha256 cellar: :any, x86_64_linux:      "71b3732c7ab7fba10f3028025c1e9a384c3a19d606fb01efb3f1aa52c7ff72a0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "pugixml"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  deny_network_access!

  def install
    args = %w[
      -DUSE_PCAP=1
      -DUSE_SSL=1
      -DUSE_SYSTEM_PUGIXML=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end
