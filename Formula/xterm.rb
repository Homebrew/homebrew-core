class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-365.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_365.orig.tar.gz"
  sha256 "d627d2b005803b4ebcdf04f2d89e3e1d2878235d2ecdfa73d904bb1772a74f90"
  license :cannot_represent

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "041ea0a035b63c3ff2d07ea5fb48f433ad5e217313043aac9e7382b9b6a84000"
    sha256 big_sur:       "88dd9c054cc9987d5d8f1117af8e1be5a38823a3cbb500f0fbba600ceea18ebe"
    sha256 catalina:      "68c40fc4958dea9eab534a07cc7cba9f92f39212f9a2dc698d8913a0f8329e14"
    sha256 mojave:        "adf66a50385caabbe943c4316f20ba874eff91af8d4816d5068e7617e97ed307"
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
