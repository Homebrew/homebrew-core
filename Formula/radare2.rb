class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.1.0.tar.gz"
  sha256 "f9d9edf885bd1c08d43828658be0f0766c84f9a6c3a1be789885100b533128b2"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git"

  bottle do
    sha256 arm64_big_sur: "6d954d5a1f87949697e9afa0b3e80e6b083a72aca6ceadbaf368c650fd57d904"
    sha256 big_sur:       "b108662d38c8aa3dc5b602d2d98a80b38d3284782ea32e91cb0a90ffde3d0202"
    sha256 catalina:      "5403c90a83491131fa0ebd1e94d4c5a0df519430adafe71cd947974160938fb1"
    sha256 mojave:        "08b9e05471782b8f721b13c7b725a048a374a33511d3c94457cdf06a6f200657"
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
