class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v6.7.0/sundials-6.7.0.tar.gz"
  sha256 "5f113a1564a9d2d98ff95249f4871a4c815a05dbb9b8866a82b13ab158c37adb"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a90e7954456f3ee804b4ce2cb3c181ee91b0dc4a8c6cc79e9082cc277688c9c"
    sha256 cellar: :any,                 arm64_ventura:  "936dea79aa51c18414bf7a3b9130395401a59459426714699d95d27999c408a2"
    sha256 cellar: :any,                 arm64_monterey: "3d9a19f73298865592c1f32aedca3e24a237a743f899c0aa12fab0d4e82120d8"
    sha256 cellar: :any,                 sonoma:         "1f6b2b80045c78e3e617f121073aa3a87a22e67a2517f600e1cd2902cc746f9f"
    sha256 cellar: :any,                 ventura:        "6c5e05e9e62c55e0d2363748438f3ed9f6d3d22302dce3068f32857b33ccdac5"
    sha256 cellar: :any,                 monterey:       "960727e9a66507ec3d049fec49dab803f4f80e14b059c17de74475ec636a7752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "934e5785ce96356dcaa7885211bfc8d5f5f49d0aa6b2b08d00c6c679a40c1b8c"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  uses_from_macos "libpcap"

  def install
    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}
      -DLAPACK_ENABLE=ON
      -DLAPACK_LIBRARIES=#{blas};#{blas}
      -DMPI_ENABLE=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
