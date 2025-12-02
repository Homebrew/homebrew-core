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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:    "56945818d9c3961dc59b94440485c9c80baf04f29d791efa2803192b9ede727c"
    sha256 arm64_sequoia:  "439ad507d119a98349f0cc8422d9ef91125faa53a802a55078f11f1e7bb53fc4"
    sha256 arm64_sonoma:   "0b85878ca8073bc06e77875e5d106aebc10ff664d85e23e77c1b7a944d8fc565"
    sha256 arm64_ventura:  "f802b3c9ffb6f3974d353225cf25e52605d6c25fa85dbfd9b9710a33d075218b"
    sha256 arm64_monterey: "03933542674c0ea7206e58e91879b25b068609a954231a7fe1bf64b9636a7ca3"
    sha256 arm64_big_sur:  "deb43212975b4d77acb6d79eb556990588a71d47a94029f24736bc1661bb18eb"
    sha256 sonoma:         "eb1b5847ca10bebffed3fb3fc5fadc37340d845780e536c020670fb6d6f01eb8"
    sha256 ventura:        "409721aae6f317e0e3e0b471c7488dd634585a193957c4feb7916a6a645768a1"
    sha256 monterey:       "8018c76bf03539804c59b85442cb2c8b578208f0a8b0ea325b559b810cc4a8cf"
    sha256 big_sur:        "e29042ebfccfb58c2ce1883f763173da76c5a38d190e98255abebf6dc632e343"
    sha256 arm64_linux:    "068f15a993a5007e14a1f8f1daf439682aedc5a098b58b271496f7996d011b5d"
    sha256 x86_64_linux:   "5bf9ff614629b46445541310dd089e4893dbfa2e463944aff5596cb14476f812"
  end

  depends_on "openssl@3"
  depends_on "s-lang"

  def install
    bin.mkpath
    man1.mkpath
    mkdir_p "#{var}/spool/news/slrnpull"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", *std_configure_args,
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          "--with-slrnpull=#{var}/spool/news/slrnpull",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    ENV.deparallelize
    system "make", "all", "slrnpull"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match version.to_s, shell_output("#{bin}/slrn --show-config")
  end
end
