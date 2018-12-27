class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.20.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.20.1.tar.gz"
  sha256 "b783b390cb571c837b392857945f5a1f00ec6b043177cc42abb8ee1b542ee1b3"

  bottle do
    rebuild 1
    sha256 "5743f63d80b19c1d12daec5a79ae19677565ae136355d0557f95c8b98ad30ff4" => :mojave
    sha256 "e2e1bf06fff7ca843aa962c36905887bc0007c0bf09ed3fedc4d91c19fe2e138" => :high_sierra
    sha256 "c00609513975abdf6aa24bb41c5a6aea08296b898a81479bdbf264d46a107e5e" => :sierra
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
                          "--disable-debug"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
