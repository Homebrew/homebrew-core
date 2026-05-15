class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  url "https://ftp.indexdata.com/pub/yaz/yaz-5.37.1.tar.gz"
  sha256 "0d78e6ef056597712387ff6833ec393e1cd9c5dff6a41a486dd68f97ef83154d"
  license "BSD-3-Clause"
  compatibility_version 1

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https://ftp.indexdata.com/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "256cdd1b758ae2e952bff529afcaf7811d6dd037f39eb59f1d06a4685bb96b98"
    sha256 cellar: :any,                 arm64_sequoia: "39408a1279a7667e4061b69e06bda29c6d544301bb199b1710810d134b79de23"
    sha256 cellar: :any,                 arm64_sonoma:  "3ac07046ac6ae805127d20383166c134ffc7d5a8a0103c94523040c4f46375ff"
    sha256                               sonoma:        "6860b72b3f2128353085f8fd392ac7425535ae28821674099d6f945183324eae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0876685a51ba192763ead71653481d62e908424721ed8e8be09b53478a593bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d203ff486f49040b69f3b492133b271b6b89f5840dfb75ff970492accab5243d"
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
