class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.12.1.tar.gz"
  sha256 "a3735fabf00e1341adcc70394993c05fd3e2ae167a3e9bb46045e33084eb64a3"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "de7a906ffaca85ea45dd539fa56699d29daaf5acb734b93cf4ff737203376e24"
    sha256 cellar: :any,                 arm64_monterey: "41357aed8d69b68eeb823a4b1ae603a384c2c104c789411d222909bb09265071"
    sha256 cellar: :any,                 arm64_big_sur:  "01a528ad6cd584216f682f6a05a9bc413d96fb881b87e9ec2a15a56efb08d166"
    sha256 cellar: :any,                 ventura:        "9918c8a891562b14bb69d7642a5f3cf5a79767baf78970710fd9c67e405a2f37"
    sha256 cellar: :any,                 monterey:       "5707278f339e55a64b1dfcd2ccad204be4352d0326b370f7f3af94b88652d3b8"
    sha256 cellar: :any,                 big_sur:        "59b19f0d8232e43f61a942ca91a91d8c1f2b47874c0118e31517a6ef27659d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8039fa032a059b5dfc7b61412dc6a446b1f16839e5efaf52b3e61428ea613a2"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.11" => [:build, :test]

  fails_with gcc: "5"

  def python3
    which("python3.11")
  end

  def install
    # LTO on Intel Monterey produces segfaults.
    # https://github.com/Z3Prover/z3/issues/6414
    do_lto = MacOS.version < :monterey || Hardware::CPU.arm?
    args = %W[
      -DZ3_LINK_TIME_OPTIMIZATION=#{do_lto ? "ON" : "OFF"}
      -DZ3_INCLUDE_GIT_DESCRIBE=OFF
      -DZ3_INCLUDE_GIT_HASH=OFF
      -DZ3_INSTALL_PYTHON_BINDINGS=ON
      -DZ3_BUILD_EXECUTABLE=ON
      -DZ3_BUILD_TEST_EXECUTABLES=OFF
      -DZ3_BUILD_PYTHON_BINDINGS=ON
      -DZ3_BUILD_DOTNET_BINDINGS=OFF
      -DZ3_BUILD_JAVA_BINDINGS=OFF
      -DZ3_USE_LIB_GMP=OFF
      -DPYTHON_EXECUTABLE=#{python3}
      -DCMAKE_INSTALL_PYTHON_PKG_DIR=#{Language::Python.site_packages(python3)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/c/test_capi.c", "-I#{include}",
                   "-L#{lib}", "-lz3", "-o", testpath/"test"
    system "./test"
    assert_equal version.to_s, shell_output("#{python3} -c 'import z3; print(z3.get_version_string())'").strip
  end
end
