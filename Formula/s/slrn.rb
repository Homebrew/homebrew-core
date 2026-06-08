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
    rebuild 3
    sha256 arm64_tahoe:   "d12aa6f4674216c6c7ceb66061ea61501d3ef0697e2544309b9534b22072cf77"
    sha256 arm64_sequoia: "2414f63cb9c68b2fcf95b67d049d1399b444731a278de210f593cbdba0bf3bfb"
    sha256 arm64_sonoma:  "2117e0a8177c4b02606d061f4cd6e7a1ec0b9d9a45414442fc6a4216fc7b74b1"
    sha256 sonoma:        "849607a38e934b1cde9460b3b3fac5d9bbbe52e6a6eae58771d71acedf97b1cc"
    sha256 arm64_linux:   "659efed3f9437c38028c8c48922eaf0ec6c65afe781f703883e3db08699f4061"
    sha256 x86_64_linux:  "a47454b9d0afb4578fcd6dd2c7258aec6396edea231b18f167171f4ed9f1dad3"
  end

  depends_on "openssl@4"
  depends_on "s-lang"

  def install
    bin.mkpath
    man1.mkpath
    mkdir_p "#{var}/spool/news/slrnpull"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", *std_configure_args,
                          "--with-ssl=#{Formula["openssl@4"].opt_prefix}",
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
