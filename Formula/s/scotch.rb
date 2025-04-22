class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.7/scotch-v7.0.7.tar.bz2"
  sha256 "d88a9005dd05a9b3b86e6d1d7925740a789c975e5a92718ca0070e16b6567893"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "39084ae881ffe4dccdb9d22b73055f179fc30b7e60ae5428036996c7055bb56c"
    sha256 cellar: :any,                 arm64_sonoma:  "c55478e91e7451e694d3ab1c809d4c56718cc95c3c4977704d234e9a7214b637"
    sha256 cellar: :any,                 arm64_ventura: "1d0b2f7d0f7aa088a2f9b197995dcfbcd1d76c6f86e39639a894ac12d076d74f"
    sha256 cellar: :any,                 sonoma:        "80a9d176f4bfe11816faa6b4297383557f5a9d8c65ea50e0e2842981c51ef522"
    sha256 cellar: :any,                 ventura:       "f3393fa769311f954f65d3453bae2a3853eb3b3eb5ab08437b2d323d457e8c86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82d32fd19a12847c9ae008fc199e30f692068503f6a92e0395ce194e6acf16fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "855bafd1f9712cfe84d3dfb9bc11f17856b95304d65449a450672ef996dae625"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "xz"

  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DENABLE_TESTS=OFF",
                    "-DINSTALL_METIS_HEADERS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "src/check/test_strat_seq.c"
    pkgshare.install "src/check/test_strat_par.c"

    # License file has a non-standard filename
    prefix.install buildpath.glob("LICEN[CS]E_*.txt")
    doc.install (buildpath/"doc").children
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <stdio.h>
      #include <scotch.h>
      int main(void) {
        int major, minor, patch;
        SCOTCH_version(&major, &minor, &patch);
        printf("%d.%d.%d", major, minor, patch);
        return 0;
      }
    C
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
