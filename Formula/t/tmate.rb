class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "https://tmate.io/"
  license "ISC"
  head "https://github.com/tmate-io/tmate.git", branch: "master"

  stable do
    url "https://github.com/tmate-io/tmate/archive/refs/tags/2.4.0.tar.gz"
    sha256 "62b61eb12ab394012c861f6b48ba0bc04ac8765abca13bdde5a4d9105cb16138"

    # Fix finding `msgpack`
    # https://github.com/tmate-io/tmate/pull/281
    patch do
      url "https://github.com/tmate-io/tmate/commit/a5c6e80d3c54cd7faed52de5283b4f96bea86c13.patch?full_index=1"
      sha256 "d48006bf00d6addd5db7c6b875b7a890d6f9bc1a8984a9e12e1087af5ff58f35"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e05c861a81f5b44cf1c246ef007a24de34c6499c7c6b1fdf97ccfb9f9d43f3d4"
    sha256 cellar: :any,                 arm64_sequoia:  "b27b6f267188c6bd851cf061dc7fabf97a127c7930a57070cb46caf0333ef71f"
    sha256 cellar: :any,                 arm64_sonoma:   "1d2e440f793063b6f35862278723efe92afdbe5bab8a23bff6bf122b3f6a61f9"
    sha256 cellar: :any,                 arm64_ventura:  "8dd348850ee2dcc734eb9d148495406df82136ddec0d8e50ebef480128db3f10"
    sha256 cellar: :any,                 arm64_monterey: "0b067f5ce9b9019b93dccf8447cab6c7c6a3dac573ce914c9534079fea180d01"
    sha256 cellar: :any,                 arm64_big_sur:  "d92025cef2400ab0fcb0f8efa5866e180fff73486db2e73f4e77b5d1afba5d97"
    sha256 cellar: :any,                 sonoma:         "2dd07e9beb1e9fbd1ccad386ddd78d13a0932349312580728090b9414c3e45a5"
    sha256 cellar: :any,                 ventura:        "00d387966abc3146d0cfb59e73b31802265573c3e0f7a74eaed39d0b76f5fa68"
    sha256 cellar: :any,                 monterey:       "b914a728ce6481c4379668b5cac0db712f78d37cc922f97786369fcb8be232fb"
    sha256 cellar: :any,                 big_sur:        "215c8724caffc137265dc5fa565bed563b5bd8d046b0e54addcf1628d60a9268"
    sha256 cellar: :any,                 catalina:       "a278bcb401068bed2434ec48bfb059a86d793a6daa4877574ac0ed7168cb1ebc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d32cec664457d6e17deecc2f05a9b8fae500e5621473679789e413a453f0032c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3b3d87ea67d6ee52e3775578b7f37d46cca673aae9f412484439d10e9de620"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libssh"
  depends_on "msgpack"

  uses_from_macos "ncurses"

  def install
    system "sh", "autogen.sh"

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--sysconfdir=#{etc}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"tmate", "-V"
  end
end
