class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.3/scotch-v7.0.3.tar.bz2"
  sha256 "ef860d303606d79bd6cb8253d19b204bea0144417638dc905aaa8ad696fbf6b6"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7a10ee9f5de730ce3ef53160311baafbd381a653bdbb62c669f87b54ef60c2ea"
    sha256 cellar: :any,                 arm64_monterey: "f6bb78dbe627af602c76357d7737e318dd60b04e89315ad6d4f2bc0690fd2d99"
    sha256 cellar: :any,                 arm64_big_sur:  "3dd424ff71c5bcb8cf188cec5719db292ee12336c187dfc313f6e0ebc700a63c"
    sha256 cellar: :any,                 ventura:        "1f6d6230995059641860cd3bbeb39f8614d2af3bd14b2f274899c883354464b8"
    sha256 cellar: :any,                 monterey:       "d905aad48d0449754c178434bbab3e04628141a6ee27219dd2e389e45e4944fc"
    sha256 cellar: :any,                 big_sur:        "4ba2ff04f51e8455c33c183209ba2bc5f6c2b2361ad0a0ee4e6cb35952ef016a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dace04b4d66184873d185e0f10d23cce70096580bc670846027a8c11c9f89a14"
  end

  depends_on "bison" => :build
  depends_on "open-mpi"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    makefile_inc_suffix = OS.mac? ? "i686_mac_darwin10" : "x86-64_pc_linux2"
    (buildpath/"src").install_symlink "Make.inc/Makefile.inc.#{makefile_inc_suffix}" => "Makefile.inc"

    cd "src" do
      inreplace_files = ["Makefile.inc"]
      inreplace_files << "Make.inc/Makefile.inc.#{makefile_inc_suffix}.shlib" unless OS.mac?

      inreplace inreplace_files do |s|
        s.change_make_var! "CCS", ENV.cc
        s.change_make_var! "CCP", "mpicc"
        s.change_make_var! "CCD", "mpicc"
      end

      system "make", "libscotch", "libptscotch"
      lib.install buildpath.glob("lib/*.a")
      system "make", "realclean"

      # Build shared libraries. See `Makefile.inc.*.shlib`.
      if OS.mac?
        inreplace "Makefile.inc" do |s|
          s.change_make_var! "LIB", ".dylib"
          s.change_make_var! "AR", ENV.cc
          s.change_make_var! "ARFLAGS", "-shared -Wl,-undefined,dynamic_lookup -o"
          s.change_make_var! "CLIBFLAGS", "-shared -fPIC"
          s.change_make_var! "RANLIB", "true"
        end
      else
        Pathname("Makefile.inc").unlink
        ln_sf "Make.inc/Makefile.inc.#{makefile_inc_suffix}.shlib", "Makefile.inc"
      end

      system "make", "scotch", "ptscotch"
      system "make", "prefix=#{prefix}", "install"

      pkgshare.install "check/test_strat_seq.c"
      pkgshare.install "check/test_strat_par.c"
    end

    # License file has a non-standard filename
    prefix.install buildpath.glob("LICEN[CS]E_*.txt")
    doc.install (buildpath/"doc").children
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
    system ENV.cc, "test.c", "-L#{lib}", "-lscotch", "-lscotcherr",
                             "-pthread", "-L#{Formula["zlib"].opt_lib}", "-lz", "-lm"
    assert_match version.to_s, shell_output("./a.out")

    system ENV.cc, pkgshare/"test_strat_seq.c", "-o", "test_strat_seq",
                   "-I#{include}", "-L#{lib}", "-lscotch", "-lscotcherr", "-lm", "-pthread",
                   "-L#{Formula["zlib"].opt_lib}", "-lz"
    assert_match "Sequential mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_seq")

    system "mpicc", pkgshare/"test_strat_par.c", "-o", "test_strat_par",
                    "-I#{include}", "-L#{lib}", "-lptscotch", "-lscotch", "-lptscotcherr", "-lm", "-pthread",
                    "-L#{Formula["zlib"].opt_lib}", "-lz", "-Wl,-rpath,#{lib}"
    assert_match "Parallel mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_par")
  end
end
