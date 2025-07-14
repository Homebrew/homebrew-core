class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.15.2.tar.gz"
  sha256 "3486bf5b35b185981cab0b0a81f870547648a1ca433085aa79afd17c44959751"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7f15b8067b785c6131501f87a4c5c83aed3b1877ec3e6329692d1f144ee4085"
    sha256 cellar: :any,                 arm64_sonoma:  "09928918b5ab02f225d0161545d543cb7c6b3520328680deed2d663fdb4e56a8"
    sha256 cellar: :any,                 arm64_ventura: "6f4623c97b742a73119dea2f3b98045362d2b888abb17657a8f85c691f8b5937"
    sha256 cellar: :any,                 sonoma:        "bfdacc628b9f9122d3c8ab1cde6984617fdd8452550bf5beef64932c2b37128d"
    sha256 cellar: :any,                 ventura:       "69a246e51631d635aa7c96d9cdac354cecd363bd209b78da12e8ce42bf98e490"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e994f9ed092486cd0929ad3dfe6b22d8fec1e6e9d67d6888254f2aa332d0d6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db44ef8b09acd2e27f7539b923604ec74dd37f10f93c59c070b5971c91bcfd7"
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
