class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.20.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.20.1.tar.gz"
  sha256 "b783b390cb571c837b392857945f5a1f00ec6b043177cc42abb8ee1b542ee1b3"
  revision 2

  bottle do
    sha256 "cf0015a7ddf079f83c5938b8724cb1a45472be5eddffd917fbb9d398f2c33873" => :mojave
    sha256 "bec2cf88b421a1d2759111054f98df21caa6602282897f81473c18b9c14ed0e4" => :high_sierra
    sha256 "39383f48327c93865b7f199e306f8f9e0e3051235a2f432e1e65493780df58df" => :sierra
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  depends_on "pkg-config" => :build
  depends_on "pod2man" => :build if MacOS.version <= :snow_leopard
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
                          "--disable-pcre2"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
