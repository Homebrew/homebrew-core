class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.10/scotch-v7.0.10.tar.bz2"
  sha256 "75137f33ed28a12f433d4ab6e92794b2d4cfdd4377d35fe4361bc8e9808ffff4"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4fde16dc755bef5d54d0e878155746e17cdebab4677c4a9a855a59eb47748139"
    sha256 cellar: :any,                 arm64_sequoia: "5d27f3a0fa57ef65aaf1b11989c16f59f39f71381b87ba39b92bc40cf0ff92d8"
    sha256 cellar: :any,                 arm64_sonoma:  "41fbeef3d5a921cc12dd2d85b633a89a3e0c0881349d8eeb2c7ac4a4b3357a3f"
    sha256 cellar: :any,                 sonoma:        "34fd2b83da463390a4742b223a012590a3b48afc5f0fc03fb899483dabcec2e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74b03d23501be289965b5ba5973068d5bf728119d6874392129eaab7cfd00542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae39e826fff736c58d24437ec1ff2b472c72d3228ff7ae0db3321ffb049641c8"
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
