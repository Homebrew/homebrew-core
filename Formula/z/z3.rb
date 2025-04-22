class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.14.1.tar.gz"
  sha256 "81a02c2c64c64d6c3df233f59186b95627990ada0c4c2fc901c9c25a7072672a"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0090d3a9aac7fbbbb0734cdb24c0a8f891d99b97bc5e527ecf6db407cb17b4d2"
    sha256 cellar: :any,                 arm64_sonoma:  "417eee5d3418c20ab826556d37a9ec57e5c48bdfb124d74d9afea1afe7d6e812"
    sha256 cellar: :any,                 arm64_ventura: "e7c48be023485b5ffa72321ee393746a12605d51d16edc1c63c3d24155dd73a1"
    sha256 cellar: :any,                 sonoma:        "4b1741f4f67c61f3940928952d35fb3b100181f01800b6f6709c57a8ffe65e07"
    sha256 cellar: :any,                 ventura:       "8fda087e030d4037ca1a93192b6687062a603adf11023950967cfa094b6b97ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "384fddca3102165fcf519aabe8e1e8d98f66bed2b33b700eb17e4dd54fb5afe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d76c62a96c651909152362695d8e74d6125af4d3f6d79ce3559d2e5d96bea9"
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
