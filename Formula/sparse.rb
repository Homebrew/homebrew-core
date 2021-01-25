class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.6.3.tar.xz"
  sha256 "d4f6dbad8409e8e20a19f164b2c16f1edf76438ff77cf291935fde081b61a899"
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git"

  bottle do
    sha256 "da170eea78ffe877b82b853f04ed4bd7487029c288c482f13cf798b70a1560c0" => :big_sur
    sha256 "7ba6578a0d29486b5839541706bcf448dd2babb0a1132c2956e2ce92ba3f0657" => :arm64_big_sur
    sha256 "1fb15ba5444a7c67d9f45215fc02e948583c28d8078546b3e0f766df50a1a859" => :catalina
    sha256 "ac0ade8d4c0f98cadcca728fdd3c0694e3d3a4432c57edf0725542a91d750128" => :mojave
    sha256 "7dcabb27270d98a6ad13d6b2c6b8c1bf3f0a9fa001a9737db841f1cd604dbeec" => :high_sierra
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
