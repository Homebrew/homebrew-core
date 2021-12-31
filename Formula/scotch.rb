class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v6.1.3/scotch-v6.1.3.tar.bz2"
  sha256 "754ad046220939b5dfef625b7d8d898cb82874572846c228c54787aa8f4baf89"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bfbee38afc6f86d5d5d11c73c9f7d05dc39f05665d3168e82c818e9cefebc161"
    sha256 cellar: :any,                 arm64_big_sur:  "0fbfab5ce2b53368bbe985e8fa52a8795038ceee9aaad672cdd89b1e37a6942f"
    sha256 cellar: :any,                 monterey:       "4c6bd2a2e725b654d043b763db65ee9341a9a5e0778a21f377a6c6948b507fa5"
    sha256 cellar: :any,                 big_sur:        "ac8eb11522681a950b2461bbb09c2c4698d9a05c9026e694c1bab11663adddcd"
    sha256 cellar: :any,                 catalina:       "ba2dce5a5e568d50fe9165b96be0f5c41e9db2e5249cb0a2b48f1603be9c2598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b24a501bf3166e4eab44a91fb9c450e4d102209c723aa31fc3804fa8f759b90"
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
