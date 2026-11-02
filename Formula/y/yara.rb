class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://virustotal.github.io/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "61ab80084e3f83e1b73a95057058e2ae1db5f87f291e32654e191d410297f0e5"
  license "BSD-3-Clause"
  compatibility_version 2
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0b6a8506b19961ad592de58a159e7536f342f0757ab571b70f8d55ae682b2b67"
    sha256 cellar: :any, arm64_tahoe:       "006d93d63ba1ebbcdd7847324807e228d7af5f7b92fdfc65b4a24ac8ce474a75"
    sha256 cellar: :any, arm64_sequoia:     "04400495022f7b652a9106d68b11a4e3cdd0bca047d88bcea5836c07009d61b2"
    sha256 cellar: :any, arm64_linux:       "533a98575a135a89f9eb17fcb948227411754ff33cf5cbfac512d943d431e24d"
    sha256 cellar: :any, x86_64_linux:      "d835f34553f142ef6bf31c5192be2841095905fccf44b78e0ab2a038d50c5c3c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@4"
  depends_on "protobuf-c"

  deny_network_access!

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-dotnet",
                          "--enable-cuckoo",
                          "--enable-magic",
                          "--enable-macho",
                          "--enable-dex",
                          "--with-crypto",
                          *std_configure_args
    system "make", "install"
  end

  test do
    rules = testpath/"commodore.yara"
    rules.write <<~YARA
      rule chrout {
        meta:
          description = "Calls CBM KERNEL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    YARA

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal "chrout #{program}", shell_output("#{bin}/yara #{rules} #{program}").strip
  end
end
