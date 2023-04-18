class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "67bc0a5d58d9080a0981da116d65817d27b87dad7e402c7ece25372b38401e12"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1e68bbbff1d6b0985ac877c39e3def2bc693a7c789ff6cfd4ed95463c96fe346"
    sha256 cellar: :any,                 arm64_monterey: "571fbb18d3f429d9a4da15ce38a191f48a7827ba718d96554102201b849bc16c"
    sha256 cellar: :any,                 arm64_big_sur:  "a49314c4a062d1a63964fb96586da9e2742bd26a3abe3a5074e763056c03c05f"
    sha256 cellar: :any,                 ventura:        "b5e212e91ba2d051e88d6d21fbecbbfbb6aa8903f3319d7c732ecbf77a6f2618"
    sha256 cellar: :any,                 monterey:       "7b529da6ef62ca3c31fbd05fe10b4d858ef36f56ce61d5779397317338a8b0d8"
    sha256 cellar: :any,                 big_sur:        "4f17f6054a32fdc702ddee1830f435cf29d09feeda6be431e38b81a8b943b58f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78976934e54635e6bedb07287e17cce26025429891e017e7e73010d1d8295c57"
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
