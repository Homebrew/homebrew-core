class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.4.3/rhash-1.4.3-src.tar.gz"
  sha256 "1e40fa66966306920f043866cbe8612f4b939b033ba5e2708c3f41be257c8a3e"
  license "0BSD"
  head "https://github.com/rhash/RHash.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "01206ba666f824f28fc1e840f4950dfbbf23be9ac7be2af7273d12f0963ce49c"
    sha256 arm64_monterey: "83aa0e800d6dfefc04839c348c9464b6dd851377f5c9fa74ab90b5679d5ef58a"
    sha256 arm64_big_sur:  "6a20e957a3677d2cbbea2aa6cb29e35aaadf8f64a304a6bfb8d60ae1e2385aa6"
    sha256 ventura:        "3ad6005a38817336f0d59ff812733ec6f71df856d938db3d6cf9f6d8a5d69146"
    sha256 monterey:       "c6004d38e08b84b53423a0ab0a5e4f258eb92f2cb88b8ecd86e2294f0a831182"
    sha256 big_sur:        "16a9e4c548402e9e8c9568d4529b392859eb120284c2bc731f4feb5083dcd8a8"
    sha256 catalina:       "d51a6837ae68a15319fca27e654f39262d62325bd1be7d30d0ecf97d187bb0d0"
    sha256 x86_64_linux:   "d41278cf9e9eebc864013ceaddd4188882a8a91a6458e71155d3089a555ec1c6"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-gettext"
    system "make"
    system "make", "install"
    lib.install "librhash/#{shared_library("librhash")}"
    system "make", "-C", "librhash", "install-lib-headers"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end
