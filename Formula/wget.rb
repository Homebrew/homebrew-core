class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.19.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.19.2.tar.gz"
  sha256 "4f4a673b6d466efa50fbfba796bd84a46ae24e370fa562ede5b21ab53c11a920"
  revision 1

  bottle do
    sha256 "e0408315c0dc9ff5c70a2dd0d95067da7b819e836db1241df84337fc13f456c1" => :high_sierra
    sha256 "381e209d4c0af56747f2a4ae4671d381e4a8043d4e7a3f5548b4be20bea68186" => :sierra
    sha256 "a9ada441a2b4e1fde1cdb26e492d80625e0ab36771ee26c52e2446f4f6870100" => :el_capitan
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
