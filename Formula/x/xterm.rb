class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-392.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_392.orig.tar.gz"
  sha256 "4d57372ef08eafa9fb7682db8d07be0fe0513e58e8478c2ec8e9b62486e7fe5e"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f72fdefd236742f3c35aa26d4159435889d55a5fa5e4b37c5fd5437dfae9eaf3"
    sha256 arm64_ventura:  "44f67de2a4069224cfc05e8ed81d9a95f20423454d3f41c52d493c35dda62a93"
    sha256 arm64_monterey: "b7e42e62dfbdba37c1dd3a1830af2e56b1a6320c6498e4456fc355caf5531fe9"
    sha256 sonoma:         "f3138e8b7063ec5e0f1e9df943dd8b307198cd8dea9f740411ce115258b97727"
    sha256 ventura:        "0cda073915cefb86c052559c66da4c8adbc39ee8d1f5b3fd16cec963b9961c54"
    sha256 monterey:       "bf87dab4e9964fb58e4530c79c8b959f06f4f911e6206dc79d373ce84232678e"
    sha256 x86_64_linux:   "47d4862a0d48ceeacfa82cc6bdd58eebc6c95729a70960f3b4c0e96e52fb6132"
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
      assert_predicate bin/exe, :exist?
      assert_predicate bin/exe, :executable?
    end
  end
end
