class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.4/scotch-v7.0.4.tar.bz2"
  sha256 "97dbe0445231a7ad818ad3615c0128814c9b3e2514d10af0a9a89840888a487e"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4e955eb59faa64c6eaac17ac90a5f81f5964c07cc30043220402fca109dbdae7"
    sha256 cellar: :any,                 arm64_monterey: "f7ff675ff26315f13cd6791fd0c360bf330a8c7ab4f17053cc3dc056be235925"
    sha256 cellar: :any,                 arm64_big_sur:  "d4ba89fe8aa9288e63f51e21700bb47761f52430ee8ebe84651b8e4cb7f2a7ea"
    sha256 cellar: :any,                 ventura:        "8c8f68140b68c8c1753a57cec616275db2606d9b04e378ac0e7178c3b830380a"
    sha256 cellar: :any,                 monterey:       "78eb8974aa3dcc0a19a39465e6d2e3528169e7f7ae103cd0384015f52c13af8a"
    sha256 cellar: :any,                 big_sur:        "84cebae59eb1307765ad6314e6557e01d4300980cdc94b18b6f31711e8702699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fb598235fa27e3dd3169df39cddfa434a592fd0750eea410100b875e8b148ad"
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
