class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.41-4299.tar.gz"
  sha256 "1940946f5d15b9c1fea941e91d4685eb60cf4857a77f55eb3ad71d4e7e79ce65"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89caf54a4a8b3a60372e677578e3d075b8701fc1bd691a0025967a590ba87dba"
    sha256 cellar: :any,                 arm64_sonoma:  "a0fbaf64f98fe26a65e7ea920e9035adf3eed5aa637d04bdb652225191335fc4"
    sha256 cellar: :any,                 arm64_ventura: "e8e21c371612c8b33ee52e36e4bc96cf920fa28d64b7bbc91dff666be6b28233"
    sha256 cellar: :any,                 sonoma:        "43a5fb8c411c30631c67af3a1d2229906b426bac871a9f03dae988fd1d91f427"
    sha256 cellar: :any,                 ventura:       "7a2c6c741da948332d34dee8197d55dd27fb41439b97b00bed119c9086d708d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44021b8af87155ac7875e35893fd7b322b8c02ad44ff4d6eb7c61093f3a4876c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b249f7b5116a18bcb88e3930d3138450a1873c51f936b9211d7e7ba065d3c823"
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
