class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.6.8.tar.gz"
  sha256 "320d4f4733402cbc38303c7d37db04716e4376138da44d3664bb73adbdd77e0c"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "6de434a4016694c0c4292f684553d08d2173239ab15f51d0bf1d8482e9aa5c63"
    sha256 arm64_big_sur:  "0dbb9d38ada13576c6e81e72b3cf9fad922f9b33ff336bf2bfa22aedb951e470"
    sha256 monterey:       "0320200985ae6f04ae74770f5bccf0c23ed251c296f631e602f762a302119cbc"
    sha256 big_sur:        "00697d97d579b5f1534d7b2a3e6f945ba575003ae1563685022719f6cef3f567"
    sha256 catalina:       "b96bdbd9fa36aa08fd021ff41881aabcff6926a9ef7a235ff3d9b5b32c8bb29d"
    sha256 x86_64_linux:   "a957fc0d36efe629e2f38f7f631d71f20774019748f9cee43d3a5b79d6285cd5"
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
