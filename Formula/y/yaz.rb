class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  url "https://ftp.indexdata.com/pub/yaz/yaz-5.34.3.tar.gz"
  sha256 "ce4cb9e483e865ce57d32c2956b6ab65eed28cfe6dc904068c3abe4c54dba4c0"
  license "BSD-3-Clause"

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https://ftp.indexdata.com/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65518d2c2df2c6c4ec6f7a9f0dfe274d790a581226bdf414d5249b2df29d2886"
    sha256 cellar: :any,                 arm64_sonoma:  "39aae1432cd9dbe5a61f20eee14b53f47d1ff7055aabf25c31b76e220eb96a11"
    sha256 cellar: :any,                 arm64_ventura: "217a709a081272964ed3fb136b1e1ba9bf8b7b07767ae23aa680cc896412c86e"
    sha256 cellar: :any,                 sonoma:        "1d7bb3180287d7526099784cadf721ed1234efac4ff76fd845080c9ccad180d0"
    sha256 cellar: :any,                 ventura:       "f74577c87219ab04264c78c157a2262ca8462c6ff519bcc657c09eb4afbcd913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d0cdbc299e8f2759a05e41bd1add117fe7d15379f79480c2733c329c875a52"
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

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "icu4c@76"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "./buildconf.sh"
    end
    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    system "./configure", "--with-gnutls",
                          "--with-icu=#{icu4c.opt_prefix}",
                          "--with-xml2",
                          "--with-xslt",
                          *std_configure_args
    system "make", "install"

    # Replace dependencies' cellar paths, which can break build for dependents
    # (like `metaproxy` and `zebra`) after a dependency is version/revision bumped
    inreplace bin/"yaz-config" do |s|
      s.gsub! Formula["gnutls"].prefix.realpath, Formula["gnutls"].opt_prefix
      s.gsub! icu4c.prefix.realpath, icu4c.opt_prefix
    end
    unless OS.mac?
      inreplace [bin/"yaz-config", lib/"pkgconfig/yaz.pc"] do |s|
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
    configfile.write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <icu_chain locale="en">
        <transform rule="[:Control:] Any-Remove"/>
        <tokenize rule="w"/>
        <transform rule="[[:WhiteSpace:][:Punctuation:]] Remove"/>
        <transliterate rule="xy > z;"/>
        <display/>
        <casemap rule="l"/>
      </icu_chain>
    XML

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
