class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-404.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_404.orig.tar.gz"
  sha256 "63332f921c227ba59e589fa07dfdad1599c10ac859ea26c72ac1dd4a41b565a4"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f25948fe147b7cce574b4077fdca1ff5726208d1dfc451f22e8b75a3cc006697"
    sha256 arm64_sequoia: "04e7983ed65bb02a13f4108dff47b51d1670f368a145953d3cc9d05df109a475"
    sha256 arm64_sonoma:  "9a7d99ac23b25ac6312679c368d0fa7556d2699ed710a1adb12b4fcaaa97429c"
    sha256 sonoma:        "949b1063c251fd3163a3d56bb52f04e616678a1e7be3b9d48b70f8216379495e"
    sha256 arm64_linux:   "3e8f6ef498a38d5e3292efdff9b7f5c8757c80b231d6761b045a4053ff4417cf"
    sha256 x86_64_linux:  "c73ce34894665b770029c534f7256962d1f78f082547410fb04de0de9ce57782"
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
