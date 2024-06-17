class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  url "https://ftp.indexdata.com/pub/yaz/yaz-5.34.0.tar.gz"
  sha256 "bcbea894599a13342910003401c17576f0fb910092aecb51cb54065d0cd2d613"
  license "BSD-3-Clause"
  revision 2

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https://ftp.indexdata.com/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79d99c8711467e1293cf29ad7de73a63b2d3c974edef0f4c56b3855f8c8a58e0"
    sha256 cellar: :any,                 arm64_ventura:  "63f2fb0f41ce638e380adcc6a552e3fe99bbb83a474261d87afde0aeb2e54744"
    sha256 cellar: :any,                 arm64_monterey: "061d685a68f9a3f26ed65cc4ca593e2f56a518ec44694f9382c82a5435528bb8"
    sha256 cellar: :any,                 sonoma:         "e81fbd1f1c424045cad6efd0ef1b840704d9a27f87272277a52bb193eb487c6b"
    sha256 cellar: :any,                 ventura:        "1b897f5d8c7ecf516d859900c8a646314524dd68420ba984fa26bbc7385f53b9"
    sha256 cellar: :any,                 monterey:       "decd970c1e88a9a030238fedfdf5d657799fc4bd549bc286f3d20c7e7d84ebb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "366223a48ffa7eea929dda410165cf8c128adbfe83d33b57156c5933da8d25cc"
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

  # Fix build with libxml2 2.12. Remove if upstream PR is merged and in release.
  # PR Ref: https://github.com/indexdata/yaz/pull/103
  patch do
    url "https://github.com/indexdata/yaz/commit/b10643c42ea64b1ee09fe53aec2490129f903bcb.patch?full_index=1"
    sha256 "7dba5fc599bfa3c54694c87f6978f24dd584ab746aab68bc82a41411da81bec6"
  end

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
