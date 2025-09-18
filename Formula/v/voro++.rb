class Voroxx < Formula
  desc "3D Voronoi cell software library"
  homepage "https://math.lbl.gov/voro++"
  url "https://math.lbl.gov/voro++/download/dir/voro++-0.4.6.tar.gz"
  sha256 "ef7970071ee2ce3800daa8723649ca069dc4c71cc25f0f7d22552387f3ea437e"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url "https://math.lbl.gov/voro++/download/"
    regex(/href=.*?voro\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e92608286d7f5525760a291095fffa5174353cd4360288b3b370734e266e332a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c76ccd2f7c88492a312735928f7b629188da9bac80b579effbf140eaff73cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e400aeb0f042dc4b3bfb00bf1a165ce714dd25bbfe8535457bfbec22f9c838c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d9115a80aa1515ed06f302a722c50a2f2a986c348ebc4934b45368c4ab4afde"
    sha256 cellar: :any_skip_relocation, sonoma:        "e585c0c80a4987580d186106c18bc7885d7b2556b8e3483642fbf588ace5bf3b"
    sha256 cellar: :any_skip_relocation, ventura:       "ae3b15478092b468424cd6958a85abe801ad22442fdb97fd21684c033aaae799"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8679748ddd61c78e57c10ef4c8855d933287303f931b595abe67c6339e44bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b8a79d25b9feaedc06ed05f9affbe8e78443e20344b561b85daec8cbed9a089"
  end

  def install
    inreplace "config.mk", "CFLAGS=", "CFLAGS=-fPIC " if OS.linux?
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install("examples")
    mv prefix/"man", share/"man"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "voro++.hh"
      double rnd() { return double(rand())/RAND_MAX; }
      int main() {
        voro::container con(0, 1, 0, 1, 0, 1, 6, 6, 6, false, false, false, 8);
        for (int i = 0; i < 20; i++) con.put(i, rnd(), rnd(), rnd());
        if (fabs(con.sum_cell_volumes() - 1) > 1.e-8) abort();
        con.draw_cells_gnuplot("test.gnu");
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}/voro++", "-L#{lib}",
                    "-lvoro++"
    system "./a.out"
    assert_path_exists testpath/"test.gnu"
  end
end
