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
    sha256 cellar: :any,                 arm64_monterey: "b3d5d69e2d5b5df5fb851e9ad0b302d1322808f853cc6b124a5fd0862f5c68dd"
    sha256 cellar: :any,                 arm64_big_sur:  "5a5abf48bfe9a0cd943190e777cdbc1a5708a73be0e8d2ac66561a8a7cbb9219"
    sha256 cellar: :any,                 monterey:       "d300cd7ccc95ae7f7fec2e1402a21b59997016ba37a5565da3500626eaefb979"
    sha256 cellar: :any,                 big_sur:        "9b2c35223337b640ec59268d9b6ed6bb7526cef30868e34fa5c0d967e1b659f6"
    sha256 cellar: :any,                 catalina:       "93ced5be6bc4dba6ed4b90a3e714cc818e4dac511d2cc9eec1b316b2edfc494e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead1748e64497a12fc41535281a728351af6b95440ce582c049a35e039c77061"
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
