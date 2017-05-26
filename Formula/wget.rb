class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.19.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.19.1.tar.gz"
  sha256 "9e4f12da38cc6167d0752d934abe27c7b1599a9af294e73829be7ac7b5b4da40"

  bottle do
    sha256 "7015cd6c9406ae5ca4cd74d54bcd706716a875f58620820789f0679213e3f3f8" => :sierra
    sha256 "543f4592707e20753528da6850a47f01150d277f1e8b508cc45bf339dbc5c242" => :el_capitan
    sha256 "3f69c50c8bb6baec19fe880881e99dcc134ead22ed47180302d1657b46f31b42" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  deprecated_option "enable-debug" => "with-debug"
  deprecated_option "enable-iri" => "with-iri"
  deprecated_option "with-iri" => "with-libidn2"

  option "with-debug", "Build with debug support"
  option "with-libidn2", "Build with support for Internationalized Domain Names"

  depends_on "pkg-config" => :build
  depends_on "pod2man" => :build if MacOS.version <= :snow_leopard
  depends_on "openssl"
  depends_on "pcre" => :optional
  depends_on "libmetalink" => :optional
  depends_on "gpgme" => :optional
  depends_on "libunistring" if build.with? "libidn2"

  resource "libidn2" do
    url "https://ftp.gnu.org/gnu/libidn/libidn2-2.0.2.tar.gz"
    mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.0.2.tar.gz"
    sha256 "8cd62828b2ab0171e0f35a302f3ad60c3a3fffb45733318b3a8205f9d187eeab"
  end

  def install
    # Fixes undefined symbols _iconv, _iconv_close, _iconv_open
    # Reported 10 Jun 2016: https://savannah.gnu.org/bugs/index.php?48193
    ENV.append "LDFLAGS", "-liconv"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula["openssl"].opt_prefix}
    ]

    args << "--disable-debug" if build.without? "debug"
    args << "--disable-pcre" if build.without? "pcre"
    args << "--with-metalink" if build.with? "libmetalink"
    args << "--with-gpgme-prefix=#{Formula["gpgme"].opt_prefix}" if build.with? "gpgme"

    if build.with? "libidn2"
      resource("libidn2").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--disable-silent-rules",
                              "--prefix=#{libexec}/vendor/libidn2",
                              "--with-packager=Homebrew"
        system "make", "install"
      end
      ENV.prepend "LDFLAGS", "-L#{libexec}/vendor/libidn2/lib"
      ENV.prepend "CPPFLAGS", "-I#{libexec}/vendor/libidn2/include"
      args << "--enable-iri"
    else
      args << "--disable-iri"
    end

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
