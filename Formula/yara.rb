class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v4.0.2.tar.gz"
  sha256 "05ad88eac9a9f0232432fd14516bdaeda14349d6cf0cac802d76e369abcee001"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "e0a9565366bfa84e65ebc338c7862848aac15345570433c632311c5e0c1b7811" => :catalina
    sha256 "9a376923b39660a19777e4d5ecad48251a8510309c69291dc877b75e97d91d66" => :mojave
    sha256 "769d58809bcba97950e18d7f9c1e8e45e113abe8b7c21c7f0f56674e0ac2f7d1" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

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
