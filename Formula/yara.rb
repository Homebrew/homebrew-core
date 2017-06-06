class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.6.1.tar.gz"
  sha256 "9ee0e0cc1c2b36c9e2095dab7d4db928b43f3301254ab0836a342a286282949e"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "351b618eb38dbab797cff2ad5a69e7a964f4e0efd59d0d472e8d65b0315a6341" => :sierra
    sha256 "8ca23c45b6f9074f15c5d958937c2ec963f631013091c4460fe5971324e9f41d" => :el_capitan
    sha256 "b0674bd7934ad0597dbc2da8a03019c955be52818a48c8fb6a9f29b612ee6af3" => :yosemite
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
