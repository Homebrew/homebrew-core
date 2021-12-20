class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  license "BSD-3-Clause"

  stable do
    url "https://ftp.indexdata.com/pub/yaz/yaz-5.31.1.tar.gz"
    sha256 "14cc34d19fd1fd27e544619f4c13300f14dc807088a1acc69fcb5c28d29baa15"
  end

  livecheck do
    url :homepage
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d6212b17e34b8d16cc2d891372a84a688e5e8e24c2c656fd99dc58a7bd987939"
    sha256 cellar: :any,                 arm64_big_sur:  "0d143388ff7e2ef7816bef13239615cdb1abcc25aec1aa2df07683471c609ab1"
    sha256 cellar: :any,                 monterey:       "d4220d0ce0551467fec33147d76398b87f3c251354038393b7c930da09a513b2"
    sha256 cellar: :any,                 big_sur:        "3d3326acb000ca66e8d350ee1c6d25e9cd739ad95d01ab1707e2e0f74ab7936e"
    sha256 cellar: :any,                 catalina:       "9c02ddc39de080423d4dfaad4b33790b54994a741f02b56ab1e7ca72ea2bc54f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18a02a816cef7d91d43e7d28950aa359dcb96c3a1d3260f222d925b00c0d57ac"
  end

  head do
    url "https://github.com/indexdata/yaz.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "icu4c"

  uses_from_macos "libxml2"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-gnutls",
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
