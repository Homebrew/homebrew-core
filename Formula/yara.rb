class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "1cd84fc2db606e83084a648152eb35103c3e30350825cb7553448d5ccde02a0d"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a57ba40d64d2accecfa797ed768b640cc72bb289bf56c1528b4abd2258644f3"
    sha256 cellar: :any,                 arm64_monterey: "1ede25b74551c487e9b6ec1309a86fcf081880fbe42b1f0ea944b6c15e07bc41"
    sha256 cellar: :any,                 arm64_big_sur:  "f47558bcc6944b7d360234eb52d0412b8ccecae34d55408f6fe5c12cd5e2eea7"
    sha256 cellar: :any,                 ventura:        "4fd75d100250e06e8f8e985f74247dada213e1c2795a8bf83b3969a1279dd77a"
    sha256 cellar: :any,                 monterey:       "3199dc6269f68fdb846d1778f8d608f03a0ce57e8eaf08864cb12fb7fdd9dd40"
    sha256 cellar: :any,                 big_sur:        "39c5f918530817ce24797ce4d683c535978540b35a6575a696017fb3793acb5b"
    sha256 cellar: :any,                 catalina:       "9267afdd5160d9fb2761853d9907f4a5923f3e1a88c8d46575372fa39630818b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5d9377099a2f5f977f26ac7597ed5b3ac65891963bcd23f16168e111a8a882a"
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
