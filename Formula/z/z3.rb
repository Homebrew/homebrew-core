class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.13.4.tar.gz"
  sha256 "4071977e66e9f3d239b7b098ceddfe62ffdf3c71e345e9524a4a5001d1f4adf3"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33767be9506796dc4518a407b431e2ff57337daed711d27181aa5eadbd87db45"
    sha256 cellar: :any,                 arm64_sonoma:  "2677aa05e10d9d7844c2227766c5c125114d0f3f168ccc210400b2595b3f89ca"
    sha256 cellar: :any,                 arm64_ventura: "ee18ddaa3907645b23aa02a4de5edf7737e80d006b04b600b8ba1d9f0d657dc6"
    sha256 cellar: :any,                 sonoma:        "2048bab3779733c006fc64fa70fb3606e0e18453cf344b43ef5f73a8234a9b65"
    sha256 cellar: :any,                 ventura:       "32f7f3ed4fc476dba644b863f93147e93d0e27438dc56427f73fc2eda8829471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3904c130f3951f4b52c99775ce9a3c4268b0742809bfd3dbab69202077132dfd"
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
