class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  url "https://ftp.indexdata.com/pub/yaz/yaz-5.37.0.tar.gz"
  sha256 "9257feb06e2fdbbfceb7d040c139fa13957c4d1ebba6aa293a6dd13cab2225ce"
  license "BSD-3-Clause"

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https://ftp.indexdata.com/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e84af7fa65a9d066d920995d1085730cc268015b81760645942a7d48e5caacbe"
    sha256 cellar: :any,                 arm64_sequoia: "95d1d99ca885bc62dd088899b2cbd3dae10ed6209977f8c633ceec2fb2752502"
    sha256 cellar: :any,                 arm64_sonoma:  "5ca87c1e4c66f74a5952f37a61933ba05f15994936dbb5d40a1742f5c0c99dc7"
    sha256                               sonoma:        "91b37a0873a49236f37a54afc1b1993d146261488cd7f42ac42ce07ad36275b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51a62fb7b1544676244df79fded10bee005162e0967ef0a29db7916b005ae142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5991097df1bb45e139e42c2fe9939020a283010e2cff59e8673381de966d4edf"
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
