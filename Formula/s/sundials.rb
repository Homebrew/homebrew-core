class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v7.1.1/sundials-7.1.1.tar.gz"
  sha256 "ea7d6edfb52448ddfdc1ec48f89a721fe6c0a259c10f8ef56f60fcded87a94bb"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1706f37becde249faa65de4f19a429f7e0573700b0f5e32e3595c7fbf67c4809"
    sha256 cellar: :any,                 arm64_sonoma:   "217cb17084cd6eaf86ffa794f810b1b439681817ccefce2d588af33bfd49b2e1"
    sha256 cellar: :any,                 arm64_ventura:  "da7af9deea670031566961b0f33b27305a21131dbe44e13b175b29bc70e31a61"
    sha256 cellar: :any,                 arm64_monterey: "06ddfa44368b61e59c3cc82fd157b1f9ac24bb7e66f476f72e645bbc9064c645"
    sha256 cellar: :any,                 sonoma:         "0314d17b913594c3f838fbf0e312344d1872f704e2c2f69bacdc3c6cbe67299f"
    sha256 cellar: :any,                 ventura:        "d4d9520a6e99ee7fd1ff6ef1d9eba83427fc3af9401f08235606743f937a018a"
    sha256 cellar: :any,                 monterey:       "df5b9cfa1cbbf56bc28139dc63afadc808fa4b7b2cab8f3c82652b428d3d5806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c04f68df6b0d3f24eabc75bc5cccda2ee43e12dcd7b345ec838d81410132fc8"
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
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}/suitesparse
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
    rm_r(prefix/"examples")
  end

  test do
    cp Dir[pkgshare/"examples/*"], testpath
    args = %W[
      -I#{include}
      -L#{lib}
      -lsundials_core
      -lsundials_nvecserial
      -lmpi
      -lm
    ]

    args += ["-I#{Formula["open-mpi"].opt_include}", "-L#{Formula["open-mpi"].opt_lib}"] if OS.mac?

    system ENV.cc, "test_nvector.c", "test_nvector_serial.c", "-o", "test", *args

    assert_match "SUCCESS: NVector module passed all tests", shell_output("./test 42 0")
  end
end
