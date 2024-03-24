class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.13.0.tar.gz"
  sha256 "01bcc61c8362e37bb89fd2430f7e3385e86df7915019bd2ce45de9d9bd934502"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4278e29cc8b0fe218593ecc2f704ec5b2770b0fa01dfdd6b4ba374b02c2f8b1a"
    sha256 cellar: :any,                 arm64_ventura:  "f424edf3d0d1119260edd64a35ae684146e3e3078e5a043674956e5ab6a83dc5"
    sha256 cellar: :any,                 arm64_monterey: "c2f60aed2d189398660d6c50dad323dd8b7bb293a5d0fb73c69c890a63c141de"
    sha256 cellar: :any,                 sonoma:         "634ae5a5014e139d68bc21c8a4b0c13778c959746080140c94a6d90632252389"
    sha256 cellar: :any,                 ventura:        "ce5b9801ddaaf010a6b7f775f5887761c7fa74df6f2eaefad091d0198900b4d4"
    sha256 cellar: :any,                 monterey:       "7cabdf66088d2dbfb487d6f324891f71f724637d0868dc5c7b6472f1530480cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bb0403161bbb9ea37b6bb397bc26c523b8b2c77ed1add94d536a321fded39eb"
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
