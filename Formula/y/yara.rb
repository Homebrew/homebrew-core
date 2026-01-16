class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.5.5.tar.gz"
  sha256 "d38e30fd9c1e1c7921d1c4568262d94f5c2d6b5da139fe49572a43ffbc5c53f6"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f50c08d6d468502fb468d9401c8087a31ed6e2193b518d9f2497e5306dac3df5"
    sha256 cellar: :any,                 arm64_sequoia: "bed2c8becb6623fc30f867d7399b9b1c8847a0ec40c740cf041ed99adc249aa0"
    sha256 cellar: :any,                 arm64_sonoma:  "320fd862a8a32c5ad2ed2b58c6db1dba4ff1869cab0b9f5b0998a1d8b255c4e7"
    sha256 cellar: :any,                 sonoma:        "df647efb738f895f459dce114d2f5cd2add6b0013ef1b754256fcd695064ed1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd2508d80b2e65d4e31548677fc7376e225498b09928b1ef3938bc08fc39f801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b76a81e19bf1ca4a3f073e9c1811107b61b341e4d3bbd7ed2002cbb9c106c13c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@3"
  depends_on "protobuf-c"

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
