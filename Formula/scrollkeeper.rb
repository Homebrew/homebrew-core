class Scrollkeeper < Formula
  desc "Transitional package for scrollkeeper"
  homepage "https://scrollkeeper.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/scrollkeeper/scrollkeeper/0.3.14/scrollkeeper-0.3.14.tar.gz"
  sha256 "4a0bd3c3a2c5eca6caf2133a504036665485d3d729a16fc60e013e1b58e7ddad"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 arm64_monterey: "6de06691bc02972907fa268ce8501559f794454734b2d94894bd41f19cd33c4c"
    sha256 arm64_big_sur:  "88e96878a9f7cef658edaf418c55f7c9e6904aead82bd3102384cbdfb342a400"
    sha256 monterey:       "a9b9a811e7d62586377152f75794cb92b57782611622815816f779a823427cb4"
    sha256 big_sur:        "0cdfc1e87fe8d2281867eb923dfce700906894f6593a763fe79f4afc936f2ad2"
    sha256 catalina:       "9bd348638b9e3492db3549c7ac0756975ca2c57303ec58685bb3e6694fff1dd1"
    sha256 mojave:         "0d7cbee6e25a46848d7c387ba07c4ee110ae2256953d2e5addd26f68e21c645d"
    sha256 high_sierra:    "efa4637b9d1b3942192dca6fb4602ef72ec6b285ba424c087d290c8feb5e2c5b"
    sha256 x86_64_linux:   "81a0061c55b44717079288661e0ecaac1b22d6a72c72b89e98237eb51c099539"
  end

  depends_on "docbook"
  depends_on "gettext"

  uses_from_macos "libxslt"
  uses_from_macos "perl"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "intltool" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "rarian",
    because: "scrollkeeper and rarian install the same binaries"

  resource "XML::Parser" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end
    end

    # Run autoreconf on macOS to rebuild configure script so that it doesn't try
    # to build with a flat namespace.
    system "autoreconf", "--force", "--verbose", "--install" if OS.mac?
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make", "install"
  end

  test do
    seriesid1 = shell_output("scrollkeeper-gen-seriesid").strip
    seriesid2 = shell_output("scrollkeeper-gen-seriesid").strip
    assert_match(/^\h+(?:-\h+)+$/, seriesid1)
    assert_match(/^\h+(?:-\h+)+$/, seriesid2)
    refute_equal seriesid1, seriesid2
  end
end
