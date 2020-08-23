class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.20.3.tar.gz"
  sha256 "31cccfc6630528db1c8e3a06f6decf2a370060b982841cfab2b8677400a5092e"
  revision 2

  bottle do
    sha256 "ef65c759c5097a36323fa9c77756468649e8d1980a3a4e05695c05e39568967c" => :catalina
    sha256 "28f4090610946a4eb207df102d841de23ced0d06ba31cb79e040d883906dcd4f" => :mojave
    sha256 "91dd0caca9bd3f38c439d5a7b6f68440c4274945615fae035ff0a369264b8a2f" => :high_sierra
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

  on_linux do
    depends_on "util-linux"
  end

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
