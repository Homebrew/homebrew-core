class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.9/rhash-1.3.9-src.tar.gz"
  sha256 "42b1006f998adb189b1f316bf1a60e3171da047a85c4aaded2d0d26c1476c9f6"
  head "https://github.com/rhash/RHash.git"

  bottle do
    sha256 "fc4f0d1311c5481c4b53bd1a05644531a986eb501aa1e853131125573cbd0d6a" => :catalina
    sha256 "cb70f24905e35fca8812456e91f34d24aa71c54f05bb72c04c4b94610564ab37" => :mojave
    sha256 "557acccf2751cbfdd83e6e8e2ec2c6cf5f87a90f0c7a0be9b3d99de0d2f0f6b6" => :high_sierra
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
