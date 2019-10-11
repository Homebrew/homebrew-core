class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.6.0.tar.xz"
  sha256 "faad3d038e22024280bbd7d6093e9c22dc6333ab7db3638079b93036e43fc277"
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "953c7855881f3b03d723b41eb8ca723f633767b1ed09c1ef19f7bb9f9c530c35" => :catalina
    sha256 "a7bb9bba1767d4df2a5c07911fbe5a52e63a89ee61f59ac38b7abdf18f915050" => :mojave
    sha256 "a2e1769a7a40c5ed66ee727a6b07d7227a7cf5f8bfe1f0acf7af1b4549841ef5" => :high_sierra
    sha256 "e2e13c56e25ecd0f95558263931d2f4b31b533126e289b95e8ef8f5db4fa1e22" => :sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.C").write("int main(int a) {return a;}\n")
    system "#{bin}/sparse", testpath/"test.C"
  end
end
