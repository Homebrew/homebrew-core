class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/resources/software/yaz/"
  url "https://ftp.indexdata.com/pub/yaz/yaz-5.34.0.tar.gz"
  sha256 "bcbea894599a13342910003401c17576f0fb910092aecb51cb54065d0cd2d613"
  license "BSD-3-Clause"

  # The latest version text is currently omitted from the homepage for this
  # software, so we have to check the related directory listing page.
  livecheck do
    url "https://ftp.indexdata.com/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ad1057911cf5bf3954e78d4807b13829a7daf90cabc936453f1c5070cafbb529"
    sha256 cellar: :any,                 arm64_monterey: "36cba59af3b87ef77791ab04d465a34a5004502463f5d05d7f4db6d08507e328"
    sha256 cellar: :any,                 arm64_big_sur:  "361091099ac41e01950f3a7e6df619fd488db6e8d72b656a3bc77631ea2a6257"
    sha256 cellar: :any,                 ventura:        "d1233260cd3189dd112832516beeb89800b5a3a810d991717eaa6420912ec664"
    sha256 cellar: :any,                 monterey:       "a765ed1270122a317013b5e58094f1fb6e98302bd800de11eee16f426695c8ec"
    sha256 cellar: :any,                 big_sur:        "a15d451af53f2f05d4092059ad76136998a82f366c09114765f99ba4df999200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08bfcbf0170d38b6a6b87eee613dfb7ef70ada5ab140f15936bfedbe4e94c4a7"
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
