class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.5.0.tar.gz"
  sha256 "ff2ee440515684c272df52febc8b73e730ca99ce194c24bd3cb43bec2b4c47f2"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "2bb2c72c4d24ff8f44ff94b5bd1c182a61df697f5721beaef84d56fe4e3245e1" => :el_capitan
    sha256 "1505de971068a09ffcbd0923a1c865a33fe9cd1a24f55b1f6aa6efe6d0df5f10" => :yosemite
    sha256 "5829e88154d05e1e3f9030399431b81c1dba3f11f3f0a5c08ee28d6236116854" => :mavericks
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
