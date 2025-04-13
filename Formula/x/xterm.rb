class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-398.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_398.orig.tar.gz"
  sha256 "f679bd45f97063f10a880ecf7fc1611a9a03e8c8b98f063e99e0a079e87ee968"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1fcfae23f3f5b7186bc395351a972b7b8315752f738a85421f089475e8888b40"
    sha256 arm64_sonoma:  "dae7aecd961a28b7b6f8ad957da4e7914d6b118f202330f25d7665d6ba682a3e"
    sha256 arm64_ventura: "2c30e05f808cc7dbd697155e995e56e3145ba6c2d4635c889bb7b7c1e39d5b62"
    sha256 sonoma:        "f7929bbe56571f2a58abee25c613e29bc6af32bc7ebaf726ad485d9f643c7832"
    sha256 ventura:       "34e46dc4e1be70d6d479ce84073c5d9ab7ee4de5590e37453b31454005de3f13"
    sha256 arm64_linux:   "00b628a14150b51092402144b286c74d71e4dd86d95ec900db7d3a95e3478692"
    sha256 x86_64_linux:  "6ddecd312c2c27401881e90ced7bc8e1bf62db10ae6382d34d25111cb1e1dc0a"
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

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_path_exists bin/exe
      assert_predicate bin/exe, :executable?
    end
  end
end
