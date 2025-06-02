class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.15.0.tar.gz"
  sha256 "16aa2c02ff34a902a38bddc29f6f720deb1fb6c6987c45ccb782430300f5ccc5"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3e3fbb6153448fc9fe3befc53a0170ad45369f07209b400d90305ce0d645a5b"
    sha256 cellar: :any,                 arm64_sonoma:  "3163b8e0e65799a4e7a96e7d7ceb4a959386d77fdba320dd7bb0f381c19c1b3c"
    sha256 cellar: :any,                 arm64_ventura: "221c41e0d66f5a2baeb60146f40875e2d6ca496d062b06c76d3924a4d15748f9"
    sha256 cellar: :any,                 sonoma:        "f9274cd0950dd9c9314d19fb3cbc8baf7a4802ca3c4ef882bdb74df0c9fd2333"
    sha256 cellar: :any,                 ventura:       "c151a05ca6866e2e83fc1b7d00bed224c5116f6d68ba645b1c3f1101b8c7fac7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37cbe0ad948d47bce9e6d6c4856c4f5d9cf36e871ae2d55f236388e7496094e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "216b1f2393ca8c38e413daf5a5db5e572b7f769d3c4d2ce7963a8c9f559ac03f"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.13" => [:build, :test]

  fails_with :clang do
    build 1000
    cause <<~EOS
      Z3 uses modern C++17 features, which is not supported by Apple's clang until
      later macOS (10.14).
    EOS
  end

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
