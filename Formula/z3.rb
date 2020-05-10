class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.8.tar.gz"
  sha256 "6962facdcdea287c5eeb1583debe33ee23043144d0e5308344e6a8ee4503bcff"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "e6b1fd595c6d30255920cd12bd5e0614146c13701b5649cf53ba2b3633e51edc" => :catalina
    sha256 "9e55e1e2351dd2d308ab2b650eaefe05a58294bb30b30dfff10aa1dd172c74ea" => :mojave
    sha256 "7734ddb93d08115ca66a6f0055be6bedcd6221ee278dacb879a0575162677198" => :high_sierra
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
