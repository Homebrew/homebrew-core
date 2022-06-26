class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v5.12.0.tar.gz"
  sha256 "5fb0064a3398111976f30c5908a8c0b40df44c6dd8f0cc4bfa7b9e45d8c647de"
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
    sha256 cellar: :any,                 arm64_monterey: "d5b574cfaaf805d7551e4c53c63be76894cb203cbf023233f4319979c497ff82"
    sha256 cellar: :any,                 arm64_big_sur:  "1f38820a7a22ab471398656416c55fe1f9640353d7f39d4280b320b02f0f44d1"
    sha256 cellar: :any,                 monterey:       "f258fe66db7f42f7a37df007e7869c13d86897b222e98969d8ca85535fc485f4"
    sha256 cellar: :any,                 big_sur:        "82c4221826d5aa01e9767598da7155ebf41bf2add188cd684456c188c4ee647e"
    sha256 cellar: :any,                 catalina:       "f21dfb630d3b05c13474d315776825bd4508e8bcca52d8527e112f48781b1531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0e65f3f30a84769cd093fef6afa7bbcb080fb5770f94f27a4d1115f7c09e8b"
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
