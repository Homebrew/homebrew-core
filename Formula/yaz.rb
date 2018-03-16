class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.23.1.tar.gz"
  sha256 "4fb3b1ffcec4b9a56b892c47a0a645142e45418ce5ef6a835aeebc723f7d147e"
  revision 2

  bottle do
    cellar :any
    sha256 "f0c08571d5eb5ec506e76b675f96b36f355f5bf2e7f91bcccfa463573449ba79" => :high_sierra
    sha256 "0578e44aff8a426b3936633ca29e8693860941f4d693c37e8e9491fe9d9cf2fa" => :sierra
    sha256 "a0c3051306314ba99073719706fd57c40c432a9c83dcbef9b6aaee52bc49f3ef" => :el_capitan
  end

  head do
    url "https://github.com/indexdata/yaz.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended

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

    # Test ICU support if building with ICU by running yaz-icu
    # with the example icu_chain from its man page.
    if build.with? "icu4c"
      # The input string should be transformed to be:
      # * without control characters (tab)
      # * split into tokens at word boundaries (including -)
      # * without whitespace and Punctuation
      # * xy transformed to z
      # * lowercase
      configurationfile = testpath/"icu-chain.xml"
      configurationfile.write <<~EOS
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

      result = shell_output("#{bin}/yaz-icu -c #{configurationfile} #{inputfile}")
      assert_equal expectedresult, result
    end
  end
end
