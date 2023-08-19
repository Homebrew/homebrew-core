class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v7.1.0.tar.gz"
  sha256 "4cd3d161f9aa4f98ec5fa725ee5dc27bca960a3714a707a7d12b3d0abb504679"
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
    sha256 cellar: :any,                 arm64_ventura:  "beb04f4b1eff8c83767996c769b8e390e6068bde47c1bdadbb0edcdb3716c548"
    sha256 cellar: :any,                 arm64_monterey: "1eedd2086ad86327bb00d09df5cfdda8ca6f060b6baf06f4e6b539212a7e5ab8"
    sha256 cellar: :any,                 arm64_big_sur:  "0954c853c33c241ee5699d8d403c8c6188619aad53fb3bbe118f0482bed9135a"
    sha256 cellar: :any,                 ventura:        "68932860389092fc6ff96da6e3acbea848fc852c1318fe7d85cc538c21851e2a"
    sha256 cellar: :any,                 monterey:       "b7006fdf86ee0fa8cedc5fc8412d0257db8905fcceac0bf5d66550835d519050"
    sha256 cellar: :any,                 big_sur:        "0835b3fed3a176c62fcc0bd236171a0dbddcf59ef30397a03e08340ad10eb180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e99c1f8ec26104537af0319f4c56f2c3a8352746ab8ea07273d0d5552adce3f"
  end

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"

  uses_from_macos "m4"

  conflicts_with "mongoose", because: "suite-sparse vendors libmongoose.dylib"

  def install
    # Force cmake to use our compiler shims
    if OS.mac?
      inreplace "GraphBLAS/cmake_modules/GraphBLAS_JIT_configure.cmake",
          "GB_C_COMPILER  \"${CMAKE_C_COMPILER}\"", "GB_C_COMPILER \"#{ENV.cc}\""
    end

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
