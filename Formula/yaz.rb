class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  url "https://ftp.indexdata.com/pub/yaz/yaz-5.34.0.tar.gz"
  sha256 "bcbea894599a13342910003401c17576f0fb910092aecb51cb54065d0cd2d613"
  license "BSD-3-Clause"
  revision 1

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https://ftp.indexdata.com/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5dbb63de0d67f15fdfcff25147b3509b473776b06a0c9ca900a04fa3126083be"
    sha256 cellar: :any,                 arm64_monterey: "259dbc67e9ab37dd225a2ce7606386ad5965cfb4f4aea23b7b74181dfcb9eada"
    sha256 cellar: :any,                 arm64_big_sur:  "ca4e44d1099e84555de5025954533d588eaaea51677c5c8c865bb2c11e5e542a"
    sha256 cellar: :any,                 ventura:        "2d2ea4097b54057d5fddfec177d9bc61a2b9101d9d189caba5084048c4e1aea1"
    sha256 cellar: :any,                 monterey:       "205f35ed6f999edd61ed575183b103ac8dff9dac0e49a560215b51eeb784594e"
    sha256 cellar: :any,                 big_sur:        "036c02f8aa3efa9715d8e948781a41b67d5c937530bd57649650f7e9b952a253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bae7bc3dc941e1cb1b180ed3d4aa8c2d91a70cfe8d41114e39c5dac9b09c46bd"
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
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

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

    # Replace dependencies' cellar paths, which can break build for dependents
    # (like `metaproxy` and `zebra`) after a dependency is version/revision bumped
    inreplace bin/"yaz-config" do |s|
      s.gsub! Formula["gnutls"].prefix.realpath, Formula["gnutls"].opt_prefix
      s.gsub! Formula["icu4c"].prefix.realpath, Formula["icu4c"].opt_prefix
    end
    unless OS.mac?
      inreplace [bin/"yaz-config", lib/"pkgconfig/yaz.pc"] do |s|
        s.gsub! Formula["libxml2"].prefix.realpath, Formula["libxml2"].opt_prefix
        s.gsub! Formula["libxslt"].prefix.realpath, Formula["libxslt"].opt_prefix
      end
    end
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
