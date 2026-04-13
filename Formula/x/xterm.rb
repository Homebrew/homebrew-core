class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-408.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_408.orig.tar.gz"
  sha256 "27dc9e770885f98fbd0b5b40bcda959dc11ec9ba21f0a33b12aafffcc7f9b813"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d498784ff783c88b31d46ada0971b8802e32a948bb1746eecdcaef678d9f8d62"
    sha256 arm64_sequoia: "7163bb626d68b2f2618ea787608f371a9dfe315b5ed96acda32dacd92acf9f42"
    sha256 arm64_sonoma:  "ef376bf5592c0cee6fabcc796160dcfc05ef66fd2bdbe4aa92c19a3804f4a88a"
    sha256 sonoma:        "9ff3b90a063a5b8d6eda42e9b9dbc412fa66cb4553ab964f6e582d201f26a9ef"
    sha256 arm64_linux:   "8cb878fe863f4c6c2bd14a2961c0e70b131bc13de15dfc2b4f94cd04ad6348cf"
    sha256 x86_64_linux:  "28431a3ec71c505d6c53a0c958e580306aecab2abfd2e72df149e1ee173e3d87"
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
