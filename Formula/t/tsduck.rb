class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.45-4798.tar.gz"
  sha256 "a35845430fff1385cf1cda9645bbfd0ec887ed440137fc6c26863c624c24eb63"
  license "BSD-2-Clause"
  revision 1
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
    sha256 cellar: :any, arm64_golden_gate: "00e75b5b3b3b6a5d9a38764c543f6cada103841dbbf9b88c080f22103e754762"
    sha256 cellar: :any, arm64_tahoe:       "951ddc68d24c793772712c6847893e0c52f9683efd52625acf47ce7da2a1da30"
    sha256 cellar: :any, arm64_sequoia:     "35aea7a0a6fa99a069412ec76871eb6a704c870526e580c615d5a698974a20a6"
    sha256 cellar: :any, arm64_linux:       "a24d0c99bf094e01725ac2d3099eee3d18fba1ca30de27723de8ca0937d022ac"
    sha256 cellar: :any, x86_64_linux:      "65f41991a89fdc867ceed4a3aad9f157478f49cad8f9d5f1ba41d5d4b9d16b34"
  end

  depends_on "asciidoctor" => :build
  depends_on "dos2unix" => :build
  depends_on "openjdk" => :build
  depends_on "qpdf" => :build
  depends_on "librist"
  depends_on "libvatek"
  depends_on "openssl@4"
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
