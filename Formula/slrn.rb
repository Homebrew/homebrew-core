class Slrn < Formula
  desc "Powerful console-based newsreader"
  homepage "https://slrn.sourceforge.io/"
  url "https://jedsoft.org/releases/slrn/slrn-1.0.3a.tar.bz2"
  sha256 "3ba8a4d549201640f2b82d53fb1bec1250f908052a7983f0061c983c634c2dac"

  head "git://git.jedsoft.org/git/slrn.git"

  bottle do
    sha256 "73238ccdd5f84b813446674f5be88f604c4e44107ab5bf367caee0bdd00ea410" => :high_sierra
    sha256 "46721d6d7a4ac469837a4e41bfdc279727ee7c3dd38351eb3d47aa7b43e64062" => :sierra
    sha256 "d45e3c8765302bd61709b091143becf4c7ce78913256620c956dcf2b95431910" => :el_capitan
    sha256 "06d71ffeb008854c63eeadf6f45633cf692e648490cb20c2ba5f3229cc3dc808" => :yosemite
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
