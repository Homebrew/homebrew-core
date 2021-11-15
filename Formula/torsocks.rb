class Torsocks < Formula
  desc "Use SOCKS-friendly applications with Tor"
  homepage "https://gitweb.torproject.org/torsocks.git/"
  url "https://git.torproject.org/torsocks.git",
      tag:      "v2.3.0",
      revision: "cec4a733c081e09fb34f0aa4224ffd7b687fb310"
  head "https://git.torproject.org/torsocks.git"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "9d03fd12643e5ee1f023e316b5e8fca4837d4021c47f3ccbc3e12000c00f663f"
    sha256 arm64_big_sur:  "3882e64c21d610b6e0fdb6e3bceb41a4ae9494849ced24901f0b50946b34a296"
    sha256 monterey:       "88ddbac1ee6a4197bece3921800234395129d11733d3a1713519b57f449f9335"
    sha256 big_sur:        "2e7d1f1ed60e53086456447d408f577a8ee8d10c73ea8e01b94f7fdbaf6cd141"
    sha256 catalina:       "0fe4e287d086c2249645781e187dd12e45526ab6ed45b32051aac2ddb840dc92"
    sha256 mojave:         "8f07df71ce2b8eee8ade8ac9c4de7c5e59acebb880b369dd3bd2d5caf5a93e8e"
    sha256 x86_64_linux:   "439ed3da7de466d90191d08110cf96e5f435331e2d2e439accfdf8c89357799b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # https://gitlab.torproject.org/legacy/trac/-/issues/28538
  patch do
    url "https://gitlab.torproject.org/legacy/trac/uploads/9efc1c0c47b3950aa91e886b01f7e87d/0001-Fix-macros-for-accept4-2.patch"
    sha256 "97881f0b59b3512acc4acb58a0d6dfc840d7633ead2f400fad70dda9b2ba30b0"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/torsocks", "--help"
  end
end
