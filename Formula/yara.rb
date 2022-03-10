class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "6f567d4e4b79a210cd57a820f59f19ee69b024188ef4645b1fc11488a4660951"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "46f44b445feb55960f9c579963cb8b77f6a15e33c09fb0a9894a5c61156032fe"
    sha256 cellar: :any,                 arm64_big_sur:  "61dd945991de18a48484da4aa98db52fbdd49b194cb23b54e44e21a52f6661b7"
    sha256 cellar: :any,                 monterey:       "d6151508ccb1252641d3a534f8c048058d0fd5921e0a35cfcfbaec35e16106e0"
    sha256 cellar: :any,                 big_sur:        "c9dbf2388e260d2aeab61edfcf2b80a71636ef64c5aea361076b87d15a08df8b"
    sha256 cellar: :any,                 catalina:       "cc02c80c157626b4e6849cf8dd9a5bd5dac23b6fc716b4b52c8cd244446698ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7b22961cc5ae9b3b6fe93fcaa2df81056aeb01c934e0aef51b62b2cb21bfa99"
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
