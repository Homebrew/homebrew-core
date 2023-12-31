class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.36-3528.tar.gz"
  sha256 "068ef1cbc60821a4cce8d50c876edef5150ad581b31f4a92f085e20b3becd0eb"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7731a93d9a8a7a205af037eacba7df9b169eed0f1c3b2c7d3dfbf399bbe2a650"
    sha256 cellar: :any,                 arm64_ventura:  "0808276113fea626a24176309f5e5be3e38710988a4638040a2f3ad4a6e461cf"
    sha256 cellar: :any,                 arm64_monterey: "f5659e4b2be4426016f80545fa362a81121dbd4d3a817d5103a30095b53955d3"
    sha256 cellar: :any,                 sonoma:         "f50aaef2233e9ed049447e2b6de943c920bd42d21d76e855e694a6e6822f7d19"
    sha256 cellar: :any,                 ventura:        "acc7d873d83bac8a480a129094c51ca5478d7e6ab4033ce769f2c373a3dafe51"
    sha256 cellar: :any,                 monterey:       "ad40708c601dff53c1606b9bb82fa93d483f4a847975a28ce4a5dced619bede7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c6dcdeb0963a57f6668dc1039ebe7bde2b06f6fc6c3bc52ac9e447beced6e57"
  end

  depends_on "dos2unix" => :build
  depends_on "gnu-sed" => :build
  depends_on "grep" => :build
  depends_on "openjdk" => :build
  depends_on "librist"
  depends_on "libvatek"
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
