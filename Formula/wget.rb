class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.20.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.20.1.tar.gz"
  sha256 "b783b390cb571c837b392857945f5a1f00ec6b043177cc42abb8ee1b542ee1b3"
  revision 3

  bottle do
    sha256 "55391a9d887a73b73ce4572876b2887fd6a8059a5f23dc1ec6d2522224be21ce" => :mojave
    sha256 "43424a93c4209fd6699c782307071999850c1b03f52b5654ec061d709b1f6f2f" => :high_sierra
    sha256 "bfa299d95e3667ff902c9aeeaa1217dc288f9b374996382f914393a718a5534c" => :sierra
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
                          "--disable-pcre2",
                          "--without-libpsl"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
