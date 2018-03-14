class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.6/rhash-1.3.6-src.tar.gz"
  sha256 "964df972b60569b5cb35ec989ced195ab8ea514fc46a74eab98e86569ffbcf92"
  head "https://github.com/rhash/RHash.git"

  bottle do
    cellar :any
    sha256 "f088eebd9e263f0550a48711ce857a59766cd85414f7902e3a750289c8a0559d" => :high_sierra
    sha256 "e86d5f2ffe1c5f7192264fc308f14b417ff1f09793adb0e9365e8a00c4f1520a" => :sierra
    sha256 "10643c17507d1dcb081d4287d49a6291bcdaec5ba633285f0e54e121c217d83f" => :el_capitan
    sha256 "01e895a04facb08fe288db3bfcb9968d4c0b19db4964329eeb2b02d5ca08cdf7" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    lib.install "librhash/librhash.dylib"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end
