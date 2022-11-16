class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.11.2.tar.gz"
  sha256 "e3a82431b95412408a9c994466fad7252135c8ed3f719c986cd75c8c5f234c7e"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "f46c3e315a7e2a03714d5ede129df98bc3ef41786e0e0d061bc4d61043234881"
    sha256 cellar: :any,                 arm64_monterey: "f4105981678b6bd31c32287e36528e1dd67add716992099064d8619c1083c2da"
    sha256 cellar: :any,                 arm64_big_sur:  "aaebd36b98db60eb30f2854e23e6d57579701b4467a0a95bf3566912f747d95f"
    sha256 cellar: :any,                 ventura:        "25352cf6fc580750f461db718b0aeb14ec311c1be4ed7458027303416e348716"
    sha256 cellar: :any,                 monterey:       "f8c5ff44aaf7d0ca43fd5d47c687dd30856162290f9e06c7cf447013f0c96013"
    sha256 cellar: :any,                 big_sur:        "77a1c6b2fd240446b9d8b7b5fac451bd83c100df370f7ad5d718081a6646dd1a"
    sha256 cellar: :any,                 catalina:       "8c95b118eb284a9f6f9e58429553c643ed50e38dea4eb625a3d77f26e0c17079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf1f56a098a185de89c0fb2341cbae1e8f8a0aa0de74623db7d45e2a62e2d3ca"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.10" => [:build, :test]

  fails_with gcc: "5"

  def python3
    which("python3.10")
  end

  def install
    # LTO on Intel Monterey produces segfaults.
    # https://github.com/Z3Prover/z3/issues/6414
    do_lto = MacOS.version < :monterey || Hardware::CPU.arm?
    args = %W[
      -DZ3_LINK_TIME_OPTIMIZATION=#{do_lto ? "ON" : "OFF"}
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
