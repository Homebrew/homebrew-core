class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.13.3.tar.gz"
  sha256 "f59c9cf600ea57fb64ffeffbffd0f2d2b896854f339e846f48f069d23bc14ba0"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec1e28f290cfe0e65bce86cb3eda70a43d6e9d773bbf22d3f832c1d73ad24682"
    sha256 cellar: :any,                 arm64_sonoma:  "921e56e3b2283594f609ab011e0bbef138cfed882ffeb52cddac9764625ed2d8"
    sha256 cellar: :any,                 arm64_ventura: "847cd3f2c750dd91147e13d33362ecfd137c64a2221addbd2248097cb06b2326"
    sha256 cellar: :any,                 sonoma:        "dbe25e9ee99069a6c24b1b52fa688419f62d3949aac464f4984fa0c94d259271"
    sha256 cellar: :any,                 ventura:       "8819a26a9165a9e2e309d07a32db67e4f6d12eea025c87fa2d35c588b9393b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bd64aa186c1c10f51035e910c94dc3aca79a3d3a75002a268fcd6f8d8c8e7a1"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.12" => [:build, :test]

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
