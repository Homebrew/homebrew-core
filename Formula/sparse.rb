class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.6.1.tar.xz"
  sha256 "fdb05c84c8a62833b0920a0f855708b3843cb00df64d1582cba1c1da7df65b61"
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "953c7855881f3b03d723b41eb8ca723f633767b1ed09c1ef19f7bb9f9c530c35" => :catalina
    sha256 "a7bb9bba1767d4df2a5c07911fbe5a52e63a89ee61f59ac38b7abdf18f915050" => :mojave
    sha256 "a2e1769a7a40c5ed66ee727a6b07d7227a7cf5f8bfe1f0acf7af1b4549841ef5" => :high_sierra
    sha256 "e2e13c56e25ecd0f95558263931d2f4b31b533126e289b95e8ef8f5db4fa1e22" => :sierra
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
