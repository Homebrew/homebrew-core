class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-5.4.0.tar.gz"
  sha256 "93fd02f69cb4e2811cc20f20a9b34d4f511c21177ac9f8c288a18d6e7ada885e"
  license "MIT"
  compatibility_version 6
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d5a1fafa2e228731b15f4ecec48a80437cd938eb0ed09437086f17e0e3e78134"
    sha256 cellar: :any, arm64_tahoe:       "acb2234b93bffe1d3852f75f74909d1d287d938f2f4cc75b3d88cbe3e41121ba"
    sha256 cellar: :any, arm64_sequoia:     "44f93b5ccd73b85af1140c8799619d98d2d6f472bae1d00e55194d574008ea75"
    sha256 cellar: :any, arm64_linux:       "4d2aa5683258c8467491b36639e4af1cbc045ed4d4b21751c31800f8458eff70"
    sha256 cellar: :any, x86_64_linux:      "592540670577eb3d216027ead7977180f4d2a0a19371ab1eaef24b063463657b"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.15" => [:build, :test]

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

  deny_network_access!

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
