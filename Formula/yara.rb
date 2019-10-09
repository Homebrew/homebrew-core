class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.10.0.tar.gz"
  sha256 "3281d43d6b49a4ca8d3a5d2521e06a0b72863702022f981b051856c2b83449c2"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "66254d3ecacd78ca67a877499b2a45813f451a48e0fafb0d04073c278ab71340" => :catalina
    sha256 "4677b253af63c7e3488923c338629a716ee62c6346bc3bd0e05aaf8ec8238e9c" => :mojave
    sha256 "2cf210611ad8321e4cf16233e70aca46403ed6b4d9eea6f88d934b16b9446aea" => :high_sierra
    sha256 "de48b85f2e3846310548941bfcea1400dc58cafc92d9229b98514bb4f7eecd1c" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@1.1"

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
