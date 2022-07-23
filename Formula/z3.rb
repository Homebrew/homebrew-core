class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.10.1.tar.gz"
  sha256 "a86071a03983b3512c44c2bf130adbc3320770dc0198805f6f51c43b0946e11a"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e5b63794ddd3b4d29baa8b23a9007013bca679279aa9fc6c8d1bb931a3f85dac"
    sha256 cellar: :any,                 arm64_big_sur:  "9d79b5d64370f784f973972ef5a90e36e3b8bee364127782531b29434dd4311a"
    sha256 cellar: :any,                 monterey:       "0eba7a76ddf9e29b1807cb4d2d5858c0d24e4c476e3d67bb29ff28405009ee9f"
    sha256 cellar: :any,                 big_sur:        "5a52eeda5fb6524c03b0b49ee8938108b80f769842de66a4cad89e00a19b23e7"
    sha256 cellar: :any,                 catalina:       "2511e7c11b540bc05a172611b01a2ed2e6c923ec6b560b31658deb322ea13a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d1294d682cd1e53880af6744999a1e9e17991a22a3c1ac1eb30c62b563ed794"
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
