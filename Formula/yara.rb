class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v4.1.1.tar.gz"
  sha256 "5f85c69606fad5cdb42e8f8101c96f6962a4928667395d9471e5aaea961e9b1d"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "82f2f7cd67e9e17b091238deb8a5efc439a6d6a31973f214ca97354c9efa508a"
    sha256 cellar: :any, big_sur:       "1c537a6806077a1182e064caba4fd1ff8a85876bc00075ed7cb9fa5d0f23c63e"
    sha256 cellar: :any, catalina:      "9f67abadf869d00f103dbad51fc21bccb664b348184d943e0e2c758097e50c0c"
    sha256 cellar: :any, mojave:        "037207f1ffcc9bf9b3122f6f9a0ca3b1cfc944d8526d1aa24634ba3ade1760a3"
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
