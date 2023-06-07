class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/v3.34-3197.tar.gz"
  sha256 "5e58f220063a5284080a612cc0f62e7f99329a1b2b1d5763f4b014b2578c95c2"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "539152d1b7f015ddaf46efed98990c652437539c746b931de18412c9f79f2c59"
    sha256 cellar: :any,                 arm64_monterey: "a2433af95c5bffba31a50b53b579ccb1323bba279d75fd768d4abb1ac4c8679c"
    sha256 cellar: :any,                 arm64_big_sur:  "e8c0466dbeb431fd9626007eb9e0b970dd544f1ca1fa36457ee1e78abb4044cf"
    sha256 cellar: :any,                 ventura:        "6da426602d463109f9c96b39b13c1abac0ed8dffd7a7c746ab6d8a7d64694737"
    sha256 cellar: :any,                 monterey:       "7d57277af59d9ade26a8abae82c62ca232489a619d4cbcf48638da92099f3e57"
    sha256 cellar: :any,                 big_sur:        "bb5f9489b2c88f405eafa158b772761ba38f57fc68c4deffeab3296dc1822b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "754bae1053aeaa551240815156ef0ab370a0b4715dc3f0ef8c43f6a99f6d93c0"
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
