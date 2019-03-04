class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.8/rhash-1.3.8-src.tar.gz"
  sha256 "be536a56acfefc87dbc8b1db30fc639020e41edf05518185ea98630e3df7c04c"
  head "https://github.com/rhash/RHash.git"

  bottle do
    cellar :any
    sha256 "9f6df5cd4fee135caa1613628ce968427060b9dfb172bba44addce925e2cb708" => :mojave
    sha256 "8223b53ffd021ed95585eec80952660ca6cf6c900b662cb6a48a592fa10809f4" => :high_sierra
    sha256 "cea83b4b066e02ca0b4e3f2a0d9e77e8ba503e9388a3a9675bf2146dd5142413" => :sierra
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
