class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v4.1.3.tar.gz"
  sha256 "3610ddd0c3645b8b9cfa7cfbafc0146f2df751ad8d6cd261a638bfff81efbc32"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f40afa4fb7df87b3616c0c75fe7891364dc15b587001f5c181b2e5f8f4a76646"
    sha256 cellar: :any,                 arm64_big_sur:  "a6f6f04d7503f909eebbe1eff4b9735f102a3444d6208eb9f1fead5816e14858"
    sha256 cellar: :any,                 monterey:       "8b1855554fc0871745886c4dd7c04120c6d880e13033b267ccc269913b6742dd"
    sha256 cellar: :any,                 big_sur:        "97b7631aeb7abca3a54dff991f238cff780daf9fb99463a774214e57ba3e25c4"
    sha256 cellar: :any,                 catalina:       "7aac2ecb50d470c44371d3b57c4820756a0302fbb4e1e035757bc4a9a2793989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef6c8ba77e714a2a1dd40368869b659a934d09d03828903d25fc40dc76f70329"
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
