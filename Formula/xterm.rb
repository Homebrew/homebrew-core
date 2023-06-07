class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-382.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_382.orig.tar.gz"
  sha256 "0cd0bcf3d0aa746a840ea3f1366ea29a74263694d535b5c777f27eb65d7fceed"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9ad8dbe624d7a5c268e15b3495756c94dfb199630c03b3151f6daab58b64ee29"
    sha256 arm64_monterey: "b562a82571840afdc2b6d48d9dbb42712a029de65db21ffc90736f2a65d15a5f"
    sha256 arm64_big_sur:  "096177158c561c636f372f1f6a4baf52cf72649b011043a8f4aa504e7f3259d6"
    sha256 ventura:        "7469c05bf64dc226b9ac7667e092e6b844266b11b3d04a631b12c77087a075e2"
    sha256 monterey:       "b0f37785fc8956f2b9ff6d654ccab364466726849844723f3b99fab0c9c128c5"
    sha256 big_sur:        "cc5750dfaeb2c659538a7f74185310566b8e8d477c51a2c55731a9561a077436"
    sha256 x86_64_linux:   "e52fb3791a42da6f8dcc8e4ed54712ddbbdd502d0cd46e2f9c0dca6e488e2f64"
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_predicate bin/exe, :exist?
      assert_predicate bin/exe, :executable?
    end
  end
end
