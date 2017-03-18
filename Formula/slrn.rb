class Slrn < Formula
  desc "Powerful console-based newsreader"
  homepage "https://slrn.sourceforge.io/"
  url "http://jedsoft.org/releases/slrn/slrn-1.0.3a.tar.bz2"
  sha256 "3ba8a4d549201640f2b82d53fb1bec1250f908052a7983f0061c983c634c2dac"

  head "git://git.jedsoft.org/git/slrn.git"

  bottle do
    sha256 "930c23567b3808175fdf01fdda647045c62291eef3202212b112a0ee063c88af" => :sierra
    sha256 "d2133ed755fd711a95ccc7d94f716d3f792d6b787e28e573a528fe9e60784bc9" => :el_capitan
    sha256 "53301c562341b8443fee424b3b3c8118f52e8e19249e00460e2b4e18b2c20e9f" => :yosemite
    sha256 "7f3179279619eeff0bd9ec3ca02637595f0cef4ba65860602069ada1a459b5ac" => :mavericks
    sha256 "27b04746ba09720a832c3691a2997d52baf5daf4b2a368a4081eb2554449b270" => :mountain_lion
  end

  depends_on "s-lang"
  depends_on "openssl"

  def install
    bin.mkpath
    man1.mkpath
    mkdir_p "#{var}/spool/news/slrnpull"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-slrnpull=#{var}/spool/news/slrnpull",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make", "all", "slrnpull"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match version.to_s, shell_output("#{bin}/slrn --show-config")
  end
end
