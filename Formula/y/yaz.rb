class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  url "https://ftp.indexdata.com/pub/yaz/yaz-5.38.1.tar.gz"
  sha256 "755835efe8385d88725cc46a3b34dae2f5e784950832cbbe7f09ca0398de344c"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https://ftp.indexdata.com/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dc3e9293442755aa6edba7f3e5cf501f97ceba18164a787db1168b94309d3e1c"
    sha256 cellar: :any, arm64_tahoe:       "d4919b92294b43ebb36e61f4b3f26177061371e996d601dce948af47d60444ab"
    sha256 cellar: :any, arm64_sequoia:     "dc594cb1418b46b6bc42807565f354ae28b93ee009a062b01b8c58fa65e2cdc7"
    sha256 cellar: :any, arm64_linux:       "bebc077ec0aff57efcd1191c0ff67603f327b7a7d0c79c2d8a73ba31b37fe0e0"
    sha256 cellar: :any, x86_64_linux:      "6c86e10b65f50af27a28590dd8611827eea489d652fd1c313a72e8d7377b5a76"
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
  depends_on "icu4c@79"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.
  end

  deny_network_access!

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
