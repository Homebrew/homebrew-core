class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v4.1.1.tar.gz"
  sha256 "5f85c69606fad5cdb42e8f8101c96f6962a4928667395d9471e5aaea961e9b1d"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "43ac887f42168690399f01e9d9f3530cecc5e36415c9e6cdb77bc4d06083d179"
    sha256 cellar: :any, big_sur:       "5cbc62fe2ccbbd8cefc3649a74c0799feb5e9bafb342d0fab133524466b08cf5"
    sha256 cellar: :any, catalina:      "ef72b1b60cb8df3295a1dd6f582cace52167c4a65be4c435b3377a49f1284dd7"
    sha256 cellar: :any, mojave:        "3989b1201ebcd89171ad303aae5034b6c23653ed3add8e6d140eb1c488824b1e"
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
