class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.7.0.tar.gz"
  sha256 "01f0841e7387918c2b6d0b7fb48014bda41d1487be1cabf718a0576018969641"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "deb55e507f653de70e9567a0b0081154ed8beb7d54b3bfae0bb6242766af29c6" => :high_sierra
    sha256 "c387995ca4eda6fc37d661d7d79c9421b070aa658a5453f52a6f06fd5f8ba928" => :sierra
    sha256 "3342afc59418374a627c3fbe9dc8e6046d5762f0998e6ac26176b5bf1ada19c8" => :el_capitan
    sha256 "86d6c185bf7afc46948cef4533eb9902a89560b8002ebf5963e9c60a48c65537" => :yosemite
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
