class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-379.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_379.orig.tar.gz"
  sha256 "a7ddf274ee84b97fb1283675009d53ca2d02a0ffd5ce5a5118dafc3623ebb310"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "34c8c4422635d55289d117ced43e6fdf88f6ff485331f580d2700a710e5f1869"
    sha256 arm64_monterey: "7bc7f8c3b8b6afca991c153d274fb7adfe286ae8948118a3774ecb9782cbc6ca"
    sha256 arm64_big_sur:  "39ca9f3e5e97570339e83ead95b2a64e060e6eb33e857c75394573dfdbc5c6c7"
    sha256 ventura:        "29288a517ffec0ff1a0d4939ccb0294603e8cabc0cb0f4c2aae1fbc6fc4f45bb"
    sha256 monterey:       "121dc96617a3281bb299e5a6db57bccb54cc7db839fd9da0bfad2c5dab5b93c8"
    sha256 big_sur:        "8527b1baf75d4abf42635a5361ea0704888c7360e1a6f2aa76e84aa82013c1d8"
    sha256 x86_64_linux:   "362ebd15081ad6c51aa8118b02ce8087923ca4dd152adcba86e0d7f11c6bc994"
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
