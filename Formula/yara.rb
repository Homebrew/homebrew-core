class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.6.0.tar.gz"
  sha256 "fb27784b3989db509871652aae26063d87e9cc6330929abed1ab824c5bd600e0"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "e4a50cdfb158e4819669ea28073e11452ceade04b3c82acc9f509096e8efecd7" => :sierra
    sha256 "f17461fbbd8e04d10c310c193c5237cbae346921c42e413f8263d7d23d83a594" => :el_capitan
    sha256 "d42b03d218a0cc59cc0c140f2932d114188efbb860eb58b8052f6296a7b890fa" => :yosemite
    sha256 "eece40063a784295d8b404ce8cd35536b3046f07ff3eadf88ecf0b5b914cee29" => :mavericks
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
