class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/v3.29-2651.tar.gz"
  sha256 "cab8f5838993aa1abd1a6a4c2ef7f2afba801da02a4001904f3f5ba5c5fe85a0"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba626578a795195ab1a610d896648cdd544711596c1d900726b16e671644f8d8"
    sha256 cellar: :any,                 arm64_big_sur:  "f7d79b8d3da117459e4dad007c27d48ddd7b32b6c81e4e07c26d04b4695da88b"
    sha256 cellar: :any,                 monterey:       "f7b4fc39da4a2d69b190829426e62bd7c5415d9419e3c28ec434dd94f1a68350"
    sha256 cellar: :any,                 big_sur:        "58b15df049434efe28d2c01f36af3474a08db0859be41685ec897ae0c9dce246"
    sha256 cellar: :any,                 catalina:       "ba74f5dd825ad36ab54e274971e64723ee571e93a6e3cd81d3fa1f01093b3ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82200750cbc0fe3c6201fee8716b80bfe381e376bcb929d5b0ee764cd6e5fdfa"
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
