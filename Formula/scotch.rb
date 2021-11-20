class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v6.1.2/scotch-v6.1.2.tar.bz2"
  sha256 "6e820a64cc2105749e3d1dfbfc9aed33597a85927b6f56d073a6ef602724ea2d"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2a88eca7948940c07bc2263143b35be2d0a6d4f66bf3f4bff93ead83a653921"
    sha256 cellar: :any_skip_relocation, monterey:      "63ef5a05bb51ff7adaafb4633d09ac262c113341d4b8607460e30521de81d0ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "54e1182e94e87f15ba4671dd4611efd9aaf6dfa4c480fc304f40633032a70a19"
    sha256 cellar: :any_skip_relocation, catalina:      "47642fe1c6bfc3da89aa509ac9220d9e27071e30327fb6c607e6473d4cc4d7d4"
    sha256 cellar: :any_skip_relocation, mojave:        "ec79906f2bc0c47ac0989a7d4dcc6a3a7a49021e8a330b1f04a973ed09d01b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f93fe6e8bcdb31271f7d082915061d6fa2b9e415611a6f52929dbb45a48dd847"
  end

  depends_on "open-mpi"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
    cd "src" do
      (buildpath/"src").install_symlink "Make.inc/Makefile.inc.i686_mac_darwin10" => "Makefile.inc"
      inreplace "Makefile.inc" do |s|
        s.change_make_var! "CCS", ENV.cc
        s.change_make_var! "CCP", "mpicc"
        s.change_make_var! "CCD", "mpicc"
      end

      system "make", "scotch", "ptscotch"
      system "make", "prefix=#{prefix}", "install"

      pkgshare.install "check/test_strat_seq.c"
      pkgshare.install "check/test_strat_par.c"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <scotch.h>
      int main(void) {
        int major, minor, patch;
        SCOTCH_version(&major, &minor, &patch);
        printf("%d.%d.%d", major, minor, patch);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lscotch"
    assert_match version.to_s, shell_output("./a.out")

    system ENV.cc, pkgshare/"test_strat_seq.c", "-o", "test_strat_seq",
           "-I#{include}", "-L#{lib}", "-lscotch", "-lscotcherr", "-lm", "-pthread"
    assert_match "Sequential mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_seq")

    system "mpicc", pkgshare/"test_strat_par.c", "-o", "test_strat_par",
           "-I#{include}", "-L#{lib}", "-lptscotch", "-lscotch", "-lptscotcherr", "-lm", "-pthread"
    assert_match "Parallel mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_par")
  end
end
