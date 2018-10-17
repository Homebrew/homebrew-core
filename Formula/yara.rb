class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.8.1.tar.gz"
  sha256 "283527711269354d3c60e2705f7f74b1f769d2d35ddba8f7f9ce97d0fd5cb1ca"
  revision 1
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "4c3626f044e8883aeec924eb86a3f911c066dec08a27e3942cd42740dc1d437c" => :mojave
    sha256 "33a367347f06bebdac1538402fc1ecebb86658f4aec70c764c8aa98bbc81d7fd" => :high_sierra
    sha256 "334989f4b87c6b28b9e5258dab53b5617a11cc096d788f794039e48c40425e26" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"

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
