class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-389.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_389.orig.tar.gz"
  sha256 "1cd5763d94d9370fed10d804e831a089b2ace0e7a74b6f56ef5a16a766bde7be"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5f47a1b78e48f2c87dce1063274694bc3546119b89f27d04d56abf8406c76528"
    sha256 arm64_ventura:  "a454c6513e8cca923ed83273f69edc17b127866665366988b2a248393f05379c"
    sha256 arm64_monterey: "0b49bb8125e9f72affdfe903d0702f1d16c218132b63e3e9eb52eeda23ae5e2d"
    sha256 sonoma:         "e3930c06a50d451595fc935049f5c7814081acd45316295eff22924ade3cacf2"
    sha256 ventura:        "ce1c9efe499057a8d57a02dfc42c5c384ae8e96370deac3dbabc2146ece7c5dc"
    sha256 monterey:       "12c783f550a6f4a026fe9f66a05603b0092ffb6bd6f6091701903c714aa3a29d"
    sha256 x86_64_linux:   "704606246e2f0c2cca5d01a6a29c8979ea7e99dba47cea8b93fddaead30da232"
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
