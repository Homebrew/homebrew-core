class Twemcache < Formula
  desc "Twitter fork of memcached"
  homepage "https://github.com/twitter/twemcache"
  url "https://github.com/twitter/twemcache/archive/v2.6.3.tar.gz"
  sha256 "ab05927f7d930b7935790450172187afedca742ee7963d5db1e62164e7f4c92b"
  head "https://github.com/twitter/twemcache.git"

  bottle do
    cellar :any
    sha256 "3bb92984e15ff8517bc60d961407b9a8799373e4785f419dc32fd4cc83d1d08f" => :mojave
    sha256 "7992ac700ca1044335e84a77d09152b2b4a214dd595064f462049dd0ad65d92e" => :high_sierra
    sha256 "cd20b77b8e04478fb459fcd3b31bb49f4c6015362420b8ffd726305af9763895" => :sierra
    sha256 "fd57a26c75cb67d097894a9c757bd50b2799b1a6e8ba20510345a1f1ef5eee61" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"twemcache", "--help"
  end
end
