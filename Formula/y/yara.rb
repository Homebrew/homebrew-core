class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.5.2.tar.gz"
  sha256 "1f87056fcb10ee361936ee7b0548444f7974612ebb0e681734d8de7df055d1ec"
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
    sha256 cellar: :any,                 arm64_sequoia:  "84235b67b3d1942ad369c7acb7d4277c495183b6b4d29dfca8d62382c3f33ebf"
    sha256 cellar: :any,                 arm64_sonoma:   "248c919c9b5c1cee57bfdf1880189b219b8973e235dca7b72241fcf53b3d2214"
    sha256 cellar: :any,                 arm64_ventura:  "8f98d50afba513f435ccfc80c01cfa1d79221a3fb8a5baf1fff506b5fc1f309a"
    sha256 cellar: :any,                 arm64_monterey: "807edb5a4f3cfe879ea08fa9a8bfc2a8a9b3b702ad9ff38e05862aa7b66e5efc"
    sha256 cellar: :any,                 sonoma:         "08745850a5902430099341798ccf146d61db89764d85d32d559b9bfd608f5868"
    sha256 cellar: :any,                 ventura:        "36b82987bed553aeff295abd55ee25469db18714cff30d504e49fe15d01c4294"
    sha256 cellar: :any,                 monterey:       "b8a993c8e96054b76a06e3c0f0248ea9b628ae2588f22c70d75a2c0a824036c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f94439dd9022c68397c7b3dee8de603e58a052fc5170d9674bcf57e9a74dd7"
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
