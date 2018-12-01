class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.20.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.20.tar.gz"
  sha256 "8a057925c74c059d9e37de63a63b450da66c5c1c8cef869a6df420b3bb45a0cf"

  bottle do
    sha256 "cd2a2237a28814d98fb2e938ea0c99b404314a3512d87eb1ef4b69c184a06178" => :mojave
    sha256 "bdb2f184c887cb1166bc049bcfff1b999460e9e38ba80504f41217f9dfc52178" => :high_sierra
    sha256 "fd41c3a34906f621754f28b2ae914aaa2f539d7644e9afe2099eeb44fcea0281" => :sierra
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
