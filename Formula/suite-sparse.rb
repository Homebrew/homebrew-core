class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v5.13.0.tar.gz"
  sha256 "59c6ca2959623f0c69226cf9afb9a018d12a37fab3a8869db5f6d7f83b6b147d"
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
    sha256 cellar: :any,                 arm64_ventura:  "1a69bd61a325e8da6af49bec6dcdc63e63dc8a3543cdc34ecaaf243e27514f5d"
    sha256 cellar: :any,                 arm64_monterey: "f9a227434a76d41665032eab22d00590ec3cea9d331ded561d9f634d2964e033"
    sha256 cellar: :any,                 arm64_big_sur:  "8bd3133802f6ed63805a8deb96a7b42f7b6bfe675a37a271a01579e31e0c1551"
    sha256 cellar: :any,                 ventura:        "d1a14a4d0adfe83a9e63b91f3e510de22834508d3474ac1e1a586c92b3d85a8f"
    sha256 cellar: :any,                 monterey:       "c0efff893c632622b771e9655416da6f99461b95f8bcc891598c1fb572f5833a"
    sha256 cellar: :any,                 big_sur:        "b139b693b4dc71b613cdc6a334bc54a01d12948bf785654d5e985ba7bd8c6b73"
    sha256 cellar: :any,                 catalina:       "9df968f3674e21101e9018c57d6f7d1a2a60a76f13e7520b506e1396f82765b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1cac2166f91aa6e103afed16a9b050898f6e3e0bf3c877740f1c1c14e085bc4"
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
