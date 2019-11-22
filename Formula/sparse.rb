class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.6.1.tar.xz"
  sha256 "fdb05c84c8a62833b0920a0f855708b3843cb00df64d1582cba1c1da7df65b61"
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1b3677825bb6ba5e50e6d0da79836fd34d1e1c0249053d11640d88114d3fcbb" => :catalina
    sha256 "a96ecc9bb289caf14f4dcf9dd5a0b1d04e2336d1c1e79eafd8af6cb3f3a9e5dd" => :mojave
    sha256 "ec9b7f151a40b278fe062c354cbbdfb47c5a2420b1cf87a04d5813d0221e47f9" => :high_sierra
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
