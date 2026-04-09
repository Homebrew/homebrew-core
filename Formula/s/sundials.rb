class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/llnl/sundials/releases/download/v7.7.0/sundials-7.7.0.tar.gz"
  sha256 "115bebf25ad0380428e389b8a1a7896725f33cd7c98bbaec8ce2a9ae13812c46"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98e1ddacb1e65111a29e9e4f5ab3e21f8ee232b3f517d779cfa5a33df1582189"
    sha256 cellar: :any,                 arm64_sequoia: "29b15da812a8da99b803d2b2c40b00a2e89ed20609055d071eac008a7355e3f6"
    sha256 cellar: :any,                 arm64_sonoma:  "30a2da3fd9660935f6700c250f66cda384a97e5fb44c72fe9d77f383ac0ff122"
    sha256 cellar: :any,                 sonoma:        "fa77a74a7082d97259498b211ee12426a21dacb8d58598507df710cc57559e5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31184238f55e92112ed494f036a5310b4bae98bc15e30daa3fd6ef04a4fa1597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ead433c94afc1e547801d3e841404bfe1068d073eeb70c0d485bcdf26844dd04"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_KLU=ON
      -DENABLE_LAPACK=ON
      -DENABLE_MPI=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Only keep one example for testing purposes
    (pkgshare/"examples").install [
      "test/unit_tests/nvector/test_nvector.c",
      "test/unit_tests/nvector/test_nvector.h",
      "test/unit_tests/nvector/serial/test_nvector_serial.c",
    ]
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
