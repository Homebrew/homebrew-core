class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.12.tar.gz"
  sha256 "e3aaefde68b839299cbc988178529535e66048398f7d083b40c69fe0da55f8b7"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7718352b7b7b7e3cc454892a563212ac8b02259e90005a1d73ba30062b7e7df3"
    sha256 cellar: :any,                 big_sur:       "ec65441e86922c521bfee1ec48ddcedd7ddcadcaac5b0301ffa5b6ba4cde4895"
    sha256 cellar: :any,                 catalina:      "55d80044e8f62f8846d787c813fa0da76d20b84e278ea173cec922741854790b"
    sha256 cellar: :any,                 mojave:        "0c7796128c833fb0a0da6cafb1d3564d8f42484df722b84035ccbc07a737f69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ded592aadd4c67db5f1dcee03799d7363e48579882cfd34a4c00b71cb87ca28"
  end

  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.9" => :build

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    python3 = Formula["python@3.9"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    system python3, "scripts/mk_make.py",
                     "--prefix=#{prefix}",
                     "--python",
                     "--pypkgdir=#{lib}/python#{xy}/site-packages",
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
