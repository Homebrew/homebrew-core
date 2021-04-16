class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.2.0.tar.gz"
  sha256 "1ba06f16d14dfce38c3f8e687936b39400da4ca9e7bfb521169871302dd3baae"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git"

  bottle do
    sha256 arm64_big_sur: "df9a9c4dfecbbcb2ad9148baae13f18f454e2b1bab31f0990864b7c87c490080"
    sha256 big_sur:       "bafe329e19f419f23e0b5eb9da2b1aea609f8f288c9e9f5c6470781176aca0a4"
    sha256 catalina:      "a78871f5bfa3ba4c2cffb7cb10f8dfd37046ead21333c265235b821688586731"
    sha256 mojave:        "05c40bc3a243caf720945ab2dcd1c5de49605502d57572415667f5941078e59d"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
