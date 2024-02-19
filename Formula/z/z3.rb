class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.12.5.tar.gz"
  sha256 "70e211e0a8e77febccc51865e45111066f623356a4ef0b527c3597362bc6db72"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c63feb61152b3783f6218fc06c5c0439cfc4291973c7c5463020c825d322d418"
    sha256 cellar: :any,                 arm64_ventura:  "653bed5f6547c170ffb9e85608ef8c712bf5a79d049bbfe2797545422354dd7a"
    sha256 cellar: :any,                 arm64_monterey: "06ee3ab593570d7e80a70c000404893add11f035bfa153432a5e9179882d4989"
    sha256 cellar: :any,                 sonoma:         "b250b89ec1de9431df7d9da9a07491f7059eadcfe345aa3eba0613593bdcc25a"
    sha256 cellar: :any,                 ventura:        "d33d8732ab658e5be56658c0a50724c599dcdd1de7542cae80a293a37a1db112"
    sha256 cellar: :any,                 monterey:       "7eb4c99094a80f1a6a2d23c073fe6046f4f2857f2d65ff3a20279813a6ebf441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a77aa1e4d98387d8334d063862f14f0f8ecc4a2b6be9047d86285ec8b528259d"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-setuptools" => :test

  fails_with gcc: "5"

  fails_with :clang do
    build 1000
    cause <<-EOS
      Z3 uses modern C++17 features, which is not supported by Apple's clang until
      later macOS (10.14).
    EOS
  end

  def python3
    which("python3.12")
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
