class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  license "BSD-3-Clause"
  revision 1

  stable do
    url "https://ftp.indexdata.com/pub/yaz/yaz-5.31.1.tar.gz"
    sha256 "14cc34d19fd1fd27e544619f4c13300f14dc807088a1acc69fcb5c28d29baa15"
  end

  livecheck do
    url :homepage
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bcab7919ac7e0c4c8e0e077622193a6bd4cd7b58c7715376aa6675e71eb6b87d"
    sha256 cellar: :any,                 arm64_big_sur:  "6e8441355f2049e16ac5f66df8cb458199dca132f574057b36f819cb10c5b563"
    sha256 cellar: :any,                 monterey:       "625cbdf4bf9dc3571df41fae49bbd66d4431f69c964e5b1414fd7ee0502e3fcb"
    sha256 cellar: :any,                 big_sur:        "47a5ed5c62c9edf756123a8563da840de4dd9faedafecb00a0a4cd8e437be8a9"
    sha256 cellar: :any,                 catalina:       "e407505a0d004b0fb8d28aa328a8fa89bd1740fbdfc81e36f14e3078d0104d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d58e6deba9fe27a994c5d08f3e00c1ce3033a397c39ab66a11c31b9cc5e59cb0"
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
