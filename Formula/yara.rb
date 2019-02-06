class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.8.1.tar.gz"
  sha256 "283527711269354d3c60e2705f7f74b1f769d2d35ddba8f7f9ce97d0fd5cb1ca"
  revision 2
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "c4e6608a2e5205b63d835b8344a813872631e4b0a65cb77408c8bef5cf35ece7" => :mojave
    sha256 "f940993d4adfd540b0b4efcb5e924b3f9313b471654087b8d607a20baeb1e64f" => :high_sierra
    sha256 "13f645957749f69a02800f53fcd52f49e9e83ee9c94fbf396481578991ded68a" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl"

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
                          "--with-crpyto"
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
