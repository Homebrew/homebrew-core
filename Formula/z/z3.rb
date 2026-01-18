class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.15.4.tar.gz"
  sha256 "dae526252cb0585c8c863292ebec84cace4901a014b190a73f14087dd08d252b"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f57f90f63a0995a9b56b6f4c94a1c29bd8fd9a474e09f78cba7f64aaf25708c"
    sha256 cellar: :any,                 arm64_sequoia: "df9a167ac9c51be88180cbe464e09c46315c6145e775ca8da76de4d4e261354c"
    sha256 cellar: :any,                 arm64_sonoma:  "734ca95d3bcb87f5c62e27294ea3485698ac160a8bc0cb6eafa68ca73f792ce0"
    sha256 cellar: :any,                 sonoma:        "daa3779a2ee08f218dd714c80ce78e9451b81340c65efee8a1f44f16dee8aa07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02148c88d3b6adc67f7cb43fc1eb3f8a1a7317838a567e7de95c60cffc4fd208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aecd2a8e5cc6512f5ad5cc3ba78602236642ac02d4471fc9635383976012236d"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.14" => [:build, :test]

  def python3
    which("python3.14")
  end

  def install
    args = %W[
      -DZ3_LINK_TIME_OPTIMIZATION=ON
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
