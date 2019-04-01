class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.20.2.tar.gz"
  sha256 "7e43b98cb5e10234836ebef6faf24c4d96c0ae7a480e49ff658117cc4793d166"

  bottle do
    sha256 "4aae847c2f472574ed1dd7b1f8ec39e76e5a0255b0d96e16e3991dcf03ec5f19" => :mojave
    sha256 "164910d41a28ee8b54a7fd389275674e791d7faf5103351d972f191292becd84" => :high_sierra
    sha256 "97690245f29922c0e4b338aacc258fe0ba20724a08423fc9a7c3ccb1d2cefbcc" => :sierra
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
  depends_on "openssl"

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl"].opt_prefix}",
                          "--disable-debug",
                          "--disable-pcre",
                          "--disable-pcre2",
                          "--without-libpsl"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
