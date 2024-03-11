class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.24.5.tar.gz"
  sha256 "fa2dc35bab5184ecbc46a9ef83def2aaaa3f4c9f3c97d4bd19dcb07d4da637de"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "47cb2b77bcb48ee8d8b8fb222bcafe0febe11195ac6476402917da03211412d8"
    sha256 arm64_ventura:  "c7b3fe54045aa9dc0d4da59adc8776a781766b9d72cf629ea6ac3d0935f2e8de"
    sha256 arm64_monterey: "f24fa0ffc6139c1063772ce054602910f6178ae636e32c150c2e6e81a61aa10b"
    sha256 arm64_big_sur:  "5d481ab27cab089083c35830f28e9e8c069708c8692e5ab35160b91f0ada90dd"
    sha256 sonoma:         "3def758612b330624284f14c2617b04caa03f910ee7ee0921553a85f99d541f0"
    sha256 ventura:        "f1d0f59e9cd5863d4d4e29a4f0d7cf1c34da8ab4535d9b9a7b8822dbc4ce5e1b"
    sha256 monterey:       "cf388783b9a7c9f017b3d7f176e8dbf6963f4a96d321a171a14e403b005b1bd4"
    sha256 big_sur:        "5d2a224fb078f5b344070188c8b44307b52610f459104b0b08aa62d4e4016716"
    sha256 x86_64_linux:   "f73c136ea66bb8c7dfd4c35ef3b247ec588ed622c72ad7b425dc4f7a1922dce9"
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
