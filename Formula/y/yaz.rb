class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  url "https://ftp.indexdata.com/pub/yaz/yaz-5.37.3.tar.gz"
  sha256 "975d7878b272cc999e5acbd02dc272a46607f95e6ee4f35ac655e8e4d333bf2b"
  license "BSD-3-Clause"
  compatibility_version 1

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https://ftp.indexdata.com/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21374c5d02ec10857f5cc7c12f37d1035f001547f35f649d5d359eb06d10aa8a"
    sha256 cellar: :any,                 arm64_sequoia: "7eb44015254a310103859d3172720cdd5f092f27c1a82116f1fab657f2ea8989"
    sha256 cellar: :any,                 arm64_sonoma:  "dc2039b63dfe0fa72a26b585ba17d295e0cbaa9a964474aa8f6594f722fe9345"
    sha256                               sonoma:        "39bb8ed0161802212d5e1476fab94e061885cd57a848c062440b4f62d43feb48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6dd2603434b35320caeb7dee8b3723f8bcaf2d18127d4842ae60b8e7660bc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7bd01dd86c37eafbad7ec17a36a102e5412bab432f4c5be99b98776b6b2044"
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
