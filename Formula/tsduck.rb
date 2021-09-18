class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/v3.28-2551.tar.gz"
  sha256 "ff39c9b97e17a5ae06556a119e24783427a86b1bb5ac75c7ba0340c7bd07d02d"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  depends_on "dos2unix" => :build
  depends_on "gnu-sed" => :build
  depends_on "grep" => :build
  depends_on "openjdk" => :build
  depends_on "librist"
  depends_on "pcsc-lite"
  depends_on "srt"

  def install
    system "make", "NOGITHUB=1", "NOTEST=1"
    system "make", "NOGITHUB=1", "NOTEST=1", "install", "SYSPREFIX=#{prefix}"
  end

  test do
    assert_match "TSDuck - The MPEG Transport Stream Toolkit", shell_output("#{bin}/tsp --version 2>&1")
    input = shell_output("#{bin}/tsp --list=input 2>&1")
    assert_match "craft:", input
    assert_match "file:", input
    assert_match "hls:", input
    assert_match "http:", input
    assert_match "srt:", input
    assert_match "rist:", input
    output = shell_output("#{bin}/tsp --list=output 2>&1")
    assert_match "ip:", output
    assert_match "file:", output
    assert_match "hls:", output
    assert_match "srt:", output
    assert_match "rist:", output
    packet = shell_output("#{bin}/tsp --list=packet 2>&1")
    assert_match "fork:", packet
    assert_match "tables:", packet
    assert_match "analyze:", packet
    assert_match "sdt:", packet
    assert_match "timeshift:", packet
    assert_match "nitscan:", packet
  end
end
