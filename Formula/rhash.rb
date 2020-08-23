class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.4.0/rhash-1.4.0-src.tar.gz"
  sha256 "2ea39540f5c580da0e655f7b483c19e0d31506aed4202d88e8459fa7aeeb8861"
  license "0BSD"
  head "https://github.com/rhash/RHash.git"

  bottle do
    sha256 "3fc816254535e1ecf091161b96447efedf2748cdf25a38449f6de70ef652165d" => :catalina
    sha256 "89ae46bbd559e15e9aacb9010e4f4cff6ab402e8bd9eb301f8cf7aa745dbdde3" => :mojave
    sha256 "998d4c8b2195944bc979c11fcd7aff29997994c8457d29343524edea15de74eb" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    lib.install "librhash/librhash.dylib"
    system "make", "-C", "librhash", "install-lib-headers"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end
