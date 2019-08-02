class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "https://tmate.io/"
  url "https://github.com/tmate-io/tmate/archive/2.3.0.tar.gz"
  sha256 "f837514edbc19180d06b27713628466e68aba91654d748d6e65bfad308f5b00a"
  head "https://github.com/tmate-io/tmate.git"

  bottle do
    cellar :any
    sha256 "788ab394a785b79e997e8324b0973cf70ef5d214d4c2427869b36c032d77d45b" => :mojave
    sha256 "9f6b37c2a0011b255d3a5c39e0bf653e8271d4f8cfc4306bc615ddf77946b442" => :high_sierra
    sha256 "a3a692cff9eba1a68eef998577050169da2eb3930e9e12902a33c689ed904548" => :sierra
    sha256 "95dac4cc5d9fc02d7a7d832d471b4911b52e97ced0ab98e902c84d33ee54dc7c" => :el_capitan
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
