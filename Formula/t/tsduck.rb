class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.40-4165.tar.gz"
  sha256 "d499fd4571e3ebb6660de70b0ca3217423bf8d66b929e7bc0b92cfb6f01c9d04"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8811f4d35772f8d2f33d296e83dbfa5e0a871d4b3199d4eaca70f51c371b1397"
    sha256 cellar: :any,                 arm64_sonoma:  "0c00dae84b5fed39ea58cd7026d0fab834e06c0fa7ec6a1e291edb1af22c7d9b"
    sha256 cellar: :any,                 arm64_ventura: "51c022c41fea15c8aa592bc07a52134c3c06d0fd6363859cdd1b11586d8dba9d"
    sha256 cellar: :any,                 sonoma:        "86170581f6a47ae249719e20f1f6d6ae0c0790629e259645f19d0cd9969df73b"
    sha256 cellar: :any,                 ventura:       "b32c4b0d3949c9d4002c792ff62ef31a5e203437ddf06c42c3a196961ef38e93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aec04b863d8bf4caffbfeec47188e4d3dc4dcb142c89046c534c0a11df5aee38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef0a792b04b22c32b7d6fbacf6fe97f0f36ce8e5306a772db4fa4d8986e7105"
  end

  depends_on "asciidoctor" => :build
  depends_on "dos2unix" => :build
  depends_on "gnu-sed" => :build
  depends_on "grep" => :build
  depends_on "openjdk" => :build
  depends_on "qpdf" => :build
  depends_on "librist"
  depends_on "libvatek"
  depends_on "openssl@3"
  depends_on "srt"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "pcsc-lite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "bash" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1599
    depends_on "make" => :build
  end

  # Needs clang 16
  fails_with :clang do
    build 1599
    cause "Requires full C++20 support"
  end

  def install
    if OS.linux?
      ENV["LINUXBREW"] = "true"
      ENV["VATEK_CFLAGS"] = "-I#{Formula["libvatek"].opt_include}/vatek"
    end
    system "gmake", "NOGITHUB=1", "NOTEST=1"
    ENV.deparallelize
    system "gmake", "NOGITHUB=1", "NOTEST=1", "install", "SYSPREFIX=#{prefix}"
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
