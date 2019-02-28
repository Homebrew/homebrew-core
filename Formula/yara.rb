class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.9.0.tar.gz"
  sha256 "ebe7fab0abadb90449a62afbd24e196e18b177efe71ffd8bf22df95c5386f64d"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "ac12e1278c753e1a79cb3fdd4fad8df6c01026c0aa159089182a65dd688ca483" => :mojave
    sha256 "ed092caa3603842d4f9daa48a36d173d79504ef6e22b7af85b8576dc75fca55f" => :high_sierra
    sha256 "03f2077af95ec05e06bb09c704089e6c4c63fffcd06437fda01bcd2fea0d97d9" => :sierra
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
                          "--with-crpyto"
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
