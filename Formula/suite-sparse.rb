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
    sha256 cellar: :any,                 arm64_monterey: "9570f13d8bbf0d5fb1325e4314fc48fd9b505eb0f110fb5d3879cbaecad4a874"
    sha256 cellar: :any,                 arm64_big_sur:  "c8fbc735aba72dc8654281521ff0601568d925873c98d2268fa7297cccff72c6"
    sha256 cellar: :any,                 monterey:       "c51ad852f211dbc2e344d0de627f89933b191c95b57b53e47499ded9de8a4d66"
    sha256 cellar: :any,                 big_sur:        "ddd29e66d06ca74ae08450c744d516bd4ad8fd42d655afcfac31ddf4f260c6ee"
    sha256 cellar: :any,                 catalina:       "4c5c24fae85e69e4d3b75ecb79437240c0810ab49324b585f868949a57f4dfcc"
    sha256 cellar: :any,                 mojave:         "a76725e62f88b28dc0d2250b1c2e52b8199372adedd4ddcde8cba3b2b9c783c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb17eb63750da9e79456fc86841d5bdbc083ae39c464c5432a2bdbccf0b9540b"
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
