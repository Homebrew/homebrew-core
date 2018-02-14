class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.7.1.tar.gz"
  sha256 "df077a29b0fffbf4e7c575f838a440f42d09b215fcb3971e6fb6360318a64892"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "6a995595a48f513196225445dc4ee2889b54d288eb19fb1adfddbeac0b8ac9a9" => :high_sierra
    sha256 "8769d808d6360ac8440893c4fc2f8d81b4842b3d4631c65441bc81d35f872ce1" => :sierra
    sha256 "deba43f8ebc4d52d0d8a17febdebf8cc5b0de6c9f81f28e7d6a03aea2a87abe7" => :el_capitan
  end

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python" if MacOS.version <= :snow_leopard
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
