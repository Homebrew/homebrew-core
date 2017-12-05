class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.23.1.tar.gz"
  sha256 "4fb3b1ffcec4b9a56b892c47a0a645142e45418ce5ef6a835aeebc723f7d147e"
  revision 1

  bottle do
    cellar :any
    sha256 "7cde107afb296f80f84f8e3f5ab28c49dbbdabf277e551019beced9515b23f8c" => :high_sierra
    sha256 "79bff14a9d7cd50bbf71ae91b9b91d6e670b3b44d98271acbb6632aff30831c9" => :sierra
    sha256 "1895528299deb6423bed5bbd9806693d57cc2af083eb335500510dbe9c5e388e" => :el_capitan
    sha256 "020e949b02beddcf499e676b5920ec22d64030ce10d67420ca2a22cbf7900b76" => :yosemite
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
