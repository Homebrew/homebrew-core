class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-409.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_409.orig.tar.gz"
  sha256 "349dc755c49299ca4b8e3a90f7201dff41877a1e6ac16129e439d76493246c40"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "bda9163d68ba640926f12d13170799f6433d3b09107e3262c46c34464e1b6fa1"
    sha256 arm64_sequoia: "3e2cec49db288139e9dd47ff0e653df7ad2358349c656570142b5053e03b6d8f"
    sha256 arm64_sonoma:  "bfe9dc0b61d2bf27c2087d5f4f183c5444f65d832f2a2d6505e6798a0656bc36"
    sha256 sonoma:        "448fc21617a1badcf23a94f20145feeba4c998ca23a3eb77dcce1d42213de12c"
    sha256 arm64_linux:   "fed515c0df82ecaf9474dcc3abc77ac6e56f8b5f781d0260819c304ea7a8bf47"
    sha256 x86_64_linux:  "5bf97c93d4360943de598aea32e27c278406d8d605e9254c56391ddcf09723a5"
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
