class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v4.1.2.tar.gz"
  sha256 "90ffe4e1d6f498dd4d39d19bc6858fd058aaf77586595773804a9bf03c737002"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "edf2ff9ac9c4c53720ac53e7b3df68c18aeaa18be17152ab5633053e04c88b29"
    sha256 cellar: :any,                 big_sur:       "83aa393c51adf92eb310e23943929dfbd489cd365535682e97dc27bda9fc310d"
    sha256 cellar: :any,                 catalina:      "6a4703dfcb6e2d8b4d753e54e8adc16aecfb1000983a55b2f86e43628d4d36d8"
    sha256 cellar: :any,                 mojave:        "3d2b7b10112923b8b8efa938f4ae54aed85ac13a860a82e3c1e090b89106083b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e120322c0dbfa6b57698af458f91383f34cebc501e1ef79a45840c7ce68fbd2"
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
