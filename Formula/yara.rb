class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.8.0.tar.gz"
  sha256 "eb6cade9eaf09b8242dff0476ff690c4c428fbdcf7e5df93ac762346e81198da"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cea34d77102cd791be85ce47e01a945b8b0fcf629a8b0c59b3bbd9a2874a1b2e" => :high_sierra
    sha256 "4e473c3955f931aee46ac0af42e4370a66d9c024d8ac209500d3901bf3a1c036" => :sierra
    sha256 "052f368216242605b274aff17dc5f97517830660c137c6083361544810ed7320" => :el_capitan
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
