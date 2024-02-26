class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-390.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_390.orig.tar.gz"
  sha256 "75117c3cc5174a09c425ef106e69404d72f5ef05e03a5da00aaf15792d6f9c0f"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a738aa020e131d096bb313cc02e5158d62f8d7d51ff8d62f821a9b88e7e9313c"
    sha256 arm64_ventura:  "e3d307c6962002116fa7150c5765ff473dd106693f1470fb3b53107fb8444c5f"
    sha256 arm64_monterey: "c46e1d7a3ed45f813ec1e652edf4ca91c05f7245a6da57a4828cbedcdc2ec0fa"
    sha256 sonoma:         "60096fbe32ccf7b2507eee82f4a51f27b43b9ed25faad33ca136a527945bd248"
    sha256 ventura:        "6519752d0c6364202387d56e6760c1fbd61f1d2db7845fc25f7fb07fae81a106"
    sha256 monterey:       "a5d9f029e28685f0d89598ad48f184e862e964696ce558bc952e415d6c4973e2"
    sha256 x86_64_linux:   "fa32bc98593ce01aa5a7d9a5b3b2d0b6e61900863641f6827c0efc1bf7a071ea"
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_predicate bin/exe, :exist?
      assert_predicate bin/exe, :executable?
    end
  end
end
