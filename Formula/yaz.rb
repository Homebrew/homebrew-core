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
    sha256 cellar: :any,                 arm64_monterey: "e14b54d79bae32b9312bd03a5567d24bae06e23f5269d547638e97a87124200f"
    sha256 cellar: :any,                 arm64_big_sur:  "9664a83b537dda5541d7b6ff5d8d5d2100dbdb79df6bdca60a0f36f2d651e868"
    sha256 cellar: :any,                 monterey:       "afff3fad4baac1e84f4624671a4d8915233aa832448162a237e588ec67cca69f"
    sha256 cellar: :any,                 big_sur:        "09e313f24f40718abefba0ccea3e349a42e5c0ddb59f68aca35ce415f840a0c2"
    sha256 cellar: :any,                 catalina:       "c2fe61b69343000f8a62c31251269fd8219e518fa647f2985508eb684edb90ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fae47c2895e659c7fd018d4ad8bab51f909c7ebba5338659194878c53150203a"
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
