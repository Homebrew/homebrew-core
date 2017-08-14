class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.5/rhash-1.3.5-src.tar.gz"
  sha256 "98e0688acae29e68c298ffbcdbb0f838864105f9b2bd8857980664435b1f1f2e"
  head "https://github.com/rhash/RHash.git"

  bottle do
    cellar :any
    sha256 "e86d5f2ffe1c5f7192264fc308f14b417ff1f09793adb0e9365e8a00c4f1520a" => :sierra
    sha256 "10643c17507d1dcb081d4287d49a6291bcdaec5ba633285f0e54e121c217d83f" => :el_capitan
    sha256 "01e895a04facb08fe288db3bfcb9968d4c0b19db4964329eeb2b02d5ca08cdf7" => :yosemite
  end

  def install
    system "make", "install-lib-static", "install", "PREFIX=",
           "DESTDIR=#{prefix}", "CC=#{ENV.cc}"
    system "make", "-C", "librhash", "dylib"
    lib.install Dir["librhash/*.dylib"]
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end
