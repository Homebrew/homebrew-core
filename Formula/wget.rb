class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.21.1.tar.gz"
  sha256 "59ba0bdade9ad135eda581ae4e59a7a9f25e3a4bde6a5419632b31906120e26e"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_big_sur: "bedb0887083a2d3ebcfbc03a1fed9919b726810dbbc2cd0efae923ef9d6bd5f4"
    sha256 big_sur:       "307217b813330eda365570d7540aa2da69c678b6c4b78000d24048614902eea8"
    sha256 catalina:      "e9efaae60b98da6832072ff1aa2336d0d12e2ab34df3b9acbc35c81a485ef505"
    sha256 mojave:        "c1709dfb1273aa522226ab34fc9ce73caae56d3536ebae2403017febef9fc256"
    sha256 x86_64_linux:  "0b90bc93557882763d632e443e82ae05a0c2933a5e22d6fb1d0597a3f7833098"
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
                          "--disable-pcre",
                          "--disable-pcre2",
                          "--without-libpsl",
                          "--without-included-regex"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
