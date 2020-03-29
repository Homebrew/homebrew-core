class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "https://tmate.io/"
  url "https://github.com/tmate-io/tmate/archive/2.4.0.tar.gz"
  sha256 "62b61eb12ab394012c861f6b48ba0bc04ac8765abca13bdde5a4d9105cb16138"
  head "https://github.com/tmate-io/tmate.git"

  bottle do
    cellar :any
    sha256 "a278bcb401068bed2434ec48bfb059a86d793a6daa4877574ac0ed7168cb1ebc" => :catalina
    sha256 "7e5158460b898422b4c6e84390d0e8446e2ad52789a30f9942288c5c32acc8a1" => :mojave
    sha256 "0f4f06d0ab7715adc7f6d33cf7d3c08fd057e7f038a666b360ac4ad6a3449ad9" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libssh"
  depends_on "msgpack"

  uses_from_macos "ncurses"

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
