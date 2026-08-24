class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-5.1.0.tar.gz"
  sha256 "c433e1add0431c5edf1644bd9951c40588024d2d288f0e4215e5fcb6e3b4277d"
  license "MIT"
  compatibility_version 4
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5968f6ca3a4c4f2b12e4711b9ca7556fa65a82937f1af7a2a210456ab754adb7"
    sha256 cellar: :any, arm64_sequoia: "7012e78ff0eb81f292949f7992afa7a64388c950151f3435fb4fed4e6926db39"
    sha256 cellar: :any, arm64_sonoma:  "36ccc33c5688b5cd5fc08e16ecc769959b3a64095673a8c51e6fe7df6b9f4c9c"
    sha256 cellar: :any, sonoma:        "c425f32bab80691b5f38e709fbe2c66de6cec21c393128829eab1b80bd0d98c1"
    sha256 cellar: :any, arm64_linux:   "531a1a0d7fa7aefce9e8ea3311ebd64b1a2d3738997db2311c1afb5aa249debc"
    sha256 cellar: :any, x86_64_linux:  "910d6637017f0fcef428944738466811290a242d34932b4253c2b2d222482b1f"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.14" => [:build, :test]

  # The following macOS conditional should be the inverse of LLVM's Z3 conditional
  on_ventura :or_older do
    fails_with :clang do
      cause "Requires C++20 std::format, https://developer.apple.com/xcode/cpp/#c++20"
    end
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

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
