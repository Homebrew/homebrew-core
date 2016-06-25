class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "https://tmate.io/"
  url "https://github.com/tmate-io/tmate/archive/2.2.1.tar.gz"
  sha256 "d9c2ac59f42e65aac5f500f0548ea8056fd79c9c5285e5af324d833e2a84c305"
  revision 2

  head "https://github.com/tmate-io/tmate.git"

  bottle do
    cellar :any
    sha256 "cf21009a5a1d3d41e111d607d157510934d1c6db5fa1c72698af98a2d38ca5aa" => :el_capitan
    sha256 "f3f6a40c9393292a94862cd4f36f9a27e4d3c4077699b5196d417cc3d97a7daf" => :yosemite
    sha256 "2aa8a5a8934bbe0cc9271937500e26b97bedb7659a50560152bbd5f060b704ad" => :mavericks
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
