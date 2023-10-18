class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.12.2.tar.gz"
  sha256 "9f58f3710bd2094085951a75791550f547903d75fe7e2fcb373c5f03fc761b8f"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e89c212b7dedbf507ebf0a7539d8976bf751631f026915bbe36fc8d0ecdbb872"
    sha256 cellar: :any,                 arm64_ventura:  "e8006cc04b33c0d2f834c7b73f2887b9832f979600488851b7a5091d13239a7c"
    sha256 cellar: :any,                 arm64_monterey: "431799c83071ea311fbaf551e6857edc93242e2858beadb8487f564575bd8128"
    sha256 cellar: :any,                 arm64_big_sur:  "56e46cd536c280cc8fb5e960f0cae7b70cccc0c7891e658aeec1c8a8717dc7b3"
    sha256 cellar: :any,                 sonoma:         "c9d1a67120787d5f3d9efd6c0467d30d1df277a18041272ed580362fc3d76bea"
    sha256 cellar: :any,                 ventura:        "70990b1e46735ced52fe8ee0f8746982d13dbb0ba104b4af21755795e9e79cc1"
    sha256 cellar: :any,                 monterey:       "80ce63d42c4377b4e4d30299bbb9a99f3adfd2d878936ad6717e63bd73fd28d9"
    sha256 cellar: :any,                 big_sur:        "6bb2b22e2ac439e31e786f17b4cc6d64e2449b438fbf899b3cd9cc004351ba24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f947a5b0ea9e97728008bff971b390dc6140849cebe059a431a7a41dab5ea13"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.11" => [:build, :test]

  fails_with gcc: "5"

  fails_with :clang do
    build 1000
    cause <<-EOS
      z3-z3-4.12.2/src/ast/ast.h:183:53: error: call to unavailable function 'get': introduced in macOS 10.14
          int get_int() const { SASSERT(is_int()); return std::get<int>(m_val); }
                                                          ^~~~~~~~~~~~~
    EOS
  end

  def python3
    which("python3.11")
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
