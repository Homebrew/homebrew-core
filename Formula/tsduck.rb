class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/v3.31-2761.tar.gz"
  sha256 "2e9e7956cd1b47b0b24666619fa0f1b27599eed6dc5f1457e1401679496f7562"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9fd69beedf1bfa47f5a0b20d6d195952d5d6923f16845addb1425da1e06b21ed"
    sha256 cellar: :any,                 arm64_big_sur:  "f962e717e1e37229879adf75c01b5c8c06515fe00a263c9028b9716bf787b462"
    sha256 cellar: :any,                 monterey:       "82e38cf2391edc858a6d212b0ca7afd41192fc2eeca55e7bdfed7d15f88acb1a"
    sha256 cellar: :any,                 big_sur:        "53f2e367f005a2daad65ffc1bd9003ea99fa76f0469ef0d028f17505f865e8a0"
    sha256 cellar: :any,                 catalina:       "dbbcac32f82480175582f2aa792ddf29d6c26626960becfe980a926fca81b8b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd8c52eb5f3d9b54e265596241d77f27b00b1152acdfe4f2b641e337eb5b1d1b"
  end

  depends_on "dos2unix" => :build
  depends_on "gnu-sed" => :build
  depends_on "grep" => :build
  depends_on "openjdk" => :build
  depends_on "librist"
  depends_on "srt"
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "pcsc-lite"

  def install
    ENV["LINUXBREW"] = "true" if OS.linux?
    system "make", "NOGITHUB=1", "NOTEST=1"
    ENV.deparallelize
    system "make", "NOGITHUB=1", "NOTEST=1", "install", "SYSPREFIX=#{prefix}"
  end

  test do
    assert_match "TSDuck - The MPEG Transport Stream Toolkit", shell_output("#{bin}/tsp --version 2>&1")
    input = shell_output("#{bin}/tsp --list=input 2>&1")
    %w[craft file hls http srt rist].each do |str|
      assert_match "#{str}:", input
    end
    output = shell_output("#{bin}/tsp --list=output 2>&1")
    %w[ip file hls srt rist].each do |str|
      assert_match "#{str}:", output
    end
    packet = shell_output("#{bin}/tsp --list=packet 2>&1")
    %w[fork tables analyze sdt timeshift nitscan].each do |str|
      assert_match "#{str}:", packet
    end
  end
end
