class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "https://tmate.io/"
  url "https://github.com/tmate-io/tmate/archive/2.3.0.tar.gz"
  sha256 "f837514edbc19180d06b27713628466e68aba91654d748d6e65bfad308f5b00a"
  head "https://github.com/tmate-io/tmate.git"

  bottle do
    cellar :any
    sha256 "92f51ef9496b1877391c008ae7f3a6a5a072ad2c0e5e52b2cebc85d9b98d9235" => :mojave
    sha256 "fe9d988b1e3dbf7f3b2e1beecfdbc5ff25d2331118399331b1477f5b0f0efbb4" => :high_sierra
    sha256 "75df441f4152ecb8f0e04276d7ecc1b2d348503efab8cda5296c2f02c6f38248" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
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
