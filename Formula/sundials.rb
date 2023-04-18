class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v6.5.0/sundials-6.5.0.tar.gz"
  sha256 "4e0b998dff292a2617e179609b539b511eb80836f5faacf800e688a886288502"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a48dd4520c7151ce4795b842153ea4bdc77ef4b06fbdfdd0df25b609038d64ca"
    sha256 cellar: :any,                 arm64_monterey: "cdac128562ccbb0cc63d232f70cbade11e33d89133ccc2ffb74649427c292350"
    sha256 cellar: :any,                 arm64_big_sur:  "2f9b9624036c333f079570abbc9af03daa8c498a788a38cf3361d8d97152c81a"
    sha256 cellar: :any,                 ventura:        "ee7aade8dba27f4e6281a785b79012f71b6701cc775dc9a0efdd82516b13d369"
    sha256 cellar: :any,                 monterey:       "c89daddc370b11612578ab9c54a435a08440a2a635e9b248b23f9030d5cf2714"
    sha256 cellar: :any,                 big_sur:        "330af17a201f90e88b6a6329cb92fc8c590f31cec53fdde68e558e9f6c31f41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1dbb51411fa5ff52802ebf9bbc4a4df03513271f12a9641e64b96368301d487"
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
