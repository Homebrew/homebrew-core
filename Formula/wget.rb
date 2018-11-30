class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.19.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.19.5.tar.gz"
  sha256 "b39212abe1a73f2b28f4c6cb223c738559caac91d6e416a6d91d4b9d55c9faee"

  bottle do
    sha256 "0e7d518c4c110edec0c684f2be9d44e31ec1542343392b712ef378b4e131ebd4" => :mojave
    sha256 "af8880a424be0cde4d2891b0027ae9991ebb0e6f48ae60b369e3c9f0bdfcd04a" => :high_sierra
    sha256 "d61954cc95b1f60b64b86afa2a71a18d6d1676dbc3d566a3f9ba2249ad028b54" => :sierra
    sha256 "473408a17dfea7393f2c8c96264535717328c3879db679fc09fc1007bac26113" => :el_capitan
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
    system "./bootstrap" if build.head?
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
