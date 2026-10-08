class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://virustotal.github.io/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.5.8.tar.gz"
  sha256 "c322414975ff6f701149856613afdcd92a7e6939c284c798ae3c85618197efaa"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "51df3217fe9a17bb3a09e92b5171ec7a6998fa181e040b260ae114efb04aefb6"
    sha256 cellar: :any, arm64_tahoe:       "425786155fe950576f98141fd741b9ea57ca99eb5660bb8d1c82fb7cb0be7a19"
    sha256 cellar: :any, arm64_sequoia:     "8416d2d07809944a3eead36973a52fc68f61c0c0fb8fdc2ad50c88bef92ff161"
    sha256 cellar: :any, arm64_linux:       "23208ac743de606132845fb6a16be5dacd19e9a2a6fe8c1e0d2f33c1858a90e6"
    sha256 cellar: :any, x86_64_linux:      "2ecfe93de3109b8a8982dd671022a5dc8596fcad66473e28b9fbf6a170b94311"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@4"
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
