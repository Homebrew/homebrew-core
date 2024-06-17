class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "011b95f903d8fc22de50aa1e3c1bf4ed598dbde6f9ea45176945cec5520452dc"
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
    sha256 cellar: :any,                 arm64_sonoma:   "85bbf19accd4d89b9257f519cf958b42cab87ce977616902c97e5ca792f62027"
    sha256 cellar: :any,                 arm64_ventura:  "368305ff98f818698c836251fdc319df5ac417a7ba98e3fc1d71ea5f17e6890e"
    sha256 cellar: :any,                 arm64_monterey: "49e5a53ccfe4701008c08203a743f33927ba1b046cd26a8a4ff2041308b9872e"
    sha256 cellar: :any,                 sonoma:         "411a7e8abdee4e3721a28f9e48266d3496032b80aeacf715185faed3e9d2ff3a"
    sha256 cellar: :any,                 ventura:        "435be6eff0719c46b81f61821759fe444c55a8010bd4024f9cc72a06edab437b"
    sha256 cellar: :any,                 monterey:       "1bb42f5a5015d7e83eddd3524edc65af0224c6932c7dc4115b885208d442b215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d316b1cbf9a8ed2fe6493a541f2c591310a07a1f88d7217295f8b6af621945"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-dotnet",
                          "--enable-cuckoo",
                          "--enable-magic",
                          "--enable-macho",
                          "--enable-dex",
                          "--with-crypto"
    system "make", "install"
  end

  test do
    rules = testpath/"commodore.yara"
    rules.write <<~EOS
      rule chrout {
        meta:
          description = "Calls CBM KERNEL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    EOS

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal "chrout #{program}", shell_output("#{bin}/yara #{rules} #{program}").strip
  end
end
