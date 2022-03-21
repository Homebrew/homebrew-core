class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v5.11.0.tar.gz"
  sha256 "fdd957ed06019465f7de73ce931afaf5d40e96e14ae57d91f60868b8c123c4c8"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6a9b4d595113e4b93317f0ed5af84ee3e2895098a08a9b1ec426ac1ddc106960"
    sha256 cellar: :any,                 arm64_big_sur:  "26a2af9b68a60fd3e14b1a8ee02ac06a1fc7f3e55b795d572014b4aedd549fec"
    sha256 cellar: :any,                 monterey:       "360a9ed5fc1badfaa174aa5029270c5449de1195445d92b71aed283d29eba11f"
    sha256 cellar: :any,                 big_sur:        "1b125774f80c69b6dbe95403a94b2461a79d31ade9fc38b2a25a54fe63c2cd20"
    sha256 cellar: :any,                 catalina:       "8ac1c5d07ae18444166604f35567371a558f4627dbe63eb64c7efcd7d1df8664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bb06a4e91c606b873d9afc7c5f2c51213bc224f31bd73edbec0ea9301d1bb53"
  end

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"

  uses_from_macos "m4"

  conflicts_with "mongoose", because: "suite-sparse vendors libmongoose.dylib"

  def install
    cmake_args = *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    args = [
      "INSTALL=#{prefix}",
      "BLAS=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "LAPACK=$(BLAS)",
      "MY_METIS_LIB=-L#{Formula["metis"].opt_lib} -lmetis",
      "MY_METIS_INC=#{Formula["metis"].opt_include}",
      "CMAKE_OPTIONS=#{cmake_args.join(" ")}",
      "JOBS=#{ENV.make_jobs}",
    ]

    # Parallelism is managed through the `JOBS` make variable and not with `-j`.
    ENV.deparallelize
    system "make", "library", *args
    system "make", "install", *args
    lib.install Dir["**/*.a"]
    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
           "-L#{lib}", "-lsuitesparseconfig", "-lklu"
    assert_predicate testpath/"test", :exist?
    assert_match "x [0] = 1", shell_output("./test")
  end
end
