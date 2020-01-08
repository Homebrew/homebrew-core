class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.11.0.tar.gz"
  sha256 "de8c54028c848751c06f5acc3b749c3ef6b111090b39f6ff991295af44bd4633"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "c7d54d25d34ed9a0bf41e4cbe686f36ca6b0e62c7f5a68e450c033de5841128f" => :catalina
    sha256 "7165e59093cd50672889121ead42ff8fc5082d2bbde7d7dc52e314f409dda9a6" => :mojave
    sha256 "3c49cc1dd56a8633294439dab8e6c68ae1021e1060238fa4658b44f59a070b26" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@1.1"

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
