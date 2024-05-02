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
    sha256 cellar: :any,                 arm64_sonoma:   "d7a6ead5ea667caa7a45e1a623ecd386b09748ed5679b5001dda43365c961e01"
    sha256 cellar: :any,                 arm64_ventura:  "507fedcd8807ff385894fda0116da2b80f85ea538f226e67d052603312db559f"
    sha256 cellar: :any,                 arm64_monterey: "9154e1b9ca129bff2844cb26e10b9c23fb9737d7e67a61f97cd79fe868d3840b"
    sha256 cellar: :any,                 sonoma:         "9aada4bc0021e6f8801ea7a23362f19f4514588fdb8e3b7f8550d29ae7960520"
    sha256 cellar: :any,                 ventura:        "7123a10b91659d8f84357d37c037587617fcfbc03888c5bd3693ea4516780f10"
    sha256 cellar: :any,                 monterey:       "c6e139509b1ca4abdebf498a3373546dd14a645c4c56c5ad37092616c6ae2874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d079d6f6808a6dd198b84c7de5c7f21d0b0d0c90ed8ccaad4e64199e4e4a41"
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
