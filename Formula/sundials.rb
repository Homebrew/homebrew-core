class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v6.3.0/sundials-6.3.0.tar.gz"
  sha256 "89a22bea820ff250aa7239f634ab07fa34efe1d2dcfde29cc8d3af11455ba2a7"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a80a97085d63d65189d9d266ceb5941566ea011a840f2d0a74a2ed0cfc36aa87"
    sha256 cellar: :any,                 arm64_monterey: "7589b240ea07145c55f634100f00204fd3918c1632d3d4e6f8edc97dacc830f4"
    sha256 cellar: :any,                 arm64_big_sur:  "68630220962300923d5a63a6d135364add46bd058c1651f9e7a43bafa8ef7029"
    sha256 cellar: :any,                 ventura:        "6f8021b99b9258ef5f0cafac1d910eb93fa4b3975c03469118417b3e5a02cceb"
    sha256 cellar: :any,                 monterey:       "18e9d07618cc03ee9373c0d38c43fcc7e7576a4ecb7dffa64eed8d54637f97ea"
    sha256 cellar: :any,                 big_sur:        "754766b19dc7345f378d3125978705348cfc04bd1cfe27f99862c5b657b17d29"
    sha256 cellar: :any,                 catalina:       "735b7d4cba622ebfebd63f44484eeb1fb05fc2009f1f4dbc7cb75da6158cb815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43d5d8fe571749bcbc7981b58e9829c2574a05372dc3e9ef806972f26262038a"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  uses_from_macos "libpcap"
  uses_from_macos "m4"

  def install
    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}
      -DLAPACK_ENABLE=ON
      -DBLA_VENDOR=OpenBLAS
      -DLAPACK_LIBRARIES=#{blas};#{blas}
      -DMPI_ENABLE=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Only keep one example for testing purposes
    (pkgshare/"examples").install Dir[prefix/"examples/nvector/serial/*"] \
                                  - Dir[prefix/"examples/nvector/serial/{CMake*,Makefile}"]
    (prefix/"examples").rmtree
  end

  test do
    cp Dir[pkgshare/"examples/*"], testpath
    system ENV.cc, "test_nvector.c", "test_nvector_serial.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lsundials_nvecserial", "-lm"
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output("./test 42 0")
  end
end
