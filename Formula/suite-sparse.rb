class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v7.0.1.tar.gz"
  sha256 "dc2f8d5c2657c120b30cce942f634ec08fc3a4b0b10e19d3eef7790b2bec8d1e"
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
    sha256 cellar: :any,                 arm64_ventura:  "b6f9bfc437eb8c888ad2b49127dd8b6d6d2ace0fe39ce5c375b6f59b4edcfbb2"
    sha256 cellar: :any,                 arm64_monterey: "6e8b79482446c5d3651af243673c38bddb77c4bf12b04cf241bf3d1d3803abcb"
    sha256 cellar: :any,                 arm64_big_sur:  "717d20eabb9375578fbb3eb2dc1983528b594bd79a19d169630d59c2293dace0"
    sha256 cellar: :any,                 ventura:        "690df0fd91c2e9fc691f0d22c9d3f32ba233eb29d4d249a8abdf3c3d22ee1a08"
    sha256 cellar: :any,                 monterey:       "e33accf36e6cbe4680f30435ce7678137df51adecc0dd567b871524097659097"
    sha256 cellar: :any,                 big_sur:        "0830a6f917ff6bb25488761cc7c932bc168db3bd28d0d361941c7d7042c060ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e6d11898083878b3fef560f985e74a3f2f9a659c63e7575acba297d374a7d3"
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
