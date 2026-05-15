class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.11/scotch-v7.0.11.tar.bz2"
  sha256 "82fb468485b153a41031e50a7ca668fccbd3b8561d31dc7535da4210dde01f48"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d84363ab0cdc3b0a2b0d05347158a30361f2694e441db84e4fdd549ceb39ac31"
    sha256 cellar: :any,                 arm64_sequoia: "cf99aaa54bdf7ca12122af0d4bf5adfee1227dd613789645ae37f7decda59885"
    sha256 cellar: :any,                 arm64_sonoma:  "fd4cdbffde2ed42d05c78fa4d0ff32a6acb18504a682d44b709c752a86b1425b"
    sha256 cellar: :any,                 sonoma:        "70c317924634f70ef971e306832042b778c105ddf4708e9c2f51291c86a92d0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e676c45f8ddabb75072cf687e37ab3be3ec7bbccb3636488c1bc07f498fd593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df940782b8de2e7b436fc7c64bca5210cec1a38a9e5bb6c679bcb0f3c5d43e8a"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "xz"

  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    args << "-L#{Formula["zlib-ng-compat"].opt_lib}" if OS.linux?

    system ENV.cc, "test.c", *args
    assert_match version.to_s, shell_output("./a.out")

    system ENV.cc, pkgshare/"check/test_strat_seq.c", "-o", "test_strat_seq", *args
    assert_match "Sequential mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_seq")

    system "mpicc", pkgshare/"check/test_strat_par.c", "-o", "test_strat_par",
                    "-lptscotch", "-Wl,-rpath,#{lib}", *args
    assert_match "Parallel mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_par")
  end
end
