class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.10.0.tar.gz"
  sha256 "3281d43d6b49a4ca8d3a5d2521e06a0b72863702022f981b051856c2b83449c2"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "96e4ce1d68bf111eb31a83380383176e3fc2d79221751e2d301e01cf5a043fe0" => :mojave
    sha256 "da1fb89ba681a95d0841a5be0b07621cd88223d1af66564a2217c144739b2b5f" => :high_sierra
    sha256 "eb6429e5275ef5ebcb5ba7f6669349363cc797cbef8991e33aaa1377ed263973" => :sierra
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
