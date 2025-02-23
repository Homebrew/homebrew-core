class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.40-4165.tar.gz"
  sha256 "d499fd4571e3ebb6660de70b0ca3217423bf8d66b929e7bc0b92cfb6f01c9d04"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "85fcccc144054ae42b8e3fc935b61a17f3de645bebbdf937f27b4b844fcbea1e"
    sha256 cellar: :any,                 arm64_sonoma:  "d6971736a613a09dc3ff5d4b6c2596f448e4430ce704c7ab4f31480a32c2821a"
    sha256 cellar: :any,                 arm64_ventura: "bb3a3198574de64b13c459858e3d9e4a0bd5c4df853d77c2a871cfb68891f010"
    sha256 cellar: :any,                 sonoma:        "49de30577f310a4f960c8edf64e33f1313cf40171e7e60a602d50d1f68ac0bdf"
    sha256 cellar: :any,                 ventura:       "18819fa81eaebdf055ab92176acb3e06962969e1efb12bd522aea05a45303f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27c7b137281536685aad911ccab6fe3dd99aa6fbea5d65e4b286d340d7446b5c"
  end

  head do
    url "https://github.com/tsduck/tsduck.git", branch: "master"

    # will be needed for the next release
    uses_from_macos "zlib"
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

  on_macos do
    depends_on "bash" => :build
    depends_on "make" => :build
  end

  def install
    ENV["LINUXBREW"] = "true" if OS.linux?
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
