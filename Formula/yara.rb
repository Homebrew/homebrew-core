class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.6.2.tar.gz"
  sha256 "413b530b69dd3fb7bcef439bf44be262f051e55f7aa129f1efada193b15903a6"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "10305b810e39f39dbb3427339641378c5a4fa513038924a3bea3ab6d5bba5a83" => :sierra
    sha256 "ee767659c1ee02a0dd08efb351ddfd7aea60cda63f4bd4ae2f17dd161b85d4f1" => :el_capitan
    sha256 "677925c32889d4d24114b85c641d9dba7579588706efca776a7f1ba33054ad48" => :yosemite
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
    rules.write <<-EOS.undent
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
