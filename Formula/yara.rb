class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v4.0.5.tar.gz"
  sha256 "ea7ebefad05831faf6f780cab721611b0135803f03a84c27eeba7bfe0afc3aae"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e63133e26d235dc2c24858dc740e2ccf8e7763fb865bfad359b9f8d3ac79e127"
    sha256 cellar: :any, big_sur:       "a268e9cc51f3d002559f6fe64f1c9688a52a50b18d7e7a63d12669275449eccf"
    sha256 cellar: :any, catalina:      "0b44eee1ec363ecb7fe7c7077f789a7a16b5351be8d42ecf35ab5b6deb4b1a0a"
    sha256 cellar: :any, mojave:        "1ce1bd2ea8631e1a40491c0897e939e45e64b670f18078dae8eea7c240964708"
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
