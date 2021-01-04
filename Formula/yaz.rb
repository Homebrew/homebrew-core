class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.30.3.tar.gz"
  sha256 "f0497fd8420574efab4e5738ea3b70787a6e8042f585156baa30bdc1911ba552"
  license "BSD-3-Clause"

  livecheck do
    url "http://ftp.indexdata.dk/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "bae268483a7bf1bbf81bf4930cb34145b1c5172f1e1737f8b07cf220a3566711" => :big_sur
    sha256 "410d2e4b4dde8c3392375c3b37aedc1911fbd80c389c68d4eae5619c0593a555" => :arm64_big_sur
    sha256 "3e99cfd562ae262f299752a7d92dbad3f9b67dd37726e90b1109684f0deac7d1" => :catalina
    sha256 "0fb86a32e27613df4ef17bc76556364a85d220c9d044f6f2c515ca0bb2e94c6a" => :mojave
    sha256 "a3dd5357b88bd5780a90dc1fb51c12943d3a8ba6ce69073fb262116c9b050b3e" => :high_sierra
  end

  head do
    url "https://github.com/indexdata/yaz.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"

  uses_from_macos "libxml2"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml2"
    system "make", "install"
  end

  test do
    # This test converts between MARC8, an obscure mostly-obsolete library
    # text encoding supported by yaz-iconv, and UTF8.
    marc8file = testpath/"marc8.txt"
    marc8file.write "$1!0-!L,i$3i$si$Ki$Ai$O!+=(B"
    result = shell_output("#{bin}/yaz-iconv -f marc8 -t utf8 #{marc8file}")
    result.force_encoding(Encoding::UTF_8) if result.respond_to?(:force_encoding)
    assert_equal "世界こんにちは！", result

    # Test ICU support by running yaz-icu with the example icu_chain
    # from its man page.
    configfile = testpath/"icu-chain.xml"
    configfile.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <icu_chain locale="en">
        <transform rule="[:Control:] Any-Remove"/>
        <tokenize rule="w"/>
        <transform rule="[[:WhiteSpace:][:Punctuation:]] Remove"/>
        <transliterate rule="xy > z;"/>
        <display/>
        <casemap rule="l"/>
      </icu_chain>
    EOS

    inputfile = testpath/"icu-test.txt"
    inputfile.write "yaz-ICU	xy!"

    expectedresult = <<~EOS
      1 1 'yaz' 'yaz'
      2 1 '' ''
      3 1 'icuz' 'ICUz'
      4 1 '' ''
    EOS

    result = shell_output("#{bin}/yaz-icu -c #{configfile} #{inputfile}")
    assert_equal expectedresult, result
  end
end
