class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.1/scotch-v7.0.1.tar.bz2"
  sha256 "4ce908798ebdf0ae8dc7899a51bbebe6f274c195e28ecbb29724681eee31a6af"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "46a3cc42b5362cb35a182a6b10d77913936c380d09298de39799ac7c7ff95d56"
    sha256 cellar: :any,                 arm64_big_sur:  "be66bc36acfa18ce38d45c642cb83830dd208d91ca3c2612312bae484a6eecfe"
    sha256 cellar: :any,                 monterey:       "57283af1e66679f2137cb7926b1789bf5f6a080eec4b679db53364c3c081d7e1"
    sha256 cellar: :any,                 big_sur:        "0e4ec98850e307bfc39a16d9572cb8e1f4e1bd4a214f117be55c12a4715b5365"
    sha256 cellar: :any,                 catalina:       "4b51d16f211dbe4d8777c69501423ab7d480c5efad89416067c46319702df7c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd55e5d0770829bb50d600703003ce0e19b8453f00ccfdb265ac8f3d2382e6e2"
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
