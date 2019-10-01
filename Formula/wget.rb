class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.20.3.tar.gz"
  sha256 "31cccfc6630528db1c8e3a06f6decf2a370060b982841cfab2b8677400a5092e"
  revision 1

  bottle do
    rebuild 1
    sha256 "3fe1f4dd8ae633914d99fd211b87e44026645002b552d5cd11d495f0d21aa490" => :catalina
    sha256 "9ff925f814c5ef6f742d4a5680da53944ce5165aa79a7266db74432a5a1d00fe" => :mojave
    sha256 "48a7a42ed210a9511d2672479b8ccbc281f7716cad73d8c951f982317ffa8d5e" => :high_sierra
    sha256 "1af50b43be5defd0be4d82fd6605a212b8c59e15be9fe56a11f888bc41971627" => :sierra
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
  depends_on "openssl@1.1"

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl@1.1"].opt_prefix}",
                          # Work around a gnulib issue with macOS Catalina
                          "gl_cv_func_ftello_works=yes",
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
