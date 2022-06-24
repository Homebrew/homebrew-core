class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/v3.31-2761.tar.gz"
  sha256 "2e9e7956cd1b47b0b24666619fa0f1b27599eed6dc5f1457e1401679496f7562"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "354075df1dd3899aa58484f1960b890aabf6855ca11a7c1e83e80b4bf80334ea"
    sha256 cellar: :any,                 arm64_big_sur:  "17ad8a709f3900d44778c55812402c2f8259febe2fe58b211627d8236fabf1be"
    sha256 cellar: :any,                 monterey:       "de9ff76ef9277c330423cc2310e786b4cb88fe7471c561e0fafcb68da2fed02f"
    sha256 cellar: :any,                 big_sur:        "e24faf98cd388c66aeb2a5fe6c233670e69caec6212e18c58d6b49f4d59ba1e3"
    sha256 cellar: :any,                 catalina:       "8ad9faded659e822cadf3e53314648820e3b9140ed64cb33658aceb4214a5861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f4622cee92614b48eaf870612c374582f52346f5e1c32eded274a5935ff9c2a"
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
