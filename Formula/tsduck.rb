class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/v3.30-2710.tar.gz"
  sha256 "a6548f42aa99ebf5987407599ed50207d743431a5fb54497717963ddad37c0d2"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9ec1e5f997e4eb25ec06afb82ab63e2432f9c9447e137b19b8e917ace3b2c45d"
    sha256 cellar: :any,                 arm64_big_sur:  "dbc7d0adf937f25546fc75e8b6de4bbc22c5d6e320057d97f7555fe60a4a3b77"
    sha256 cellar: :any,                 monterey:       "1e89bc9d10a66f91ae366aac6478aa3a32f4de34a03d2a8f4e258c5d957209b1"
    sha256 cellar: :any,                 big_sur:        "ad71d55789e1abf6cd217fb5f368ee30a7f5f09bf097fdc1a6907805fa464c33"
    sha256 cellar: :any,                 catalina:       "f07b18b389227bc0de5d453dfa0daa5de610ab83b57c00c944e74bdc4edd0905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5714f9e0a9b698841f0c4958fc6cadef496b1bdcb4574105ed716802dadc089c"
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
