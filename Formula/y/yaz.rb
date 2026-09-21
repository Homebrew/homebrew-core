class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  url "https://ftp.indexdata.com/pub/yaz/yaz-5.38.0.tar.gz"
  sha256 "c35f3994d382b42c43954253c1f24d1c0f93f0cb960532b69efa399b31b39b10"
  license "BSD-3-Clause"
  compatibility_version 1

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https://ftp.indexdata.com/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b18e859456a3ac64b99cd191c5da949abd004ae887e6a8eb5d4a64902ab70390"
    sha256 cellar: :any, arm64_tahoe:       "e4aff3fb37f5fcdc02e6361a8d2d81c35eb8768cfdc9a555cd6a7d6b6559b86b"
    sha256 cellar: :any, arm64_sequoia:     "13f05d1137e6cfdebaca8ea34c2685a54261e5b425b2946ab0e9c79fa94b70af"
    sha256 cellar: :any, arm64_sonoma:      "84fb84cde0dbc90434797378ef574098ce6c4dc93038f9d7b8c36005a8e657ba"
    sha256 cellar: :any, arm64_linux:       "37f9bbae13b78dbcd90844198e76ac7ce168dbff6e1bb71788536c92b6748b42"
    sha256 cellar: :any, x86_64_linux:      "f8fbb749309a797414b8789dd8004480bf995629311ead2f46aa485a52ce7be6"
  end

  head do
    url "https://github.com/indexdata/yaz.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "docbook-xsl" => :build
    depends_on "libtool" => :build
    depends_on "tcl-tk" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "icu4c@78"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.
  end

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

    inreplace [bin/"yaz-config", *lib.glob("pkgconfig/yaz*.pc")], prefix, opt_prefix
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
