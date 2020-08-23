class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.8.tar.gz"
  sha256 "6962facdcdea287c5eeb1583debe33ee23043144d0e5308344e6a8ee4503bcff"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "06f1a289d9f846c31fd171ebcad05442eb03473b6aaf4bf1cbb1ca7c6e77d612" => :catalina
    sha256 "3ac5deca9acb17a0a228766d6353048001747543ddcca607871cadaa6c736bbf" => :mojave
    sha256 "e8c20ad5ef814ae9e8700f0e8f79590a11d46e8077be7204a9517a5a0af663a9" => :high_sierra
  end

  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.8" => :build

  def install
    python3 = Formula["python@3.8"].opt_bin/"python3"
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
