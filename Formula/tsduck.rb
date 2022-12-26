class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/v3.32-2983.tar.gz"
  sha256 "2f0c35422a4f3e8876e9efa2683794336102fc225b826d5d3c4e033c4b666465"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b9ae0c79d4aa7ade081b2af21b553e05adf696ffbbaf56dbf772f0d1e822e383"
    sha256 cellar: :any,                 arm64_monterey: "e21b506dd4ce875c097fbe85b0b26533aca7eb77bed0b664dc26bb8bb982c1c9"
    sha256 cellar: :any,                 arm64_big_sur:  "87519f07414e36ebf73578f7ab9134a8ea3333b0e60d368e66d6ba44f90bab4b"
    sha256 cellar: :any,                 ventura:        "a2c29b7b08836bd168100f58c725a9f7e9edb69404ea691e51395bff233e9b99"
    sha256 cellar: :any,                 monterey:       "e9b07eb36903f4d25ce7a993f07cf0ceaef927a836558de8465de0c524576028"
    sha256 cellar: :any,                 big_sur:        "9385dd6cb930d3245e21027687adc155d49f10327c788078d8066eee764aef06"
    sha256 cellar: :any,                 catalina:       "9ef11f4ae882546ee3aab204ea4d5533a31ed304c1dfac91b7f8ce73d5abc4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81c98439b3a25f62fe71eff376ec017bc3705e263cd9ec9e4afae6165592f5f6"
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
