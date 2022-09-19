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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "cd1bc06fbd7e30b76bb7a0f35ee0ef52a68459c27014ee90fb7a3fa588e7bbcf"
    sha256 cellar: :any,                 arm64_big_sur:  "7b5fadd9f6aae033204b2a487c7ce4717ab1f517731f19a6a11a7b4efd3af7f5"
    sha256 cellar: :any,                 monterey:       "e457a273130050594a4c71166392cad9d19e4d3159770cf6173adae279d77247"
    sha256 cellar: :any,                 big_sur:        "66edef24ae8885d0caacfa3b708b968df8d784653704cfb8052848382d6ebbd8"
    sha256 cellar: :any,                 catalina:       "62f3afca0e299f799396399839c6c0bf98f56e607a8887fcf294d3b09b10f9f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19fea9a2eade95898190d751a651886b973591ec9f2e0e8ad327cd8abf75a607"
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
    do_lto = MacOS.version != :monterey || Hardware::CPU.arm?
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
