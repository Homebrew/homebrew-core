class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.5/rhash-1.3.5-src.tar.gz"
  sha256 "98e0688acae29e68c298ffbcdbb0f838864105f9b2bd8857980664435b1f1f2e"
  head "https://github.com/rhash/RHash.git"

  bottle do
    cellar :any
    sha256 "24d81bee8d36e3be65981ac8ffbee6bbd0f08225d61890c2bf288dd73fa8e341" => :sierra
    sha256 "2b0a7894d2fb528879129c659a5bb50fe6c26d9c6b67ffc19d1f7462d54cf310" => :el_capitan
    sha256 "55f45a776a493178a094e3bf3d612b5720fffc33d14446ba2aac06b5be7e8358" => :yosemite
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
