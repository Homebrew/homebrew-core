class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.42-4421.tar.gz"
  sha256 "4e8549967b25cbdc247c27297ef8bfa84a27f291553849fd721680c675822ec5"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5b623289b58ad333bbfb279db9871defd305d2811f219130d2868cfe86673851"
    sha256 cellar: :any,                 arm64_sequoia: "9327703566706a7077885bf1ed22c933cd4d82146e34f186c7b0eb5bff6add8e"
    sha256 cellar: :any,                 arm64_sonoma:  "8bedbd9dd8951b291c9556a957fd241102b0cfd418bd8ae3d893b9dc48e4c182"
    sha256 cellar: :any,                 arm64_ventura: "b9f894857c6bb01b382100d2451d475499e7d9ec5fa5d337d376a4a6ed17afd3"
    sha256 cellar: :any,                 sonoma:        "f45c7372512d9d368a4f2fbb5d1ec5e50d25d211f92922ed09f7b55b1c4067ac"
    sha256 cellar: :any,                 ventura:       "2abd61849397bf5683de519900ad7b4ae3a236eb63ca1b4040c094722db4d5ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95b6392d75893200f3ab0fa324a449c7f2f1e1f646ee0e3f434161d5239c21d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b603e585148b9d84984bb05e5bbfabf212396b6e1233c94fe9eabba7ff9fbee1"
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
