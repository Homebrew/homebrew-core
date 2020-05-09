class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.6.2.tar.xz"
  sha256 "519ca0de92c1c5dbb76494176c7e567ce4cc8f64a2ecd27b2fae32ce156421fc"
  revision 1
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git"

  bottle do
    sha256 "d2ef22c9e1333a70053230705caff9baf80075c4039a485e3a778abc0ca3b415" => :catalina
    sha256 "cbd74528c1f37f44079f866fa8da5e6571929e35afd4102244cbfa103e5f2950" => :mojave
    sha256 "c81ad2c94b22452119bcf5c6347ef6426ee245afbd750bf0c0f6c35f3c8c6b75" => :high_sierra
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
