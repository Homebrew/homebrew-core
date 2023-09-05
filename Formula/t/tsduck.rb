class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/v3.35-3258.tar.gz"
  sha256 "7c28d04fad9ef8415dc02d56f377e5b2b4c3f173dcc9487a906ee73da38f4e41"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a0deb09a99bdc6cdfa3c9f0c4aa699583b4078cd40d1b2c2467d9af401d3468"
    sha256 cellar: :any,                 arm64_monterey: "5fbfd3ad644a55f629a5362f73e7b91f8ec9e1b9a75bd8a917efd90e34d5d4ba"
    sha256 cellar: :any,                 arm64_big_sur:  "8f7187549fa37f4b6e6917ef377f1536932c895efe43914955c4f5af32559546"
    sha256 cellar: :any,                 ventura:        "cafc935c1db3487f2c1c9a93433ee9dbed1cc5c34d5d84b24705d78b1eb4d7f0"
    sha256 cellar: :any,                 monterey:       "d6b9078e240bd7460bb9cddfc64789659d38ba5ddfba50c5f265e78d0d9748cf"
    sha256 cellar: :any,                 big_sur:        "1e1b5d3cb13135bd8d3dad274cc899291219335124fd223ea1a72fd331196c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82979de53cb002e265fb5991aeecc734f263b954808221b550435eec1aa1c37a"
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
