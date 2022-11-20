class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "https://tmate.io/"
  url "https://github.com/tmate-io/tmate/archive/2.4.0.tar.gz"
  sha256 "62b61eb12ab394012c861f6b48ba0bc04ac8765abca13bdde5a4d9105cb16138"
  license "ISC"
  head "https://github.com/tmate-io/tmate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8dd348850ee2dcc734eb9d148495406df82136ddec0d8e50ebef480128db3f10"
    sha256 cellar: :any,                 arm64_monterey: "0b067f5ce9b9019b93dccf8447cab6c7c6a3dac573ce914c9534079fea180d01"
    sha256 cellar: :any,                 arm64_big_sur:  "d92025cef2400ab0fcb0f8efa5866e180fff73486db2e73f4e77b5d1afba5d97"
    sha256 cellar: :any,                 ventura:        "00d387966abc3146d0cfb59e73b31802265573c3e0f7a74eaed39d0b76f5fa68"
    sha256 cellar: :any,                 monterey:       "b914a728ce6481c4379668b5cac0db712f78d37cc922f97786369fcb8be232fb"
    sha256 cellar: :any,                 big_sur:        "215c8724caffc137265dc5fa565bed563b5bd8d046b0e54addcf1628d60a9268"
    sha256 cellar: :any,                 catalina:       "a278bcb401068bed2434ec48bfb059a86d793a6daa4877574ac0ed7168cb1ebc"
    sha256 cellar: :any,                 mojave:         "7e5158460b898422b4c6e84390d0e8446e2ad52789a30f9942288c5c32acc8a1"
    sha256 cellar: :any,                 high_sierra:    "0f4f06d0ab7715adc7f6d33cf7d3c08fd057e7f038a666b360ac4ad6a3449ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3b3d87ea67d6ee52e3775578b7f37d46cca673aae9f412484439d10e9de620"
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
