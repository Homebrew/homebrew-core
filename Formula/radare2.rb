class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.7.8.tar.gz"
  sha256 "084f262873f7ebbb54cfe01ebf14b43136e5a7442df8ecf01b37e7060a49b432"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "85dc0c6b254ec9509eca8ed2c34390fd58c0097e17a7de62f16bfb8adeb05b61"
    sha256 arm64_monterey: "9e743e19518f6f07260fb5b5ff04c5119a360850ff15470fd7a9c57703ddca65"
    sha256 arm64_big_sur:  "8f0f33c08b5be8cce5c33d648e373f6958204953bf4cee4f8e93efaff69060ba"
    sha256 ventura:        "98839d9154448bc80c413e3a323f5f75aff5d3c09386fbd950f01274c78c6561"
    sha256 monterey:       "5ae70eb8fe91d34dfc177e8b108b303e63065da0c0dd066fe43efacfa8cb43a5"
    sha256 big_sur:        "27ed49411e0669efa6e9d3259e53f7c08a3d115d0cf7072f38c7fafb2d29f7c1"
    sha256 catalina:       "1b054434da7f68b877635200a2ae0b2ab0c48516b88113e9e9f3f88e3c48d3c3"
    sha256 x86_64_linux:   "b9d796900d6626fc3a004c5470ce9210e4185d8ebee99b715e95ba59863f3140"
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
