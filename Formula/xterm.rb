class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-361.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_361.orig.tar.gz"
  sha256 "85610f20d5e47205cc1b6876f7a4da28d6ae051bd8eac0b932e92c37a73a623f"
  license :cannot_represent

  bottle do
    sha256 "88e30a37f2bab99f4de4dc13a09714cd267fde631015260e07736315a769d21a" => :catalina
    sha256 "21a7daa15dabd4b41968010342bbc2ea4a4e97075e42c7a51fe582c2d4331480" => :mojave
    sha256 "7991cdc6a1bca3713f71b76d1751aade257f50f4ca6274adc5126e36d8dc2978" => :high_sierra
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
