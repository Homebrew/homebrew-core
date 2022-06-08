class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  license "BSD-3-Clause"
  revision 1

  stable do
    url "https://ftp.indexdata.com/pub/yaz/yaz-5.32.0.tar.gz"
    sha256 "04d08c799d5ee56a2670e6ac0b42398d2ff956bd9bf144bfe9c4c30e557140e0"
  end

  livecheck do
    url :homepage
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d3c5403306490a23b01c02d2377c4957e49014ec8e0a10e31f89f42448de0ef"
    sha256 cellar: :any,                 arm64_big_sur:  "d9a460f4be9ba66a37108fcedb1653fc5bee04fa7c08dccb64e43057ba6b17ae"
    sha256 cellar: :any,                 monterey:       "774618052594c9229e1e8247bedda4e5785d30aebb01be617d8f2656136851ed"
    sha256 cellar: :any,                 big_sur:        "f4698af5b2c57c0e536715efc1e7a6e95eeeac66b37eb82ceb427ad6a9f1f76f"
    sha256 cellar: :any,                 catalina:       "658c5d298e7e684ba3218e840b2ec1c10e01c5ea83d1759d1dca70b034924597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "171c6fe1e5807613146a8e73d30e1e02ddff5e2ecfab1e0195b81e6a171390ca"
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
