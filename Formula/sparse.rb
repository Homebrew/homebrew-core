class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.5.2.tar.xz"
  sha256 "4632b7b74af72214247f982f976ba44206933bab3a2717e09df166fb5b8abe7a"
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db6647114d923224cd794d8ae64955d30ea87a7f1bfd938f4742dffb6594fec3" => :mojave
    sha256 "e1f7b2d8585f7c30f1c3c342d034768e14fac1b6043d5d7ba41a7b12d75c3efa" => :high_sierra
    sha256 "af4f28e9df8833877fc218dee27092218b57de0414706a64a6fc44946e7de692" => :sierra
    sha256 "e393e5c09338e5db469150cd90d7d24f67840be81e36a09ac430f4ffe0254df0" => :el_capitan
  end

  def install
    inreplace "Makefile", /PREFIX=\$\(HOME\)/, "PREFIX=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.C").write("int main(int a) {return a;}\n")
    system "#{bin}/sparse", testpath/"test.C"
  end
end
