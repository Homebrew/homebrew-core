class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.19.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.19.4.tar.gz"
  sha256 "93fb96b0f48a20ff5be0d9d9d3c4a986b469cb853131f9d5fe4cc9cecbc8b5b5"

  bottle do
    sha256 "1de903a28c501c55e9e2b7cb1ecc9a767ea39bd7fe9b9257a6f886c72b169a14" => :high_sierra
    sha256 "adc8864a83b30f618ea40b6f79eed6605877cfa0524a8f53b4cc7b2d187cb0b2" => :sierra
    sha256 "bb393524dc9f5ae639d09200d594646ae5c9c11147d0c4ce00adb70fcdefdf3b" => :el_capitan
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
