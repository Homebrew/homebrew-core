class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://virustotal.github.io/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.5.8.tar.gz"
  sha256 "c322414975ff6f701149856613afdcd92a7e6939c284c798ae3c85618197efaa"
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
    sha256 cellar: :any, arm64_tahoe:   "80ded2d2c86e1965afd2c4eba62f9b523bb1c43c52c0b457f32caf8aa3b2e219"
    sha256 cellar: :any, arm64_sequoia: "927bd2eb002d26487d2b0dbd9b8aeff3e70e6ba1c7f538d645f38b729b0f48d4"
    sha256 cellar: :any, arm64_sonoma:  "3354f8c1e306db901a5221bfadd8f7866d08902d6ed3f29839d074f575276629"
    sha256 cellar: :any, sonoma:        "c5ab41d7df224f7d8431826a1cac0a67885b9f7b0bae46e1923ac12591d98dd2"
    sha256 cellar: :any, arm64_linux:   "6d3e0841ae01c788fd8e58226aa10aab09bcaaaec5a993600e2070c334644406"
    sha256 cellar: :any, x86_64_linux:  "841e62a7d14767c5228c82a65c8873e5be5668b9525579c35571d16fe2214a3d"
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
