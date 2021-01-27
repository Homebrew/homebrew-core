class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v4.0.4.tar.gz"
  sha256 "67fdc6f1050261914cf4a9e379b60961f62c2f76af676bafb2ceb47dd642d44f"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    sha256 "71a43f357779b47938682685f466937bfa52825b3ae7b24e0542ab7763c15694" => :big_sur
    sha256 "ed76d3e600ce1b4508c6520af9c78737edb4a093f1446dc4a0d6c84635ce0058" => :arm64_big_sur
    sha256 "f6a54eada322dd81c913d5d9ac012dce8052b0f72ffacf24d315732b069e17fc" => :catalina
    sha256 "73738693002015cdb8a628c0096ec63c2721fd17d56c7c6d3ae61edbc2e8d1b1" => :mojave
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
