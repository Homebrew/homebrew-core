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
  uses_from_macos "curl"

  def install
    system "make", "NOGITHUB=1", "NOTEST=1" if OS.mac?
    system "make", "NOGITHUB=1", "NOTEST=1", "install", "SYSPREFIX=#{prefix}" if OS.mac?
    system "make", "-C", "src/utils", "install", "SYSPREFIX=#{prefix}" if OS.linux?
  end

  test do
    on_macos do
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
    on_linux do
      assert_match ".so", shell_output("#{bin}/tsconfig --so")
    end
  end
end
