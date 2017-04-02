class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "https://tmate.io/"
  url "https://github.com/tmate-io/tmate/archive/2.2.1.tar.gz"
  sha256 "d9c2ac59f42e65aac5f500f0548ea8056fd79c9c5285e5af324d833e2a84c305"
  revision 3

  head "https://github.com/tmate-io/tmate.git"

  bottle do
    cellar :any
    sha256 "6fcea69412c5d4f42017af3912a1d95c8d9c3284784c82fa88b98c679c955e16" => :sierra
    sha256 "55baab86d5d34769fede15c104f4db817718c2398a7ab03e765c543059f5b049" => :el_capitan
    sha256 "a1d0188c1829d71c17b6b29c2a71299dfc37ba65d1f05f5cf8e655afbea08a51" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libevent"
  depends_on "libssh"
  depends_on "msgpack"

  def install
    system "sh", "autogen.sh"

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/tmate", "-V"
  end
end
