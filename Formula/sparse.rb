class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.6.2.tar.xz"
  sha256 "519ca0de92c1c5dbb76494176c7e567ce4cc8f64a2ecd27b2fae32ce156421fc"
  revision 1
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git"

  bottle do
    sha256 "7b68cfced4d0ab9aa951900794eae5610ff9f6641b57a3fc6cd8a6d61b69f3f7" => :catalina
    sha256 "6f9eb074c79700342aa36a6359079e8d853e5a6b9d6203459b62118b747e1210" => :mojave
    sha256 "b74ccd0fe82e07b7d0552954634e1e7a8395ceaae09b8405d8460ce3b828e75d" => :high_sierra
  end

  depends_on "gcc" if DevelopmentTools.clang_build_version < 1100

  # error: use of unknown builtin '__builtin_clrsb'
  fails_with :clang if DevelopmentTools.clang_build_version < 1100

  def install
    # BSD "install" does not understand the GNU -D flag.
    # Create the parent directories ourselves.
    inreplace "Makefile", "install -D", "install"
    bin.mkpath
    man1.mkpath

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.C").write("int main(int a) {return a;}\n")
    system "#{bin}/sparse", testpath/"test.C"
  end
end
