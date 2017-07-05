class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.6.2.tar.gz"
  sha256 "413b530b69dd3fb7bcef439bf44be262f051e55f7aa129f1efada193b15903a6"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "6183df7e19d4fb0ca949feb1619f6282d2d5b04f18dfcabbad2ce3940716ebe0" => :sierra
    sha256 "f2df01a480a197ad4aeeeeb42d1320338fdcd481dfd9e6d70011c92dec444edb" => :el_capitan
    sha256 "4a681825e7e60985264f9d8bfe63059d5ce941b7b71fe005ea25048e1f202318" => :yosemite
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
