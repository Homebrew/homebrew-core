class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-*
  url "https://dotsrc.dl.osdn.net/osdn/yash/77664/yash-2.53.tar.xz"
  sha256 "e430ee845dfd7711c4f864d518df87dd78b40560327c494f59ccc4731585305d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://osdn.net/projects/yash/releases/rss"
    regex(%r{(\d+(?:\.\d+)+)</title>}i)
  end

  bottle do
    sha256 arm64_ventura:  "252f74f50cb198c22a6f70b4f7b5442b328b4cb1ab26d22a920123725a52858e"
    sha256 arm64_monterey: "eeeeb786b844bf03a25850972e27ceb0e9c7814f4deec7487463d69b387cd897"
    sha256 arm64_big_sur:  "11ccd561d0cf5e20aed78acedf51bce5ae2d79fdff9941837e40ea546252e4b6"
    sha256 ventura:        "4b25667a22b83fc369d3d9bcd019fc92d819e75f09040973d39e6eeeacac8f65"
    sha256 monterey:       "ba17c533a242d1d10ecc36a6e8984c8f15733babd6d4df1d8b920f080447f402"
    sha256 big_sur:        "7bed4424790d3ce44dcea25c4c6726a6850ad28b390d013d7bbe361f28e3f66b"
    sha256 catalina:       "a80f8bf4f399c71c4e7081b49ab20ef0ac97b2d2e9d72b5a87116c899b6ed24d"
    sha256 x86_64_linux:   "9c3606fcd75067b35fdad853c9c2eb03c3ddb25713fd9ff10a18027c3859d1d1"
  end

  head do
    url "https://github.com/magicant/yash.git", branch: "trunk"

    depends_on "asciidoc" => :build
  end

  depends_on "gettext"

  def install
    system "sh", "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/yash", "-c", "echo hello world"
  end
end
