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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "25ffba5dac94b2d5d8070bd3235f28e6e064ed9a36370ffe68740319a6809549"
    sha256 cellar: :any,                 arm64_monterey: "677562f0bb1ab8b025e12bd01d3fb6e377d7cedae20675a4bcdc2cee7671d2b8"
    sha256 cellar: :any,                 arm64_big_sur:  "04f835bb74186dc32df020d2214bfaf463877ec0f73e211597f6b3ec61749d29"
    sha256 cellar: :any,                 ventura:        "d60a684faa6ff2050adba2a8880441ff47b54a41be752e6cda61f305437bd112"
    sha256 cellar: :any,                 monterey:       "f2dc9b5807fbc14942bd69e2a01a88ce53d05d97180815f47f77f2b8fe3cc4e7"
    sha256 cellar: :any,                 big_sur:        "d151616255d71fa901e27307fe8a52a7238c6caadf16f2a56040eec1fe82edcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fd343ef4547fc890489f6eb49d35bf2ea9530b43e8c2b3a3f991212501992b0"
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
