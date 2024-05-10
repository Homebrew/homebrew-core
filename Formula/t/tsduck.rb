class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.37-3670.tar.gz"
  sha256 "dbb7c654330108c509f2d8a97fe0346e3a1f55ad959e13dcee4a40dd04507886"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "16e834c1f04b5645d51f215e4f40640a80018a014b1185330ef0cf66d0c6dee1"
    sha256 cellar: :any,                 arm64_ventura:  "f003ac2228dfcdaf77324ceee4d1faa45a78a8aeed3a640404c38674da6661ce"
    sha256 cellar: :any,                 arm64_monterey: "c2c8ccf8fa031f9504aab5928fa09f1543843ba8e739a5802593f757dfdaf7ed"
    sha256 cellar: :any,                 sonoma:         "1642c6d9bed6f47ac1001a7c798120e0428ba307e79fa607580183c5d4994fdb"
    sha256 cellar: :any,                 ventura:        "3a3b3dd3b7e3b14172ea736280ec2e2802109ad8f1e0f6e769ba6f3f4eda6501"
    sha256 cellar: :any,                 monterey:       "fe7bb580dd6b5731487427b56762a246969c0ae013bf0bebd1f64cca2c316fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d79b6b81e69a6b9ff7059eeecc0a54bddc467dfa9168b413cdd9bd66a81600d"
  end

  depends_on "dos2unix" => :build
  depends_on "gnu-sed" => :build
  depends_on "grep" => :build
  depends_on "openjdk" => :build
  depends_on "librist"
  depends_on "libvatek"
  depends_on "openssl@3"
  depends_on "srt"

  uses_from_macos "python" => :build
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
