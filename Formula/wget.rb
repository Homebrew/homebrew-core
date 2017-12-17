class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.19.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.19.2.tar.gz"
  sha256 "4f4a673b6d466efa50fbfba796bd84a46ae24e370fa562ede5b21ab53c11a920"
  revision 1

  bottle do
    sha256 "4f6896bbed75ea89f04d849357390b32e7462b86c8a3063dca85c9f5f7db1aaa" => :high_sierra
    sha256 "d8b3ae9836eed0145615ca95132e76784a93c0f4a1f43a5b4f4af49b712d3020" => :sierra
    sha256 "ab41d6f569535c4a19a64ea3f03f477818d66e56a86f8b9e1631311f5a4cca44" => :el_capitan
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  deprecated_option "enable-debug" => "with-debug"

  option "with-debug", "Build with debug support"

  depends_on "pkg-config" => :build
  depends_on "pod2man" => :build if MacOS.version <= :snow_leopard
  depends_on "libidn2"
  depends_on "openssl@1.1"
  depends_on "pcre" => :optional
  depends_on "libmetalink" => :optional
  depends_on "gpgme" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula["openssl@1.1"].opt_prefix}
    ]

    args << "--disable-debug" if build.without? "debug"
    args << "--disable-pcre" if build.without? "pcre"
    args << "--with-metalink" if build.with? "libmetalink"
    args << "--with-gpgme-prefix=#{Formula["gpgme"].opt_prefix}" if build.with? "gpgme"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
