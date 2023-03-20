class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/v3.33-3139.tar.gz"
  sha256 "d7cdad9e46bf454cf7c952f23cd4b18f7690671ee8e0829d3a5da11db94b6201"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da0c2042f7be49006833ffd6e5fd07b10d1d94e1ea645483facc51e36aa040b2"
    sha256 cellar: :any,                 arm64_monterey: "cc1d820c8517ab555cfaa7838005bd1e5974d3ad31ea1e8f1a3f46bea9561a31"
    sha256 cellar: :any,                 arm64_big_sur:  "e9f02c10a9948e2383e34117f908df0da8ae982c028da7467d5563bb39f9127d"
    sha256 cellar: :any,                 ventura:        "23302fc9c3f7fcbf4d028e3b121a4ab46575a56a0b2f0528b7543be523c84aaf"
    sha256 cellar: :any,                 monterey:       "cce68285495e5c410e5c34eddd57ec29ad7d3cfc77bd0828ba6dd77d5379c93b"
    sha256 cellar: :any,                 big_sur:        "e4643b6374d773eb8427c64fd5ce322c24aa5197ff773b2af7bf554937dc4d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aadf7b413f62bde1dc2b9566cc8e5448b21fd1c4901a09bf3b597cbbbba5164"
  end

  depends_on "dos2unix" => :build
  depends_on "gnu-sed" => :build
  depends_on "grep" => :build
  depends_on "openjdk" => :build
  depends_on "python@3.11" => :build
  depends_on "librist"
  depends_on "libvatek"
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
