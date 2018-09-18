class Tlsdate < Formula
  desc "Secure rdate replacement"
  homepage "https://www.github.com/ioerror/tlsdate/"
  url "https://github.com/ioerror/tlsdate/archive/tlsdate-0.0.13.tar.gz"
  sha256 "90efdff87504b5159cb6a3eefa9ddd43723c073d49c4b3febba9e48fc1292bf9"
  head "https://github.com/ioerror/tlsdate.git"

  bottle do
    sha256 "3c33940ba1ca145ebd4d62e52c690bff6d537ded3441f3f4b060738dc730cb0c" => :mojave
    sha256 "f84b34785fda2e7229b0bef6bb1a13c3d128c03413c1d81c08333d9d0ee0732f" => :high_sierra
    sha256 "0d2b8b903299eae65fe12cfb5d5d7a7bcfabfad1f9be4a0870cdfeee7040b4ff" => :sierra
    sha256 "c7d7ea17bf9e7cb9b897a0f0aeed0ef3c50f2c309e0b6055fdfe7bee3aca5152" => :el_capitan
    sha256 "58bfadb241575316ab6877c584a09e3681084165bfd733430e5c3f4b0b8be494" => :yosemite
    sha256 "cf446ccff505ef69dd583f61d82a61420697b39c66c2cd2f006944d688ac8fee" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  # Upstream PR to fix the build on macOS
  patch do
    url "https://github.com/ioerror/tlsdate/pull/160.patch?full_index=1"
    sha256 "c2af25386fd7ffa889e421e864fdd72bbf90f2551347e6155ad7fb7b13122b90"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tlsdate", "--verbose", "--dont-set-clock"
  end
end
