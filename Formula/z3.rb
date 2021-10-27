class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.12.tar.gz"
  sha256 "e3aaefde68b839299cbc988178529535e66048398f7d083b40c69fe0da55f8b7"
  license "MIT"
  revision 1
  head "https://github.com/Z3Prover/z3.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "62a6cb735ea7e7744489aeb1d486c6786284c886978cc9a61dafb5aa3b17a413"
    sha256 cellar: :any,                 arm64_big_sur:  "04f6d69eb686b83e9f3caf7f99a9fdaa5a1239c30167c7c69fa8148a14fecb62"
    sha256 cellar: :any,                 monterey:       "0d32a039fb63abd2c1b71a2e74e239e32c3d2d94d3b742af6636b0f4753625a5"
    sha256 cellar: :any,                 big_sur:        "661c6b788fb0e3f285e510cc5a6fb6b07c1955f82e8d23115c634b617d495b3e"
    sha256 cellar: :any,                 catalina:       "8ad4662447d7452272499dff0405a75e6d45cef841d1e4345e17747d1555a864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26cffb39e9388f3ee2521301019fe567b6a6b45bd65af3a6bed10256a588f672"
  end

  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    python3 = Formula["python@3.10"].opt_bin/"python3"
    system python3, "scripts/mk_make.py",
                     "--prefix=#{prefix}",
                     "--python",
                     "--pypkgdir=#{prefix/Language::Python.site_packages(python3)}",
                     "--staticlib"

    cd "build" do
      system "make"
      system "make", "install"
    end

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
