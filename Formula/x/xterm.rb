class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-406.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_406.orig.tar.gz"
  sha256 "066eb2d66430897fe1dadd271554ccdae33d77c512126a758fc4de37b1148799"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "febe264a3f84f698a283fe06451f6aa5851f423b44e0117ed4ae36c52cadf783"
    sha256 arm64_sequoia: "0928f2fef86350a848646a02ad1f0eb407b0a3c8a5c791e9ae5c4d40ff6dfcf4"
    sha256 arm64_sonoma:  "bba1270c756fb3372f837f9765afbd14f72bb248ec78b06efd875d78624de0a6"
    sha256 sonoma:        "3ee7f80ce88a4cab63dd10009911e2cf2aee234d3e2f9344328184f30b0c8d67"
    sha256 arm64_linux:   "e25efccd11367f25e330e4e4bd209bd6c508bacf714b2a8c200f2779834f46a1"
    sha256 x86_64_linux:  "ac01af9a5aa916e65baea9cf66b32be40e00ffe1fd19388a4ba61a6f50bce0e6"
  end

  depends_on "pkgconf" => :build
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

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_path_exists bin/exe
      assert_predicate bin/exe, :executable?
    end
  end
end
