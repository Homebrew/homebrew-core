class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "f64538279c018bcf7cda368c51b9c660556108ab2e7eb24de043738df2271d92"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41098827bb8f533733e1b53f3abb7a5adf85d14969dc59f47141099ebd101285"
    sha256 cellar: :any,                 arm64_monterey: "9f7f659cbc48f2aa5845da712bc46438f2fdfc5cbf48b3677c83a72311464f3c"
    sha256 cellar: :any,                 arm64_big_sur:  "f1f39e8a513a51f9b033a465c8f4f4773c91e7950a30c051a2fa248a018ae9b8"
    sha256 cellar: :any,                 ventura:        "577cb028da6f08bd6e166f558100a3c6fad41922103062cfa6c6f3963923e9cc"
    sha256 cellar: :any,                 monterey:       "9b4dd56c3741b021cd9f2b23b5a8cb5f84893c2cdc38fc3dd0a55a8949ff7ec5"
    sha256 cellar: :any,                 big_sur:        "e54858cd983f911dcd7b05a63a8ad1613e538e1661f20b8bdf19b010761a6217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d79d82b783c86bb08ba2ffd83f42e7936256b0f0bd1454b94351941e3d755f79"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@1.1"
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
          description = "Calls CBM KERNAL routine CHROUT"
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
