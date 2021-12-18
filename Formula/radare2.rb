class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.5.4.tar.gz"
  sha256 "1a47d5306200971b42acaf24ecc2dd4b99270b459f49871895267a4be41d9be0"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "3307607ab4338b71f3d645603e2543863428438d50fa004a40f88324a39949f8"
    sha256 arm64_big_sur:  "f3a4b73f56eadb264e37480bf8801739baebffc18251881fcee2020a08a93c37"
    sha256 monterey:       "b01a7b16f077570ef01bab78d5bdc145b32aba63d1562bc03372108ef2fc3e76"
    sha256 big_sur:        "76de4ebf8b22dda6cd51705dd310bb6247ca0d8f004e94b9a0c0a2ee5cdf5e32"
    sha256 catalina:       "be085c2b01cc2db625be44788a0157f3e0ce8e6616110b2b2e19e253662ea2b8"
    sha256 x86_64_linux:   "1ed1edbbcb7d8360a6876c649893ed96a932c458da067e61f36fb59117fc09e6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
