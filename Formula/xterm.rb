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
    sha256 arm64_ventura:  "0e7826a1d4e31d29a4cf8c2fad253c24933507a876824af7a5d01a071b68d823"
    sha256 arm64_monterey: "bd3cbc6a31c95fc15562a6da7533b4a045d6f7a83428c06004d8494a0680ebad"
    sha256 arm64_big_sur:  "2eec52a969c954b15bfeeeaafd1bbd2fecfaab152f5835ec2ce386fd7f6c0030"
    sha256 ventura:        "fde2c3e73ef5255eaa0c9ea7b0f52b78ba31bf9712e7b0dd5ba9f8cbc6d78fcd"
    sha256 monterey:       "25980a4da2592e6b22280e0260fb33322a095b3e144d2c771d3484a643b35909"
    sha256 big_sur:        "5ffa040624f8694d77d2b90ee44e292bb9f28b3f965ef216b7d3eae4214888f9"
    sha256 x86_64_linux:   "5455a225231ee544afb391511d1e4c853122b4ebd1e7384a7d2095d8cfd01276"
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
