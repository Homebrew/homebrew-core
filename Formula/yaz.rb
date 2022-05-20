class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  license "BSD-3-Clause"
  revision 2

  stable do
    url "https://ftp.indexdata.com/pub/yaz/yaz-5.31.1.tar.gz"
    sha256 "14cc34d19fd1fd27e544619f4c13300f14dc807088a1acc69fcb5c28d29baa15"
  end

  livecheck do
    url :homepage
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "923f0919d3e65c3b61ad8f90641db2dbb199b53cd6ecf651add576633e35b67c"
    sha256 cellar: :any,                 arm64_big_sur:  "c50a90da020887b4a7f6ca986061225ae1493cc1ea5bc0da7c4f5e8cdca54e4b"
    sha256 cellar: :any,                 monterey:       "d4573e9eba835bde601ad2f3e202844e9267f5514b5f83662d800c552cee1be8"
    sha256 cellar: :any,                 big_sur:        "ae3de529018e63dda8090880bcd454e3725ca2729b94df67140b8b6ffed0143b"
    sha256 cellar: :any,                 catalina:       "f867dbc67ba829e5e905ab6d9dec27c3b342873903b6dcbf71404a4e6ebbfeed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "febd7d4ad3b81e84619eaa27dc033e5756d917e0b2f784f6d260f6ffe08178b0"
  end

  head do
    url "https://github.com/indexdata/yaz.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook-xsl" => :build
    depends_on "libtool" => :build

    uses_from_macos "bison" => :build
    uses_from_macos "tcl-tk" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "icu4c"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "./buildconf.sh"
    end
    system "./configure", *std_configure_args,
                          "--with-gnutls",
                          "--with-xml2",
                          "--with-xslt"
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
