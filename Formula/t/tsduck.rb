class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.45-4798.tar.gz"
  sha256 "a35845430fff1385cf1cda9645bbfd0ec887ed440137fc6c26863c624c24eb63"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c938b5f8195505dcd8ad78dc3956d5927a44d6119dbf118f2140d834e2e88de3"
    sha256 cellar: :any, arm64_tahoe:       "d145541c72fc01e95d001cca4b81387df0dc79dac884e6a07cbc78873b413300"
    sha256 cellar: :any, arm64_sequoia:     "e52ee946ecfcce14bc3e98aaad40baf4d30a59ec14128f8cfe2499e5856226f0"
    sha256 cellar: :any, arm64_linux:       "66bf97928952b7c2f3b7585c9f61c5e52efa7cb72dd4c788aea856c3238825d1"
    sha256 cellar: :any, x86_64_linux:      "42a344adbaa5ce21fa8ade216c2ab0573c119c6403b5e91abb84cb72cb623a20"
  end

  depends_on "asciidoctor" => :build
  depends_on "dos2unix" => :build
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

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1599
    depends_on "make" => :build # needs make 4+
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Needs clang 16
  fails_with :clang do
    build 1599
    cause "Requires full C++20 support"
  end

  def install
    if OS.linux?
      ENV["LINUXBREW"] = "true"
      ENV["VATEK_CFLAGS"] = "-I#{formula_opt_include("libvatek")}/vatek"
    else
      ENV["LDFLAGS_EXTRA"] = "-Wl,-rpath,#{rpath(source: lib/"tsduck")}"
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
