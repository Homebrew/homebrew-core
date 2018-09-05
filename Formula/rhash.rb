class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.6/rhash-1.3.6-src.tar.gz"
  sha256 "964df972b60569b5cb35ec989ced195ab8ea514fc46a74eab98e86569ffbcf92"
  revision 1
  head "https://github.com/rhash/RHash.git"

  bottle do
    cellar :any
    sha256 "86e6f52d5fa950c37dde8e013bd4db53eced7cd131c8049a808e173af3e1f357" => :mojave
    sha256 "6a21dd55fb1b4db6566edbadb12b7d3cb72e3be1bfdf549e926d02d9dfef502a" => :high_sierra
    sha256 "3025df8e67a5eaf485b38ffa48b26c91c53b56ecec4e66ae9b72fddaaa277d83" => :sierra
    sha256 "1fd156f264a72fee9a6d17361db1c30513d09e90f4db04ab8c3d65d051f8d447" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    lib.install "librhash/librhash.dylib"
    system "make", "-C", "librhash", "install-headers"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end
