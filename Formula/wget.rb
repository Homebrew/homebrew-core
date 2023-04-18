class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.21.3.tar.gz"
  sha256 "5726bb8bc5ca0f6dc7110f6416e4bb7019e2d2ff5bf93d1ca2ffcc6656f220e5"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "7415a3b847237e0a981f2df42761578d6b6b285361c450c010219355bd1c0df2"
    sha256 arm64_monterey: "ed959d9bd75bfac18aa823bd62c8e5f4736174fd183aee9ebaa913d0810dea36"
    sha256 arm64_big_sur:  "42233b960709325f6e4ec479eb1786379e1b3757b4b7641bdbbd8e6a058e1013"
    sha256 ventura:        "0915596ebf9426fc9aad9307a6813ba35ac860e9dfa755741a23e9d446ac3b93"
    sha256 monterey:       "f97fc2639cd9d2d037c2bf1a94fa664ef2d81143ce8a1fb5b740ce2eb397889c"
    sha256 big_sur:        "f85c6720bdabd86db32dd54837f577b709bc5de98896622a19f698f8a14e604f"
    sha256 x86_64_linux:   "738ec27b5b39877b8004096d9c3edd04ff814e18dd6f6afca89a2f5b4eeedcac"
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
  depends_on "openssl@3"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl@3"].opt_prefix}",
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
