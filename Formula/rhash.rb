class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.4.2/rhash-1.4.2-src.tar.gz"
  sha256 "600d00f5f91ef04194d50903d3c79412099328c42f28ff43a0bdb777b00bec62"
  license "0BSD"
  head "https://github.com/rhash/RHash.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "bbb6daa30cf117cee6ac1a4daf39a1e2e67e8449885effa6c146950f84edf515"
    sha256 arm64_big_sur:  "18ec6f8f8b34ed448b3f1f8fd833dbb77fd5aceac7f54548734921b6ea0bf6dc"
    sha256 monterey:       "b47e718dda9f250080b275950bdb77e6594e541743af5cf5377cf96e5f452516"
    sha256 big_sur:        "e0325aa039f0feac8cac2ad248d779b2c9d1252f42a53a277a8eba829e7a4896"
    sha256 catalina:       "f2cc20409751b415bc077ddd017620e96f6be9e79f71266bf5f1d2c55a4f6c16"
    sha256 mojave:         "715b183831b9c80eaf69153d144e38cd908bd05a0a37ced6bd6e2f25ac45b8ef"
    sha256 x86_64_linux:   "9e3e320d2103007aa387d1710d4db67d7399b3341aa02770dc6d9b2c7dff9805"
  end

  # configure: fix clang detection on macOS
  # Patch accepted and merged upstream, remove on next release
  patch do
    url "https://github.com/rhash/RHash/commit/4dc506066cf1727b021e6352535a8bb315c3f8dc.patch?full_index=1"
    sha256 "3fbfe4603d2ec5228fd198fc87ff3ee281e1f68d252c1afceaa15cba76e9b6b4"
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
