class Voroxx < Formula
  desc "3D Voronoi cell software library"
  homepage "http://math.lbl.gov/voro++"
  url "http://math.lbl.gov/voro++/download/dir/voro++-0.4.6.tar.gz"
  sha256 "ef7970071ee2ce3800daa8723649ca069dc4c71cc25f0f7d22552387f3ea437e"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "http://math.lbl.gov/voro++/download/"
    regex(/href=.*?voro\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "234c18e07a682ad148639ee65409b11eeda9582c05dfec5fb10e5cae5419b0ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2c8a6acd7f49f29bbb103253151e24179f810536915a36d814217aeff389bd6"
    sha256 cellar: :any_skip_relocation, monterey:       "0940eb9d7bdee0b88acbb590358b79a5c359c1dd47477c38f0c07c7a93c472eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a92c62db56b3816239293a8953f59141cba060a7c3c271cc0bb836caf4948f3d"
    sha256 cellar: :any_skip_relocation, catalina:       "cc5c247b85e45611cbf88a99812864f07315e0dcd571a2dd152c28e435145b3c"
    sha256 cellar: :any_skip_relocation, mojave:         "0dc3186cec2a52edb6ed5d66accaedcae74d9183d8da7d255cd2b9247a605b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a373223553c3061ace9033b0b0bb8c4d6e2a28325dfc6630ff9a792e71064a50"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install("examples")
    mv prefix/"man", share/"man"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "voro++.hh"
      double rnd() { return double(rand())/RAND_MAX; }
      int main() {
        voro::container con(0, 1, 0, 1, 0, 1, 6, 6, 6, false, false, false, 8);
        for (int i = 0; i < 20; i++) con.put(i, rnd(), rnd(), rnd());
        if (fabs(con.sum_cell_volumes() - 1) > 1.e-8) abort();
        con.draw_cells_gnuplot("test.gnu");
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/voro++", "-L#{lib}",
                    "-lvoro++"
    system "./a.out"
    assert_predicate testpath/"test.gnu", :exist?
  end
end
