class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.6/rhash-1.3.6-src.tar.gz"
  sha256 "964df972b60569b5cb35ec989ced195ab8ea514fc46a74eab98e86569ffbcf92"
  head "https://github.com/rhash/RHash.git"

  bottle do
    cellar :any
    sha256 "0bfc615395a70e344e017fa959beceab3d62cb4c0d9e246cc06f4ab3898316cf" => :high_sierra
    sha256 "efd10fb4561d830874752f1a9f222a344d1414be188d0e82637ea68367ce5d1d" => :sierra
    sha256 "167a673f23b223c56f520425091272c8f15715b052de4df878124fc8dad34a8b" => :el_capitan
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
