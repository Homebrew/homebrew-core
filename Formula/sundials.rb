class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v5.7.0/sundials-5.7.0.tar.gz"
  sha256 "48da7baa8152ddb22aed1b02d82d1dbb4fbfea22acf67634011aa0303a100a43"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_big_sur: "1fb71d31c96c648b7e37f8dd45fc8ee95254778cb55ef4dbb3544b1e81835115"
    sha256                               big_sur:       "d48ec042ebd3769d0f7653578641f563ccd288e79e57f265885a44ce11c5801f"
    sha256                               catalina:      "3463bb365a98201d60246485ff5342494a109fef8a082dc504019bd3729a59c3"
    sha256                               mojave:        "33ca24ba24c03fac2a2f4c964d5227935f1ce97bdcb6c37d0b59dd233836746e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a28fd4b0325c725b6e771b2baff5243a61799033863b2fdcd5e0eadbc9dc44b"
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

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    # Only keep one example for testing purposes
    (pkgshare/"examples").install Dir[prefix/"examples/nvector/serial/*"] \
                                  - Dir[prefix/"examples/nvector/serial/{CMake*,Makefile}"]
    rm_rf prefix/"examples"
  end

  test do
    cp Dir[pkgshare/"examples/*"], testpath
    system ENV.cc, "-I#{include}", "test_nvector.c", "sundials_nvector.c",
                   "test_nvector_serial.c", "-L#{lib}", "-lsundials_nvecserial", "-lm"
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output("./a.out 42 0")
  end
end
