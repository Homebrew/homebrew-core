class Slrn < Formula
  desc "Powerful console-based newsreader"
  homepage "https://slrn.info/"
  url "https://jedsoft.org/releases/slrn/slrn-1.0.3a.tar.bz2"
  sha256 "3ba8a4d549201640f2b82d53fb1bec1250f908052a7983f0061c983c634c2dac"
  license "GPL-2.0-or-later"
  revision 1
  head "git://git.jedsoft.org/git/slrn.git", branch: "master"

  livecheck do
    url "https://jedsoft.org/releases/slrn/"
    regex(/href=.*?slrn[._-]v?(\d+(?:\.\d+)+(?:[a-z]?\d*)?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "58fc905615d5e7b14fd19c8d790ec88a2ecd13e73ac2206e6f23d62f47e96f68"
    sha256 arm64_big_sur:  "b714ac9c245119ba08001c7729f77093491457c54f17b2d1d09184f690ffa288"
    sha256 monterey:       "2a01ba80ca3bc05f40f4da7d1fae0e72029e9f07a8d42eb265ad37efc36812e0"
    sha256 big_sur:        "1e3a47c2adbd775237d1b34cba86c82a14096d792a922887f76f6eadb0964513"
    sha256 catalina:       "5440f5353ec5ae3f3a2cdd3ed43b931bd41db738ee4b993b0ec3b41618f7406f"
    sha256 mojave:         "35550c096c81454ae0756d0831fa8a6dd2db9857db591b72f8cf96aeb4e4fac3"
    sha256 x86_64_linux:   "e9f1013ef2eb1b03c54754621b7669de769a87f412f025d5f83d8c1ee2efe5c9"
  end

  depends_on "openssl@1.1"
  depends_on "s-lang"

  def install
    bin.mkpath
    man1.mkpath
    mkdir_p "#{var}/spool/news/slrnpull"

    # Work around configure issues with Xcode 12.  Hopefully this will not be
    # needed after next slrn release.
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
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
