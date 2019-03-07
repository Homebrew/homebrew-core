class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.20.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.20.1.tar.gz"
  sha256 "b783b390cb571c837b392857945f5a1f00ec6b043177cc42abb8ee1b542ee1b3"
  revision 4

  bottle do
    sha256 "27e8cf4d5455f59447c73f3607911c5448debbd0849bf55bb73d95db2beed687" => :mojave
    sha256 "2323e1201edae18b1e1d7bdc99c5a5bcc168052fadfc2d88384e29e045c6f92e" => :high_sierra
    sha256 "a08923ff33761878bd009dbc83c36c98b1d401811da4ac7cde95e7a85683efa9" => :sierra
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
