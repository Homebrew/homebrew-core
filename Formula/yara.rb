class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.8.1.tar.gz"
  sha256 "283527711269354d3c60e2705f7f74b1f769d2d35ddba8f7f9ce97d0fd5cb1ca"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "f937b52ce311ad61726d374c7be876dae61fd61f9f85f86db207d30b08d70f26" => :high_sierra
    sha256 "3fc4f5981873940a9cd6518f923575e0d9ce2bc51d078881c4fc11d0a7618161" => :sierra
    sha256 "9219080a0d50dd78539fb6f0ac7fb0f620462bd2cad8cbcbd1c334a0af38af1d" => :el_capitan
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
