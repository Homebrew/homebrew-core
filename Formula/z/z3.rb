class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.15.3.tar.gz"
  sha256 "8cfd4d6ab47cafe931446e2c03e10df651d40487730c819f1bf420987144824f"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e707ce569123704fa227f2859027dfa79ac7820eaabde5a6af7061a29a8aa8db"
    sha256 cellar: :any,                 arm64_sequoia: "8bbe44a69095465f11dc2464ede13ed0ef1a9cb89815f5d904ad6bd7a56e2cd0"
    sha256 cellar: :any,                 arm64_sonoma:  "2a55120fa49db52cb4d012f9fb5d6b8aeda5d4d926e55a5cd5be10b124a3c917"
    sha256 cellar: :any,                 arm64_ventura: "f76e7f97ad512d009af4c34adea04b92fe67257d81e3c929d6b0c0405e09e7b1"
    sha256 cellar: :any,                 sonoma:        "2ac2c4b41139f5fe17c9664f2b4e15064356430dd327f25ece21be9faa8ec68a"
    sha256 cellar: :any,                 ventura:       "4da2809295c79702fe281151f274cbecfdcf26067d5a2bc7729ad4c880103163"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6c7ab7c617cffb8c1e238949aceaa40abe0fe39330eff35ab5cb5e64b9cbc58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9efccc815e8c7322db515d8b216e1081374f70874b5adcb8164a617ea4706640"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.13" => [:build, :test]

  def python3
    which("python3.13")
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
