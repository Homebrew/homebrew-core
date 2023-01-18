class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.12.1.tar.gz"
  sha256 "a3735fabf00e1341adcc70394993c05fd3e2ae167a3e9bb46045e33084eb64a3"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea1f3230c0febedfb16c9f943a68e05a4dd5d997818e6462bc81b70e45cffc68"
    sha256 cellar: :any,                 arm64_monterey: "481a7a83ba02cbfc7d38b630c20ea7c5b6fcca83e3295b956131e6d78bbde057"
    sha256 cellar: :any,                 arm64_big_sur:  "5d76d998409009239dc736bbede4065f19dddc641671d2f163d3f2b5dff79f09"
    sha256 cellar: :any,                 ventura:        "92a9b9975b27cdc4a99f082e3962157abd8aed65b762f044a3f384a5ba8b2bcc"
    sha256 cellar: :any,                 monterey:       "c1ac2990e0ec97c65f57bdcb06912e0fec5006e0c33e94cb9dd022f4d0111bb2"
    sha256 cellar: :any,                 big_sur:        "4a95bc0657a0e7687ba146fab537fad7ce24311b5acccec811709f1c0fcfed72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afbf73e6df6ca7ccfd4a6c2a28d827ef4c2fbba31f996a808dd23622268b2509"
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
