class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.21.3.tar.gz"
  sha256 "5726bb8bc5ca0f6dc7110f6416e4bb7019e2d2ff5bf93d1ca2ffcc6656f220e5"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "a205f83efcbd5cfe22e70261f2b8afdca71cb172222ee3106bb44bc3512414ca"
    sha256 arm64_monterey: "d1f955187691ad37ede6c33a1eabcd9f25b2f9841fc51ca3422a6cd8e830bd64"
    sha256 arm64_big_sur:  "ea51216e20e8e7e8d13370c54f2282d7bbf472af73550a685cd7bbf78ed9af89"
    sha256 ventura:        "24d0f69261b578a8f7c80130cf695a78b9b0a554405d63a30ad7d36c487ce789"
    sha256 monterey:       "6f17f29657928ecbd76873ef55ee572414650dfc431c28e0587351532b251ae7"
    sha256 big_sur:        "e33bd34193575636ee2b7cc761821e316d475947b95280a296069324ee31f44f"
    sha256 x86_64_linux:   "47534590ea4e6468e74fe5945d28ab87510efab485490a132f7fb3bd02686e5d"
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
  depends_on "openssl@3"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl@3"].opt_prefix}",
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
