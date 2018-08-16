class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.8.1.tar.gz"
  sha256 "283527711269354d3c60e2705f7f74b1f769d2d35ddba8f7f9ce97d0fd5cb1ca"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "907c694d9a5f9e88c6fc8817d7299b4f28b09be634549211eb6e391530bd2de7" => :high_sierra
    sha256 "4b1892414ea598b2b9f63597495629787e1a177115f72f8d1fa5f0c791906c9f" => :sierra
    sha256 "f9b54c9174e5d48345d2cb9dd7bb1ffb94bf23451960f6177bd8d9f810d7943f" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "python@2"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-dotnet"
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
