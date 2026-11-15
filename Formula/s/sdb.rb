class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.6.2.tar.gz"
  sha256 "ca634db0bc0f85f1e65b05c576b791905422426df0f0a6d99cd4d0e1a40b1e8a"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e277f7ecb1a1608024872e64e3351ab88e6487cff28741d9dd86b239d0977158"
    sha256 cellar: :any, arm64_tahoe:       "aa39a46946575bba03d6ebb8b5b739fedeb3d1e1985d290919cbfece8883e023"
    sha256 cellar: :any, arm64_sequoia:     "ea585f1d772a1c0dc1947d07c0821dcc42d76dea2bfa53d488c6cf76c8f5201a"
    sha256 cellar: :any, arm64_linux:       "f74249699807cb5901cdffa067b4f8ccac3c784bf15bc725718e323c86d60c08"
    sha256 cellar: :any, x86_64_linux:      "dc7c200fc2b7f969ee41c64badcfc86a0479069ebfb51b42d125d7d265e28501"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"

  conflicts_with "snobol4", because: "both install `sdb` binaries"

  deny_network_access!

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
