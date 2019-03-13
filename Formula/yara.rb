class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.9.0.tar.gz"
  sha256 "ebe7fab0abadb90449a62afbd24e196e18b177efe71ffd8bf22df95c5386f64d"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ba20adea60d74351b20c0afe07549a7cb52918cc93239cf06e724d8e8a62dce8" => :mojave
    sha256 "210d673ea7da63cb9b340e178d095baa616a01761cce0050c279f0ca418bc6f7" => :high_sierra
    sha256 "8cf2100e8c40df878daa7fa6ab8d666ecd3bf1b3fef36e0d42297047fa9d68cd" => :sierra
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
                          "--with-crypto"
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
