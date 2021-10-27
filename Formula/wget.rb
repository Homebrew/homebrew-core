class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.21.2.tar.gz"
  sha256 "e6d4c76be82c676dd7e8c61a29b2ac8510ae108a810b5d1d18fc9a1d2c9a2497"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "571ef7b59ebab2aa947485aa33bf612d001d51f5bbc89b59d00ac39712b846c8"
    sha256 arm64_big_sur:  "4f8b66c5f181f01064522a80bfda72eabddd47299a8b88bc7d0022c457e72594"
    sha256 monterey:       "b6d6f422e3c4db0607caf5fc91dba4fb19b3c52883d7a012c9fc11b872b14bad"
    sha256 big_sur:        "7a8e6512e0890076b9ebc4f8db6165d70b4bd05e04dfc0491519ba3c91a5c21e"
    sha256 catalina:       "3b191bb28b5011e7a105ae76427f6dd21a1e12c33da2273b7e01ef2110f0f375"
    sha256 mojave:         "e0d4b68c9e5abeaa6395241c43307c4bbd26133cd63d136321974535788c37e9"
    sha256 x86_64_linux:   "1c102dc1129e508f7788824ea6ef4db4656fbab2a6a4b54419689925a5ed6855"
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  depends_on "pkg-config" => :build
  depends_on "libidn2"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl@1.1"].opt_prefix}",
                          "--disable-pcre",
                          "--disable-pcre2",
                          "--without-libpsl",
                          "--without-included-regex"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
