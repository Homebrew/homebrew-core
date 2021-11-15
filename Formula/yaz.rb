class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  license "BSD-3-Clause"

  stable do
    url "https://ftp.indexdata.com/pub/yaz/yaz-5.31.0.tar.gz"
    sha256 "864d4476d1578ac132782b3d4e2eb96391bd88f7ae3040ddcb1556aba6fe0d15"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2b5ea1cae0aa4f18fcf09bc1a79df9cd185d94f6f2029315df6f9e6a1bead3ba"
    sha256 cellar: :any,                 arm64_big_sur:  "88e9c78b500a5bf61ef7996e873a08508725edeb3d4e2ff364c4c18b9f55fb16"
    sha256 cellar: :any,                 monterey:       "f3884f5e99387f5dfbb9ae482a1e388fb7ccffc35dd7a42460dbace5bfcfd978"
    sha256 cellar: :any,                 big_sur:        "968de6c53096f9f0accf06488de7e4ab76428a33eb1bcd27866ae34376b82996"
    sha256 cellar: :any,                 catalina:       "5a2ead8e67e33724130ae46cfcdd880488f99715816ef803f5b30b64cb3cf898"
    sha256 cellar: :any,                 mojave:         "2e9e5037cc90d375556fd203e8316e81b0df113a48509bf25df6f581c2dc2f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1df089100f75e362967e449c15abef1b9ce18f6b38421975614ee19b270609db"
  end

  head do
    url "https://github.com/indexdata/yaz.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"

  uses_from_macos "libxml2"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
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
