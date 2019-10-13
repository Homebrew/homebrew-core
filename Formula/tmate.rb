class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "https://tmate.io/"
  url "https://github.com/tmate-io/tmate/archive/2.3.1.tar.gz"
  sha256 "21cb6029d09e3809e37b9b8f1cd96b452197b8c2e28d3551d674b8e580bf4048"
  head "https://github.com/tmate-io/tmate.git"

  bottle do
    cellar :any
    sha256 "16e2fa021baa7d24a83bfe07989739d91d8d3424a56bf875e660a9130fa1589e" => :catalina
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
