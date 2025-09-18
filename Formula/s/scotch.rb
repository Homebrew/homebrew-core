class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.9/scotch-v7.0.9.tar.bz2"
  sha256 "99402474a84dfa4fba360ca1a26b29ee53a0aa4ddd2c170931b124760fb43148"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0a97b87441070cb6a13f4442a241d6f265eb89ca28951dabb59a68661fa8147"
    sha256 cellar: :any,                 arm64_sequoia: "72ceb7e882aa8bd9cedd6fd4f21eb4cc75c6c2cd89598464572c550056b622c0"
    sha256 cellar: :any,                 arm64_sonoma:  "d0b6f73d9cdd71695804b8e3962573741fd5871fb159b2bc5849d491f05cac3d"
    sha256 cellar: :any,                 arm64_ventura: "67d8fa057f659db29e9108936969306d10284853abbc23c1567aa4a46d74f8c1"
    sha256 cellar: :any,                 sonoma:        "71f808fe6a976fec30f5f16e91c7d93fb78e4eeb69614ba8cdf6fd25ba697ca7"
    sha256 cellar: :any,                 ventura:       "520e06b85e1d0bc109e725d13c0c00aaf0e36c0468fdfc2ae0e8a801a6fd17d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85a8d00f5750b4716214029cb4f7851770389f4cba4930450be4870ea28a2826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c440a8ffd1cdc49aa321e9bea2e1c3056b57920a6eeb78ab3d46df2b0514b396"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "xz"

  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_TESTS=OFF
      -DINSTALL_METIS_HEADERS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"check").install "src/check/test_strat_seq.c"
    (pkgshare/"check").install "src/check/test_strat_par.c"
    (pkgshare/"libscotch").install "src/libscotch/common.h"
    (pkgshare/"libscotch").install "src/libscotch/module.h"

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

    args = %W[-I#{include} -L#{lib} -lscotch -lscotcherr -pthread -lz -lm]

    system ENV.cc, "test.c", *args
    assert_match version.to_s, shell_output("./a.out")

    system ENV.cc, pkgshare/"check/test_strat_seq.c", "-o", "test_strat_seq", *args
    assert_match "Sequential mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_seq")

    system "mpicc", pkgshare/"check/test_strat_par.c", "-o", "test_strat_par",
                    "-lptscotch", "-Wl,-rpath,#{lib}", *args
    assert_match "Parallel mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_par")
  end
end
