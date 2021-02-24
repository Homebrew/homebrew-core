class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v4.0.5.tar.gz"
  sha256 "ea7ebefad05831faf6f780cab721611b0135803f03a84c27eeba7bfe0afc3aae"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6fc466b7f2f9a8890aacc431425da5149800b1155496be6bea1a2c6022824ce2"
    sha256 cellar: :any, big_sur:       "672fc888ff396770760d782cc687cecb2ef6b2f80fe83e7fd7c7288f83262c16"
    sha256 cellar: :any, catalina:      "dbbb1b1104e8f122ce48cc863676af3570cb1abecfe0d857f7556acc2878e351"
    sha256 cellar: :any, mojave:        "b200381f65c1775acef216f7a482abef959f7f182894bb71043f98bf0a017731"
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
