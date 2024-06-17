class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.24.5.tar.gz"
  sha256 "fa2dc35bab5184ecbc46a9ef83def2aaaa3f4c9f3c97d4bd19dcb07d4da637de"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "9befdad158e59763fb0622083974a6252878019702d8c961e1bec3a5f5305339"
    sha256 arm64_ventura:  "ac4c0330b70dae06eaa8065bfbea78dda277699d1ae8002478017a1bd9cf1908"
    sha256 arm64_monterey: "02313702fc03880f221d60ce4d0b652c8b44fe68c15609329d757d031bce6bc4"
    sha256 sonoma:         "034528edb247df85f90997aca6a51ddb988a880af6bb571b8473de1702a887af"
    sha256 ventura:        "1b7e2f76c90553543a5e25dadf031c6fcfe280f52bf27d89e04006f9d33fd20b"
    sha256 monterey:       "ffc49a5064a003006e69f51434ac5f7ec4f4019c161ad32fab22c32697db61cd"
    sha256 x86_64_linux:   "6a4642964fe5c4d1cc8cd3507541736d5b984e34a303a814ef550d4f2f8242f9"
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
