class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "f26d9c481e6789181431ac410665f6ba25d551c2948995f84c9e17df7a93731a"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7e84b22d34265f106d7e19f6d0388272a6b5150448702a28482bab62cee9c16b"
    sha256 cellar: :any,                 arm64_big_sur:  "f7290fa7bc44e35efddf8382b853b0168bc43b9f6e1028ff0f22db9c8c3978c6"
    sha256 cellar: :any,                 monterey:       "00b6fa5f3f8797e6cc5f54b44a5e940a1ecf0750c88e2c5e34a6dca2e1693f19"
    sha256 cellar: :any,                 big_sur:        "0e776dbbe21eb4dc5259d81d6cc49eaeceecc813ee5e8116db7e0bdba65b2802"
    sha256 cellar: :any,                 catalina:       "ba0fd18328d0de380d179e17457d59801cee6c8cd3e55287673e594f55014e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7672129b692ec107624c356670382dd7f6ffdbce5a752667ca2ffdd434e9375a"
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
