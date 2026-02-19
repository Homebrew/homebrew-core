class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-407.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_407.orig.tar.gz"
  sha256 "2136eba530068a1b7565abbf17823274f5cefb7fe3618355cbc89dc55c8b7b6a"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "22779daf2a5913a70149800eb1ab29b6a45bfe34cc77694d94885f567f91b060"
    sha256 arm64_sequoia: "4db1cdbb0e0f9501001e41b19c6cb66e0d89b49634763be499353d619c3a536d"
    sha256 arm64_sonoma:  "120c33d6f1a4f0e366bf9c9370fe3920725f33bf33346018b309a6895ff40585"
    sha256 sonoma:        "e85424417569eeb0b0fff5615d04a214cc8f55b2a5e2272c2e1c10dc783ff3f3"
    sha256 arm64_linux:   "fd10db3e7d81b9c3cd8d3a158e3d8907f89d823484a093f2c00b2d34ad13dbe7"
    sha256 x86_64_linux:  "1d38b87e26eaf0a2fe17e2dd7f89df4b2f1d10f2bc872a307aabef06be5ffe15"
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
