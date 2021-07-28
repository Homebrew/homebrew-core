class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.21.1.tar.gz"
  sha256 "59ba0bdade9ad135eda581ae4e59a7a9f25e3a4bde6a5419632b31906120e26e"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "ab03f58f6d9a4018b1b0bfd53e5b797fcd90b86b1d60b20948de499ec4d4c6b4"
    sha256 big_sur:       "277577a3a30ff9bf60d0e4b819570ca356aade39a3a5973065e89b0ad4b752f3"
    sha256 catalina:      "261ea49956e98d62975c1706cb839c6411473a7ec50ae8101526010275fe70c0"
    sha256 mojave:        "df85a11661c551e9fe30445b6173e82c83d80a0622191a9c57f0edf6b21782d1"
    sha256 x86_64_linux:  "d867d78ce4327653990116aad3cbeeba1a3aee1530eb3cf17f5de1441849e834"
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
