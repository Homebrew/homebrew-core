class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-402.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_402.orig.tar.gz"
  sha256 "5260c5793cd564c69e53ef6f528c00af066ae67b42d02137fb7ef8fafe70bb7a"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e8261de5224e0131d36bfaca99b113e602086812fbf7294e1adac180c497bb22"
    sha256 arm64_sequoia: "3566eeb824d0856b03504d74c25199a7020bcc36243d95de33a2fcf3ef8faca0"
    sha256 arm64_sonoma:  "031248fb11d3a8e39364ab93b9a0b590fb5679d0ad0bd4de56612ee174281a9a"
    sha256 arm64_ventura: "873d6fcab219ac431abff903a2f4926329f4c0912e40d9b760dded1d0171786d"
    sha256 sonoma:        "ae7655aead6698731e283b6268deb916847cd0e61e02004db89b910acea51019"
    sha256 ventura:       "b7e6053067f2370668eca621c5885a528b8921f8aa673dba32e1f29a42dee5bf"
    sha256 arm64_linux:   "404630857d75fcb51a1f632273268961727c14244c0b5c62d64665b9fd85bcc2"
    sha256 x86_64_linux:  "be5c7ac6ba9b6d2141216f7ddf17d1ce8302be233eb8d50852569e420ddeaba1"
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
