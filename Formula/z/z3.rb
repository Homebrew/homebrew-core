class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.12.4.tar.gz"
  sha256 "25e9b18d04ee22f1d872dfe0daaf4c39034744525214e34fedd206e25140e96e"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "db95e813c6ff08c47f749d56fad0d38c41c1448ef3f4ffd6ac4ba91c3c412385"
    sha256 cellar: :any,                 arm64_ventura:  "9f14c5c0e58889d84b2d579461845aa1f49e6a73d65bea9c67c476531e8689ab"
    sha256 cellar: :any,                 arm64_monterey: "2c325370cc4ece9be02d1c48d12178335ba609b71d83446b5860a1c5855dbe1e"
    sha256 cellar: :any,                 sonoma:         "5f1b2fc65d3290ca3550f48e2987688f576d23f61425861a298bea67cb028264"
    sha256 cellar: :any,                 ventura:        "0fab3d037ce7eac020c2949e0271e104551abcf5b8642777c01cebcee403fef3"
    sha256 cellar: :any,                 monterey:       "340d0697307b063d6ac5ba6698cd30d7258e6dce3ec27849984ff117f76de812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05cbdff592f59ea560c47160c4c89fba7d66342a30607c6403dc72c398903b5e"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-setuptools" => :test

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
