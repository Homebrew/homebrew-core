class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.7.0.tar.gz"
  sha256 "01f0841e7387918c2b6d0b7fb48014bda41d1487be1cabf718a0576018969641"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "0abc89f9bcd944bf31c91d35c21b8990a06d681cdcdd486ca2cb0f25795c5b18" => :high_sierra
    sha256 "3c41b0a4be9efba08f9df404f463bbcb80783be2aa156079ad9195ea9f1f31ec" => :sierra
    sha256 "087b9a0a65193d84be380b3a336595812d6db0038e6717e11908a4fe83ef7e43" => :el_capitan
  end

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
